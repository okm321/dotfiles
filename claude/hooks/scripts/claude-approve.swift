import AppKit
import SwiftUI
import Foundation
import Combine

// MARK: - Constants

let socketPath = "/tmp/claude-approve.sock"
let pidFile = "/tmp/claude-approve.pid"
let muteFlag = "/tmp/claude-sound-muted"

// MARK: - Model

enum SessionStatus: String {
    case running
    case idle
    case waiting
    case permission
}

struct PendingPermission {
    let id: String
    let description: String
    let command: String
    let connection: Int32
    let hookPid: pid_t
}

struct Session: Identifiable {
    let id: String
    let name: String
    var window: String
    var project: String
    var status: SessionStatus
    var pendingPermission: PendingPermission?
    var waitingMessage: String?
    var lastUpdate: Date

    var displayName: String {
        if !name.isEmpty && !window.isEmpty {
            return "\(name) · \(window)"
        } else if !name.isEmpty {
            return name
        }
        return project
    }
}

// MARK: - Store

class SessionStore: ObservableObject {
    @Published var sessions: [Session] = []
    var onUpdate: (() -> Void)?

    private func key(session: String, window: String, project: String) -> String {
        if !session.isEmpty {
            return session
        }
        return project
    }

    func updateStatus(session: String, window: String, project: String, status: SessionStatus, message: String? = nil) {
        let session = session.trimmingCharacters(in: .whitespaces)
        let window = window.trimmingCharacters(in: .whitespaces)
        DispatchQueue.main.async {
            let k = self.key(session: session, window: window, project: project)
            if let idx = self.sessions.firstIndex(where: { $0.id == k }) {
                if let perm = self.sessions[idx].pendingPermission, status == .running {
                    close(perm.connection)
                    self.sessions[idx].pendingPermission = nil
                }
                if self.sessions[idx].pendingPermission == nil {
                    self.sessions[idx].status = status
                }
                self.sessions[idx].window = window
                self.sessions[idx].project = project
                self.sessions[idx].waitingMessage = status == .waiting ? message : nil
                self.sessions[idx].lastUpdate = Date()
            } else {
                self.sessions.append(Session(
                    id: k, name: session, window: window, project: project,
                    status: status, pendingPermission: nil,
                    waitingMessage: status == .waiting ? message : nil, lastUpdate: Date()
                ))
            }
            let shouldNotify = status == .waiting || status == .permission || status == .idle
            if shouldNotify && !FileManager.default.fileExists(atPath: muteFlag) {
                NSSound(named: "Glass")?.play()
            }
            self.onUpdate?()
        }
    }

    func addPermission(session: String, window: String, project: String, description: String, command: String, connection: Int32, hookPid: pid_t) {
        let session = session.trimmingCharacters(in: .whitespaces)
        let window = window.trimmingCharacters(in: .whitespaces)
        DispatchQueue.main.async {
            let k = self.key(session: session, window: window, project: project)
            let perm = PendingPermission(id: UUID().uuidString, description: description, command: command, connection: connection, hookPid: hookPid)

            if let idx = self.sessions.firstIndex(where: { $0.id == k }) {
                if let old = self.sessions[idx].pendingPermission {
                    _ = "deny".withCString { ptr in send(old.connection, ptr, strlen(ptr), 0) }
                    close(old.connection)
                }
                self.sessions[idx].pendingPermission = perm
                self.sessions[idx].status = .permission
                self.sessions[idx].window = window
                self.sessions[idx].project = project
                self.sessions[idx].lastUpdate = Date()
            } else {
                self.sessions.append(Session(
                    id: k, name: session, window: window, project: project,
                    status: .permission, pendingPermission: perm, lastUpdate: Date()
                ))
            }
            if !FileManager.default.fileExists(atPath: muteFlag) {
                NSSound(named: "Glass")?.play()
            }
            self.onUpdate?()

            self.monitorPermission(fd: connection, hookPid: hookPid, sessionKey: k)
        }
    }

