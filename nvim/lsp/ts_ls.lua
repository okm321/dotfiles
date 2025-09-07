vim.lsp.config("ts_ls", {
	workspace_required = true,
	root_markers = { ".git", "tsconfig.json", "package.json" },
	settings = {
		typescript = {
			preferences = {
				includePackageJsonAutoImports = "on",
			},
			tsserver = {
				enableProjectDiagnostics = true,
			},
		},
	},
	capabilities = {
		workspace = {
			workspaceEdit = {
				documentChanges = true,
			},
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
})
