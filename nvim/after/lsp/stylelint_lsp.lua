return {
	cmd = { "stylelint-lsp", "--stdio" },
	filetypes = { "css", "scss", "less", "postcss" },
	root_markers = {
		".stylelintrc",
		".stylelintrc.json",
		".stylelintrc.js",
		".stylelintrc.cjs",
		".stylelintrc.mjs",
		".stylelintrc.yaml",
		".stylelintrc.yml",
		"stylelint.config.js",
		"stylelint.config.cjs",
		"stylelint.config.mjs",
		"package.json",
	},
	settings = {
		stylelintplus = {
			autoFixOnSave = false,
			autoFixOnFormat = false,
			validateOnSave = true,
			validateOnType = true,
		},
	},
}