    private func monitorPermission(fd: Int32, hookPid: pid_t, sessionKey: String) {
        let startTime = Date()
        DispatchQueue.global().async { [weak self] in
            while true {
                sleep(2)
                guard let self = self else { return }

                var stillPending = false
                DispatchQueue.main.sync {
                    if let idx = self.sessions.firstIndex(where: { $0.id == sessionKey }),
                       self.sessions[idx].pendingPermission?.connection == fd {
                        stillPending = true
                    }
                }
                guard stillPending else { return }

                let hookDead = hookPid > 0 && kill(hookPid, 0) != 0
                var socketDead = false
                if !hookDead {
                    var pollFd = pollfd(fd: fd, events: Int16(POLLIN), revents: 0)
                    let r = poll(&pollFd, 1, 0)
                    socketDead = r > 0 || pollFd.revents & Int16(POLLHUP | POLLERR | POLLNVAL) != 0
                }
                let timedOut = Date().timeIntervalSince(startTime) > 120

                if hookDead || socketDead || timedOut {
                    DispatchQueue.main.async {
                        guard let idx = self.sessions.firstIndex(where: { $0.id == sessionKey }),
                              self.sessions[idx].pendingPermission?.connection == fd else { return }
                        _ = "deny".withCString { ptr in send(fd, ptr, strlen(ptr), 0) }
                        close(fd)
                        self.sessions[idx].pendingPermission = nil
                        self.sessions[idx].status = .running
                        self.sessions[idx].lastUpdate = Date()
                        self.onUpdate?()
                    }
                    return
                }
            }
        }
    }

    func respondPermission(sessionId: String, approved: Bool) {
        DispatchQueue.main.async {
            guard let idx = self.sessions.firstIndex(where: { $0.id == sessionId }) else { return }
            if let perm = self.sessions[idx].pendingPermission {
                let msg = approved ? "allow" : "deny"
                _ = msg.withCString { ptr in send(perm.connection, ptr, strlen(ptr), 0) }
                close(perm.connection)
            }
            self.sessions[idx].pendingPermission = nil
            self.sessions[idx].status = .running
            self.sessions[idx].lastUpdate = Date()
            self.onUpdate?()
        }
    }

    func clearWaiting(sessionId: String) {
        DispatchQueue.main.async {
            if let idx = self.sessions.firstIndex(where: { $0.id == sessionId }) {
                self.sessions[idx].status = .running
                self.sessions[idx].waitingMessage = nil
                self.sessions[idx].lastUpdate = Date()
            }
            self.onUpdate?()
        }
    }

    func handleJump(sessionId: String) {
    }

    func removeSession(sessionId: String) {
        DispatchQueue.main.async {
            if let idx = self.sessions.firstIndex(where: { $0.id == sessionId }) {
                if let perm = self.sessions[idx].pendingPermission {
                    _ = "deny".withCString { ptr in send(perm.connection, ptr, strlen(ptr), 0) }
                    close(perm.connection)
                }
                self.sessions.remove(at: idx)
            }
            self.onUpdate?()
        }
    }

    func approveAll() {
        DispatchQueue.main.async {
            for i in self.sessions.indices {
                if let perm = self.sessions[i].pendingPermission {
                    _ = "allow".withCString { ptr in send(perm.connection, ptr, strlen(ptr), 0) }
                    close(perm.connection)
                    self.sessions[i].pendingPermission = nil
                    self.sessions[i].status = .running
                }
            }
            self.onUpdate?()
        }
    }

}

// MARK: - Views

