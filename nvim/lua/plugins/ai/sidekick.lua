return {
	"folke/sidekick.nvim",
	opts = {
		-- add any options here
		cli = {
			mux = {
				backend = "tmux",
				enabled = true,    -- 外部 tmux ペインを使う (内部 :terminal モードを止める)
				create = "split",  -- 既存 pane が無ければ自動で split 作成 (sidekick が既存検出すれば attach)
			},
			-- Claude Code の OSC 52 DCS wrap (tmux 検知時) を抑止
			-- TMUX のみ空にすることで Claude Code が tmux 検知失敗 → 生 OSC 52 を発行
			-- → Neovim :terminal の libvterm が OSC 52 を直接ハンドリング (Neovim 0.10+)
			-- TMUX_PANE は維持: tmux-agent-sidebar の hook が pane 特定に使うため必要
			tools = {
				claude = {
					env = {
						TMUX = "",
					},
				},
			},
			win = {
				split = {
					width = 100,
				},
				keys = {
					hide_t = { "<c-q>Q", "hide" },
				},
			},
			prompts = {
				createPR = "/commit-commands:commit-push-pr .github/PULL_REQUEST_TEMPLATE.mdを使って。targetブランチは",
				plan = "/plan\n\n## タスク\n\n\n## 対象コード\n\n```\n\n```\n\n## 参考\n\n\n## 前提条件\n\n\n## 制約\n",
			},
		},
	},
	config = function(_, opts)
		require("sidekick").setup(opts)

		local colors = require("nord.named_colors")

		local function set_sidekick_hl()
			vim.api.nvim_set_hl(0, "SidekickDiffAdd", { fg = colors.green })
			vim.api.nvim_set_hl(0, "SidekickDiffDelete", { fg = colors.red })
			vim.api.nvim_set_hl(0, "SidekickDiffContext", { fg = colors.purple })
			vim.api.nvim_set_hl(0, "SidekickSign", { fg = colors.dark_gray })
			vim.api.nvim_set_hl(0, "SidekickChat", { fg = nil, bg = colors.dark_gray })
		end

		set_sidekick_hl()

		vim.api.nvim_create_autocmd("ColorScheme", {
			desc = "Sidekick highlight adjustments",
			callback = set_sidekick_hl,
		})
	end,
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      -- function() require("sidekick.cli").select() end,
      function() require("sidekick.cli").select({ filter = { installed = true } }) end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>at",
      function() require("config.sidekick_helper").send_and_focus("{this}") end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>av",
      function() require("config.sidekick_helper").send_and_focus("{selection}") end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>af",
      function() require("config.sidekick_helper").send_and_focus("{file}") end,
      desc = "Send File",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<c-t>",
      function() require("config.sidekick_helper").toggle_pane_focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus (tmux pane)",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>acc",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick Toggle Claude",
    },
    {
      "<leader>acd",
      function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
      desc = "Sidekick Toggle Codex",
    },
    {
      "<leader>acg",
      function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end,
      desc = "Gemini Toggle Codex",
    },
  },
}
