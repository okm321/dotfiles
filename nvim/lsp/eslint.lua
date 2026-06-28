return {
	on_init = function(client)
		local root = client.config.root_dir
		if root then
			client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
				nodePath = root .. "/node_modules",
				workingDirectories = { mode = "auto" },
			})
		end
	end,
	settings = {
		workingDirectories = { mode = "auto" },
		experimental = {
			useFlatConfig = true,
		},
	},
}
