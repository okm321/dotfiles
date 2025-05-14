vim.lsp.config("dockerls", {
  settings = {
    docker = {
	    languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
	    },
    }
  }
})
