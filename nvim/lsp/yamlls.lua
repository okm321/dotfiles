return {
	root_markers = { ".git", "package.json", ".yamllint" },
	single_file_support = false,
	settings = {
		yaml = {
			validate = false,
			schemaStore = { enable = false },
			format = { enable = false },
		},
	},
}
