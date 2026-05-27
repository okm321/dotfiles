local M = {}

-- sidekick の外部 tmux モードでは sidekick.cli.send({ focus = true }) が効かない
-- (state.terminal が nil で focus 処理がスキップされる)。
-- そこで send 後に sidekick が管理する tmux_pane_id を取得して
-- tmux select-pane で確実に focus 移動する。
---@param msg string sidekick.cli.send に渡す msg ("{file}", "{this}", "{selection}" 等)
function M.send_and_focus(msg)
  local State = require("sidekick.cli.state")
  require("sidekick.cli").send({ msg = msg })

  -- send は内部で vim.schedule なので即取得は session 未確定の可能性。
  -- 短い defer で待ってから tmux_pane_id 取得 → select-pane
  vim.defer_fn(function()
    State.with(function(state)
      local pane_id = state.session and state.session.tmux_pane_id
      if pane_id then
        vim.fn.system({ "tmux", "select-pane", "-t", pane_id })
      end
    end, { attach = true })
  end, 100)
end

-- sidekick が管理する tmux pane に toggle 移動
-- すでにその pane にいる場合は tmux last-pane で元に戻る
function M.toggle_pane_focus()
  local State = require("sidekick.cli.state")
  State.with(function(state)
    local pane_id = state.session and state.session.tmux_pane_id
    if not pane_id then return end
    local current = vim.fn.system({ "tmux", "display-message", "-p", "#{pane_id}" }):gsub("%s+", "")
    if current == pane_id then
      vim.fn.system({ "tmux", "last-pane" })
    else
      vim.fn.system({ "tmux", "select-pane", "-t", pane_id })
    end
  end, { attach = true })
end

return M
