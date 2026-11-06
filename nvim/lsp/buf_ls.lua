-- buf.yaml 等を buf-config filetype として認識させる (lspconfig の buf_ls が対象にする)
vim.filetype.add({
	filename = {
		["buf.yaml"] = "buf-config",
		["buf.gen.yaml"] = "buf-config",
		["buf.policy.yaml"] = "buf-config",
		["buf.lock"] = "buf-config",
	},
})
vim.treesitter.language.register("yaml", "buf-config")

return {}
