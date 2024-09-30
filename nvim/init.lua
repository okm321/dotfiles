-- Load the package manager: LazyVim
require("plugin_manager")
require("config")

-- Load and configure plugins
require("lazy").setup({
	-- Load all plugins from the "plugins" directory
	{ import = "plugins" },
})