return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000,
	config = function()
		require("everforest").setup({
			transparent_background_level = 2,
			on_highlights = function(hl, palette)
				hl.CursorLine = { bg = palette.bg3 }
				hl.NeoTreeDirectoryIcon = { link = "Green" }
				hl.NeoTreeGitAdded = { link = "Green" }
				hl.NeoTreeGitConflict = { link = "Yellow" }
				hl.NeoTreeGitDeleted = { link = "Red" }
				hl.NeoTreeGitIgnored = { link = "Grey" }
				hl.NeoTreeGitModified = { link = "Blue" }
				hl.NeoTreeGitUnstaged = { link = "Purple" }
				hl.NeoTreeGitUntracked = { link = "Aqua" }
				hl.NeoTreeGitStaged = { link = "Purple" }
				hl.NeoTreeDimText = { link = "Grey" }
				-- hl.NeoTreeSignColumn = { link = "Orange" }
				hl.NeoTreeRootName = { link = "Green" }
				-- barbar
				hl.BufferCurrent = { fg = palette.fg, bg = palette.bg2 }
				hl.BufferCurrentIndex = { fg = palette.fg, bg = palette.bg2 }
				hl.BufferCurrentMod = { fg = palette.blue, bg = palette.bg2 }
				hl.BufferCurrentSign = { fg = palette.statusline1, bg = palette.bg2 }
				hl.BufferCurrentTarget = { fg = palette.red, bg = palette.bg2, bold = true }
				hl.BufferCurrentADDED = { fg = palette.green, bg = palette.bg2 }
				hl.BufferCurrentCHANGED = { fg = palette.blue, bg = palette.bg2 }
				hl.BufferCurrentDELETED = { fg = palette.red, bg = palette.bg2 }
				hl.BufferCurrentERROR = { fg = palette.red, bg = palette.bg2 }
				hl.BufferCurrentHINT = { fg = palette.yellow, bg = palette.bg2 }
				hl.BufferCurrentINFO = { fg = palette.aqua, bg = palette.bg2 }
				hl.BufferCurrentWARN = { fg = palette.orange, bg = palette.bg2 }
				hl.BufferVisible = { fg = palette.grey1 }
			end,
			--[[ colours_override = function(palette)
				palette.statusline1 = palette.none
			end, ]]
		})
		vim.cmd("colorscheme everforest")
	end,
}
