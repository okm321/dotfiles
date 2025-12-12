return {
	"folke/sidekick.nvim",
	opts = {
		-- add any options here
		cli = {
			mux = {
				backend = "tmux",
				enabled = false,
			},
			win = {
				split = {
					width = 70,
				},
				keys = {
					hide_t = { "<c-q>Q", "hide" },
				},
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
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
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
      function() require("sidekick.cli").focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
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
