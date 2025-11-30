local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "morhetz/gruvbox" },
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },
  { "tpope/vim-commentary" },
  { "tpope/vim-fugitive" },
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "npm ci",
  },
  { "antoinemadec/coc-fzf" },
  { "ntpeters/vim-better-whitespace" },
  { "othree/html5.vim" },
  { "pangloss/vim-javascript" },
  {
    "evanleck/vim-svelte",
    branch="main"
  },
  {"prisma/vim-prisma"}
})
