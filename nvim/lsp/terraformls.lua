-- .tfファイルを初めて開いた時に、filetypeがtfになってしまう対処法
vim.filetype.add({
  extension = {
    tf = "terraform"
  }
})

vim.lsp.config("terraformls", {
  filetypes = {
    "terraform",
    "terraform-vars",
  }
})
