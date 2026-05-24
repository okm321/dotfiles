.PHONY: switch update gc check show help setup setup-nix setup-host setup-initial setup-shell

FLAKE := $(HOME)/dotfiles/nix

# HOST の優先順位:
#  1. 環境変数 / コマンドライン引数 (例: make switch HOST=macbook-oned)
#  2. ~/dotfiles/.nix-host ファイル (各マシン固有、gitignored)
#  3. fallback: macbook-casone
HOST ?= $(shell cat $(HOME)/dotfiles/.nix-host 2>/dev/null || echo macbook-casone)

# Nix のコマンドは setup 直後 PATH に入ってないので絶対パスを使う
NIX := /nix/var/nix/profiles/default/bin/nix

help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  current HOST: \033[33m$(HOST)\033[0m"

# --- 日常運用 ---

switch: ## nix-darwin + Home Manager をビルドして反映 (nix/ 配下を自動 stage)
	@git -C $(HOME)/dotfiles add -A nix/
	sudo darwin-rebuild switch --flake $(FLAKE)#$(HOST)

update: ## flake input を全て最新化
	nix flake update --flake $(FLAKE)

gc: ## /nix/store の不要な世代を一括削除
	sudo nix-collect-garbage -d
	nix-collect-garbage -d

check: ## flake の評価チェック (構文 / 依存)
	nix flake check $(FLAKE)

show: ## flake.nix の outputs (= 利用可能な darwinConfigurations) を表示
	nix flake show $(FLAKE)

reload-ui: ## SystemUIServer / Dock / Finder を再起動して system.defaults 変更を即反映
	@echo "🔄 reloading SystemUIServer (menu bar)..."
	sudo killall SystemUIServer || true
	@echo "🔄 reloading Dock..."
	killall Dock || true
	@echo "🔄 reloading Finder..."
	killall Finder || true
	@echo "✓ done. キーボード/トラックパッド系は再ログインが必要"

# --- 新 PC 初回セットアップ ---
# 使い方:
#   1. git clone https://github.com/okm321/dotfiles ~/dotfiles
#   2. cd ~/dotfiles && make setup HOST=macbook-oned

setup: setup-nix setup-host setup-initial setup-shell ## 新 PC 初回セットアップ (例: make setup HOST=macbook-oned)
	@echo
	@echo "🎉 Setup complete! 新しいターミナルを開いてください"
	@echo "  - 各 App の Accessibility 権限 (Aerospace, Raycast, ghostty) を System Settings で許可"
	@echo "  - 各 App のログイン (Slack, Notion, Chrome, etc.)"
	@echo "  - Mac App Store にサインイン (Xcode, Kindle 用)"

setup-nix: ## Nix を install (まだの場合)
	@if ! command -v nix > /dev/null 2>&1 && [ ! -x $(NIX) ]; then \
		echo "📦 Installing Nix (Determinate installer)..."; \
		curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install; \
	else \
		echo "✓ Nix already installed"; \
	fi

setup-host: ## .nix-host を HOST 引数で設定 (make setup-host HOST=macbook-oned)
	@echo "$(HOST)" > $(HOME)/dotfiles/.nix-host
	@echo "✓ .nix-host = $(HOST)"

setup-initial: ## 初回 darwin-rebuild switch (nix run 経由、Homebrew 本体含めて全 install)
	sudo $(NIX) run nix-darwin/nix-darwin-25.11 -- switch --flake $(FLAKE)#$(HOST)

setup-shell: ## デフォルトシェルを Nix の zsh に変更
	sudo chsh -s /run/current-system/sw/bin/zsh $(USER)
