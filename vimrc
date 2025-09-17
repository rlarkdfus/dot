call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim',  {'branch': 'master', 'do': 'npm ci'}
Plug 'antoinemadec/coc-fzf'

call plug#end()

syntax on

autocmd FileType cpp nnoremap <f7> :!g++ --std=c++17 % && ./a.out <CR>
autocmd FileType python nnoremap <f7> :!python3 % <CR>
autocmd FileType python set sw=4 ts=4

set expandtab
set background=dark
set clipboard=

highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

imap jj <Esc>
imap uu <Esc>u

set number
set ruler
set hlsearch
set breakindent
set laststatus=2
set sw=2 ts=2
set backspace=indent,eol,start
set autoindent
set cursorline
set belloff=all
set mouse=a
set fo-=t

let g:gruvbox_italic=0
let g:gruvbox_termcolors=16
colorscheme gruvbox

let mapleader=" "

nnoremap <leader>f :Files<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>? :RG<CR>

nnoremap <C-b> :%y+ <CR>
nnoremap <C-c> "+yy
vnoremap <C-c> "+y
nnoremap <C-v> "+p

map <F5> :wall!<CR>:!sbcl --load foo.cl<CR><CR>

nmap <leader><leader> :call Format()<CR>
nmap <leader>cl        <Plug>(coc-codelens-action)
xmap <silent><leader>a <Plug>(coc-codeaction-selected)
nmap <silent><leader>a <Plug>(coc-codeaction-selected)
nmap <silent>[g        <Plug>(coc-diagnostic-prev)
nmap <silent>]g        <Plug>(coc-diagnostic-next)
nmap <silent>gd        <Plug>(coc-definition)
nmap <silent>gy        <Plug>(coc-type-definition)
nmap <silent>gr        <Plug>(coc-rename)
nmap <silent>ge        <Plug>(coc-references)

nnoremap <silent> <space>c       :<C-u>CocFzfList commands<CR>
nnoremap gR           *:%s///gc<left><left><left>
nnoremap <silent> ff  :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-k> coc#refresh()
nnoremap <Tab>        bb <c-^><cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
