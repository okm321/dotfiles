return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")
		vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")
		vim.keymap.set("n", "<leader>th", "<Cmd>BufferLineCloseOthers<CR>")
		vim.keymap.set("n", "<leader>pb", "<Cmd>BufferLinePick<CR>")

		local nordColors = require("nord.colors")

		local highlights = require("nord").bufferline.highlights({
			indicator_visible = {
				fg = nordColors.nord14_gui,
			},
			indicator_selected = {
				fg = nordColors.nord14_gui,
			},
			diagnostic_visible = {
				fg = nordColors.nord14_gui,
				sp = nordColors.nord10_gui,
				bold = true,
				italic = true,
			},
			italic = true,
			bold = true,
		})

		for _, value in pairs(highlights) do -- バッファラインの全ての背景色を透過
			if type(value) == "table" and value.bg ~= nil then
				value.bg = "NONE"
			end
		end

		require("bufferline").setup({
			options = {
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. n .. sym .. " "
					end
					return s
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "    ",
						separator = true,
					},
				},
				show_close_icon = false,
				show_buffer_close_icons = false,
				separator_style = "slope",
			},
			highlights = highlights,
		})
	end,
}
