require("plugins")

-- Settings
vim.opt.termguicolors = false
vim.opt.syntax = "on"
vim.opt.expandtab = true
vim.opt.background = "dark"
vim.opt.clipboard = ""
vim.opt.number = true
vim.opt.ruler = true
vim.opt.hlsearch = true
vim.opt.breakindent = true
vim.opt.laststatus = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.belloff = "all"
vim.opt.mouse = "a"
vim.opt.formatoptions:remove("t")

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight settings
vim.cmd [[
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
]]

-- Gruvbox config
vim.g.gruvbox_italic = 0
vim.g.gruvbox_termcolors = 16
vim.cmd.colorscheme("gruvbox")

-- Leader
vim.g.mapleader = " "

-- Insert mode mappings
vim.keymap.set("i", "jj", "<Esc>")
-- vim.keymap.set("i", "uu", "<Esc>u")

-- FileType-specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", "<F7>", ":!g++ --std=c++17 % && ./a.out<CR>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<F7>", ":!python3 %<CR>", { buffer = true })
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

local function format()
    vim.fn.CocAction('format')
end

-- Keymaps
vim.keymap.set("n", "<leader>f", ":GFiles<CR>")
vim.keymap.set("n", "<leader>/", ":Rg<CR>")
vim.keymap.set("n", "<leader>?", ":BLines<CR>")

vim.keymap.set("n", "<C-b>", ":%y+<CR>")
vim.keymap.set("n", "<C-c>", '"+yy')
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-v>", '"+p')

vim.keymap.set("n", "<F5>", ":wall!<CR>:!sbcl --load foo.cl<CR><CR>")
vim.keymap.set('n', '<leader><leader>', format, { silent = true })
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", { silent = true })
vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", { silent = true })
vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", { silent = true })
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-rename)", { silent = true })
vim.keymap.set("n", "ge", "<Plug>(coc-references)", { silent = true })
vim.keymap.set("n", "<space>c", ":<C-u>CocFzfList commands<CR>", { silent = true })
vim.keymap.set("n", "gR", "*:%s///gc<left><left><left>")
vim.keymap.set("n", "ff", ":lua ShowDocumentation()<CR>", { silent = true })
vim.keymap.set("i", "<C-k>", 'coc#refresh()', { expr = true, silent = true })
vim.keymap.set("n", "<Tab>", "bb<c-^><cr>")
vim.opt.signcolumn = "yes"

vim.keymap.set("n", "<leader>w", ":ToggleWhitespace<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":e!<CR>", { silent = true })


-- Function for documentation
function ShowDocumentation()
  local filetype = vim.bo.filetype
  local word = vim.fn.expand("<cword>")
  if filetype == "vim" or filetype == "help" then
    vim.cmd("h " .. word)
  elseif vim.fn["coc#rpc#ready"]() == 1 then
    vim.fn.CocActionAsync("doHover")
  else
    vim.cmd("!" .. vim.o.keywordprg .. " " .. word)
  end
end