struct SessionRow: View {
    let session: Session
    let onApprove: () -> Void
    let onDeny: () -> Void
    let onRespond: (String) -> Void
    let onJump: () -> Void
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)

                Button(action: onJump) {
                    HStack(spacing: 4) {
                        Text(session.displayName)
                            .font(.system(size: 11, weight: .medium))
                        Image(systemName: "arrow.right.square")
                            .font(.system(size: 9))
                    }
                    .foregroundColor(.purple)
                }
                .buttonStyle(.plain)
                .onHover { inside in
                    if inside { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }

                Spacer()

                Text(statusLabel)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(statusColor)

            }

            if let perm = session.pendingPermission {
                if !perm.description.isEmpty {
                    Text(perm.description)
                        .font(.system(size: 11))
                        .foregroundColor(.primary.opacity(0.85))
                }

                Text(perm.command)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(4)

                HStack(spacing: 6) {
                    Button(action: onDeny) {
                        Text("拒否")
                            .font(.system(size: 11, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(Color.primary.opacity(0.08))
                            .foregroundColor(.primary.opacity(0.7))
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)

                    Button(action: onApprove) {
                        Text("許可")
                            .font(.system(size: 11, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
            }

            if session.status == .waiting {
                if let msg = session.waitingMessage, !msg.isEmpty {
                    Text(msg)
                        .font(.system(size: 11))
                        .foregroundColor(.primary.opacity(0.85))
                        .lineLimit(3)
                }

                HStack(spacing: 6) {
                    Button(action: { onRespond("no") }) {
                        Text("No")
                            .font(.system(size: 11, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(Color.primary.opacity(0.08))
                            .foregroundColor(.primary.opacity(0.7))
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)

                    Button(action: { onRespond("yes") }) {
                        Text("Yes")
                            .font(.system(size: 11, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var statusColor: Color {
        switch session.status {
        case .running: return .green
        case .idle: return .gray
        case .waiting: return .orange
        case .permission: return .red
        }
    }

    private var statusLabel: String {
        switch session.status {
        case .running: return "実行中"
        case .idle: return "完了"
        case .waiting: return "入力待ち"
        case .permission: return "許可待ち"
        }
    }
}

struct PopoverView: View {
    @ObservedObject var store: SessionStore

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Claude Code")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                let permCount = store.sessions.filter { $0.status == .permission }.count
                if permCount > 1 {
                    Button("全て許可") { store.approveAll() }
                        .font(.system(size: 10))
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                }
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Image(systemName: "power")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .onHover { inside in
                    if inside { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()

            if store.sessions.isEmpty {
                Text("セッションなし")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(sortedSessions) { session in
                        SessionRow(
                            session: session,
                            onApprove: { store.respondPermission(sessionId: session.id, approved: true) },
                            onDeny: { store.respondPermission(sessionId: session.id, approved: false) },
                            onRespond: { text in
                                let isPermission = session.waitingMessage?.lowercased().contains("permission") == true
                                if isPermission && text == "yes" {
                                    sendToTmux(session: session.name, window: session.window, text: "1")
                                } else if isPermission && text == "no" {
                                    sendToTmux(session: session.name, window: session.window, text: "Escape", pressEnter: false)
                                } else {
                                    sendToTmux(session: session.name, window: session.window, text: text)
                                }
                                store.clearWaiting(sessionId: session.id)
                            },
                            onJump: {
                                jumpToSession(session.name, window: session.window)
                                store.handleJump(sessionId: session.id)
                            },
                            onRemove: { store.removeSession(sessionId: session.id) }
                        )
                        if session.id != sortedSessions.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(width: 300)
    }

    private var sortedSessions: [Session] {
        store.sessions.sorted { a, b in
            priority(a.status) > priority(b.status)
        }
    }

    private func priority(_ s: SessionStatus) -> Int {
        switch s {
        case .permission: return 3
        case .waiting: return 2
        case .running: return 1
        case .idle: return 0
        }
    }
}

// MARK: - Helpers

func sendToTmux(session: String, window: String, text: String, pressEnter: Bool = true) {
    guard !session.isEmpty else { return }
    let target = window.isEmpty ? session : "\(session):\(window)"
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/tmux")
    var args = ["send-keys", "-t", target, text]
    if pressEnter { args.append("Enter") }
    task.arguments = args
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice
    try? task.run()
    task.waitUntilExit()
}

func jumpToSession(_ session: String, window: String) {
    guard !session.isEmpty else { return }
    if let script = NSAppleScript(source: "tell application \"Ghostty\" to activate") {
        script.executeAndReturnError(nil)
    }
    let target = window.isEmpty ? session : "\(session):\(window)"
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/tmux")
    task.arguments = ["select-window", "-t", target]
    try? task.run()
    task.waitUntilExit()
    let task2 = Process()
    task2.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/tmux")
    task2.arguments = ["switch-client", "-t", target]
    try? task2.run()
}

// MARK: - Icon

func createClaudeIcon() -> NSImage {
    let size: CGFloat = 18
    let image = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
        guard let ctx = NSGraphicsContext.current?.cgContext else { return false }

        ctx.setStrokeColor(NSColor.black.cgColor)
        ctx.setLineWidth(2.0)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)

        // ">" chevron
        ctx.move(to: CGPoint(x: 2, y: 14))
        ctx.addLine(to: CGPoint(x: 8.5, y: 9))
        ctx.addLine(to: CGPoint(x: 2, y: 4))
        ctx.strokePath()

        // "_" cursor
        ctx.move(to: CGPoint(x: 10, y: 4))
        ctx.addLine(to: CGPoint(x: 16, y: 4))
        ctx.strokePath()

        return true
    }
    image.isTemplate = true
    return image
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    let store: SessionStore
    var server: SocketServer!
    private var cancellables = Set<AnyCancellable>()
    private var cleanupTimer: Timer?

    init(store: SessionStore) {
        self.store = store
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateIcon()

        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
        }

        popover = NSPopover()
        let hostingController = NSHostingController(rootView: PopoverView(store: store))
        hostingController.sizingOptions = [.preferredContentSize]
        popover.contentViewController = hostingController
        popover.behavior = .transient

        store.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateIcon()
                let needsAttention = self?.store.sessions.contains {
                    $0.status == .permission || $0.status == .waiting || $0.status == .idle
                } ?? false
                if needsAttention { self?.showPopoverQuietly() }
                // SwiftUIレンダリング後にポップオーバーサイズ更新
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.resizePopover()
                }
            }
        }

        store.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.updateIcon()
            }
        }.store(in: &cancellables)

        server = SocketServer(store: store)
        server.start()
        syncSessions()

        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.syncSessions()
        }
    }

    func syncSessions() {
        DispatchQueue.global().async { [weak self] in
            // Claude PIDを取得
            guard let psOutput = Self.runCommand("/bin/ps", ["-eo", "pid,command"]) else { return }
            var claudePIDs: [String] = []
            for line in psOutput.split(separator: "\n") {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.contains(".local/bin/claude") && !trimmed.contains("CCWatcher") {
                    if let pid = trimmed.split(separator: " ").first {
                        claudePIDs.append(String(pid))
                    }
                }
            }

            // tmux pane PID → session/window マップ
            let paneOutput = Self.runCommand("/opt/homebrew/bin/tmux", ["list-panes", "-a", "-F", "#{pane_pid}|#{session_name}|#{window_name}"]) ?? ""
            var paneMap: [String: (session: String, window: String)] = [:]
            for line in paneOutput.split(separator: "\n") {
                let parts = line.split(separator: "|", maxSplits: 2).map(String.init)
                guard parts.count >= 3 else { continue }
                paneMap[parts[0]] = (session: parts[1].trimmingCharacters(in: .whitespaces), window: parts[2].trimmingCharacters(in: .whitespaces))
            }

            // プロセスの親子関係マップ
            let ppidOutput = Self.runCommand("/bin/ps", ["-eo", "pid,ppid"]) ?? ""
            var parentMap: [String: String] = [:]
            for line in ppidOutput.split(separator: "\n") {
                let cols = line.split(whereSeparator: { $0.isWhitespace }).map(String.init)
                guard cols.count >= 2 else { continue }
                parentMap[cols[0]] = cols[1]
            }

            var activeTmuxSessions = Set<String>()
            var newEntries: [(session: String, window: String, project: String)] = []
            var seenSessions = Set<String>()

            for pid in claudePIDs {
                // プロセスツリーを辿ってtmux paneを特定
                var bestSession = "", bestWindow = ""
                var current = pid
                for _ in 0..<20 {
                    if let pane = paneMap[current] {
                        bestSession = pane.session
                        bestWindow = pane.window
                        break
                    }
                    guard let parent = parentMap[current], parent != "0", parent != "1", parent != current else { break }
                    current = parent
                }

                // CWDからプロジェクト名を取得
                var project = "Unknown"
                if let lsofOutput = Self.runCommand("/usr/sbin/lsof", ["-a", "-p", pid, "-d", "cwd", "-Fn"]) {
                    for lline in lsofOutput.split(separator: "\n") {
                        if lline.hasPrefix("n/") {
                            project = String(String(lline.dropFirst()).split(separator: "/").last ?? "Unknown")
                            break
                        }
                    }
                }

                if !bestSession.isEmpty {
                    activeTmuxSessions.insert(bestSession)
                }

                let dedup = bestSession.isEmpty ? "\0\(project)" : bestSession
                if seenSessions.insert(dedup).inserted {
                    newEntries.append((session: bestSession, window: bestWindow, project: project))
                }
            }

            DispatchQueue.main.async {
                guard let self = self else { return }

                var changed = false
                for entry in newEntries {
                    guard !entry.session.isEmpty else { continue }
                    let exists = self.store.sessions.contains { $0.name == entry.session }
                    if !exists {
                        self.store.sessions.append(Session(
                            id: entry.session, name: entry.session, window: entry.window, project: entry.project,
                            status: .idle, pendingPermission: nil, waitingMessage: nil, lastUpdate: Date()
                        ))
                        changed = true
                    }
                }

                for i in (0..<self.store.sessions.count).reversed() {
                    let s = self.store.sessions[i]
                    if s.pendingPermission != nil { continue }
                    if s.status == .waiting { continue }
                    let alive = !s.name.isEmpty ? activeTmuxSessions.contains(s.name) : claudePIDs.count > 0
                    if !alive {
                        self.store.sessions.remove(at: i)
                        changed = true
                    }
                }
                if changed { self.store.onUpdate?() }
            }
        }
    }

    static func runCommand(_ path: String, _ args: [String]) -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: path)
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        try? task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        return String(data: data, encoding: .utf8)
    }

    func updateIcon() {
        guard let button = statusItem.button else { return }
        button.image = createClaudeIcon()

        let actionCount = store.sessions.filter { $0.status == .permission || $0.status == .waiting }.count
        button.title = actionCount > 0 ? " \(actionCount)" : ""
    }

    @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            showPopover()
        }
    }

    func showPopover() {
        guard let button = statusItem.button else { return }
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    func showPopoverQuietly() {
        guard let button = statusItem.button else { return }
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    func resizePopover() {
        guard popover.isShown, let vc = popover.contentViewController else { return }
        vc.view.invalidateIntrinsicContentSize()
        let size = vc.view.fittingSize
        if size.width > 0 && size.height > 0 {
            popover.contentSize = size
        }
    }
}

// MARK: - Socket Server

class SocketServer {
    let store: SessionStore
    private var serverFd: Int32 = -1

    init(store: SessionStore) {
        self.store = store
    }

    func start() {
        unlink(socketPath)
        serverFd = socket(AF_UNIX, SOCK_STREAM, 0)
        guard serverFd >= 0 else { return }

        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        withUnsafeMutablePointer(to: &addr.sun_path) { ptr in
            socketPath.withCString { src in
                _ = strcpy(UnsafeMutableRawPointer(ptr).assumingMemoryBound(to: CChar.self), src)
            }
        }

        let bindResult = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockPtr in
                bind(serverFd, sockPtr, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard bindResult == 0 else { return }

        listen(serverFd, 10)
        try? "\(ProcessInfo.processInfo.processIdentifier)".write(toFile: pidFile, atomically: true, encoding: .utf8)

        DispatchQueue.global().async { [weak self] in
            while true {
                let clientFd = accept(self?.serverFd ?? -1, nil, nil)
                guard clientFd >= 0 else { break }
                self?.handleClient(clientFd)
            }
        }
    }

    private func handleClient(_ fd: Int32) {
        var buffer = [CChar](repeating: 0, count: 4096)
        let bytesRead = recv(fd, &buffer, buffer.count - 1, 0)
        guard bytesRead > 0 else { close(fd); return }

        let data = String(cString: buffer)
        guard let jsonData = data.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String] else {
            close(fd)
            return
        }

        let action = json["action"] ?? "status"
        let session = json["session"] ?? ""
        let window = json["window"] ?? ""
        let project = json["project"] ?? ""

        switch action {
        case "permission":
            let hookPid = pid_t(json["hookPid"] ?? "0") ?? 0
            store.addPermission(
                session: session, window: window, project: project,
                description: json["description"] ?? "",
                command: json["command"] ?? "",
                connection: fd,
                hookPid: hookPid
            )
        default:
            let status = SessionStatus(rawValue: json["status"] ?? "running") ?? .running
            store.updateStatus(session: session, window: window, project: project, status: status, message: json["message"])
            close(fd)
        }
    }

    func stop() {
        if serverFd >= 0 { close(serverFd) }
        unlink(socketPath)
        try? FileManager.default.removeItem(atPath: pidFile)
    }
}

// MARK: - Client

func connectToSocket() -> Int32? {
    let fd = socket(AF_UNIX, SOCK_STREAM, 0)
    guard fd >= 0 else { return nil }

    var addr = sockaddr_un()
    addr.sun_family = sa_family_t(AF_UNIX)
    withUnsafeMutablePointer(to: &addr.sun_path) { ptr in
        socketPath.withCString { src in
            _ = strcpy(UnsafeMutableRawPointer(ptr).assumingMemoryBound(to: CChar.self), src)
        }
    }

    let result = withUnsafePointer(to: &addr) { ptr in
        ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockPtr in
            connect(fd, sockPtr, socklen_t(MemoryLayout<sockaddr_un>.size))
        }
    }
    guard result == 0 else { close(fd); return nil }
    return fd
}

func sendJSON(_ json: [String: String], to fd: Int32) {
    guard let data = try? JSONSerialization.data(withJSONObject: json),
          let str = String(data: data, encoding: .utf8) else { return }
    _ = str.withCString { ptr in send(fd, ptr, strlen(ptr), 0) }
}

func sendStatus(status: String, session: String, window: String, project: String, message: String = "") {
    guard let fd = connectToSocket() else { return }
    var json = ["action": "status", "session": session, "window": window, "project": project, "status": status]
    if !message.isEmpty { json["message"] = message }
    sendJSON(json, to: fd)
    close(fd)
}

func sendPermissionRequest(description: String, command: String, session: String, window: String, project: String) -> Bool {
    guard let fd = connectToSocket() else { return false }

    // recvタイムアウト: ターミナルで承認された場合にフックがゾンビ化しないようにする
    var tv = timeval(tv_sec: 60, tv_usec: 0)
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, socklen_t(MemoryLayout<timeval>.size))

    sendJSON([
        "action": "permission",
        "session": session, "window": window, "project": project,
        "description": description, "command": command,
        "hookPid": "\(getppid())"
    ], to: fd)

    var buffer = [CChar](repeating: 0, count: 256)
    let bytesRead = recv(fd, &buffer, buffer.count - 1, 0)
    close(fd)

    guard bytesRead > 0 else { return false }
    return String(cString: buffer) == "allow"
}

// MARK: - Main

signal(SIGPIPE, SIG_IGN)

let args = CommandLine.arguments
let subcommand = args.count >= 2 ? args[1] : ""

if subcommand == "" || subcommand == "daemon" {
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)

    let store = SessionStore()
    let delegate = AppDelegate(store: store)
    app.delegate = delegate

    signal(SIGTERM) { _ in
        unlink(socketPath)
        try? FileManager.default.removeItem(atPath: pidFile)
        exit(0)
    }

    app.run()

} else if subcommand == "status" {
    // status <status> <session> <window> <project> [message]
    let status = args.count > 2 ? args[2] : "running"
    let session = args.count > 3 ? args[3] : ""
    let window = args.count > 4 ? args[4] : ""
    let project = args.count > 5 ? args[5] : ""
    let message = args.count > 6 ? args[6] : ""

    sendStatus(status: status, session: session, window: window, project: project, message: message)
    exit(0)

} else if subcommand == "request" {
    // request <tool> <desc> <cmd> <session> <window> <project>
    let desc = args.count > 3 ? args[3] : ""
    let cmd = args.count > 4 ? args[4] : ""
    let session = args.count > 5 ? args[5] : ""
    let window = args.count > 6 ? args[6] : ""
    let project = args.count > 7 ? args[7] : ""

    let approved = sendPermissionRequest(description: desc, command: cmd, session: session, window: window, project: project)
    exit(approved ? 0 : 1)

} else if subcommand == "stop" {
    if let pidStr = try? String(contentsOfFile: pidFile, encoding: .utf8),
       let pid = Int32(pidStr.trimmingCharacters(in: .whitespacesAndNewlines)) {
        kill(pid, SIGTERM)
    }
    exit(0)

} else {
    fputs("Usage:\n  ClaudeApprove          (start app)\n  claude-approve status <status> <session> <project>\n  claude-approve request <tool> <desc> <cmd> <session> <project>\n  claude-approve stop\n", stderr)
    exit(1)
}
