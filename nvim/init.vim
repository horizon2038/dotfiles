"keymap"
inoremap <silent> jj <ESC>
tnoremap <C-w>n <C-\><C-n>
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
nmap <silent> cdf <Plug>(coc-definition)
nmap <silent> crf <Plug>(coc-references)
nmap <silent> crn <Plug>(coc-rename)
nmap <silent> cfmt <Plug>(coc-format)
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<Enter>"
nnoremap <F2> :NERDTreeToggle<cr>

"alias"
:command Bd BufDel
:command Bda BufDelAll
:command Bdo BufDelOther

:command Mdp MarkdownPreview
:command Mdps MarkdownPreviewStop
:command Mdpt MarkdownPreviewToggle

"theme"
set number
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:_
set smartindent
set autoindent
set smarttab
set incsearch
syntax on
set termguicolors

colorscheme iceberg
" colorscheme nordic

set guifont=Hack:h11

"status bar"
set laststatus=2
set statusline=file:%f
set statusline+=%r
set statusline+=%=
set statusline+=E:%{&fileencoding}
set statusline+=\  
set statusline+=L:%l/%L

"other"
set ttimeoutlen=10

"file specific"
let _curfile=expand("%:r")
if _curfile == "Makefile"
    set noexpandtab
endif

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 shiftwidth=2
augroup END

"plug-in"
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'Shougo/ddc.vim'
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-file'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-converter_remove_overlap'
Plug 'Shougo/ddc-ui-native'
Plug 'vim-denops/denops.vim'
Plug 'hrsh7th/nvim-cmp'

Plug 'ojroques/nvim-bufdel'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.2'}
Plug 'kylechui/nvim-surround'

Plug 'rust-lang/rust.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'tpope/vim-fugitive'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }

Plug 'winter-again/wezterm-config.nvim', { 'config': 'true' }

call plug#end()

"plug-in settings"
let g:airline_theme = 'deus'
"let g:airline_theme = 'minimalist'"
let g:airline_deus_bg = 'dark'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1

"autocmd vimenter * NERDTree"
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.DS_Store$','\.[oa]$']

lua require("nvim-surround").setup()

lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {
        }
    }
}
EOF

let g:mkdp_command_for_global = 1

lua <<EOF
-- vim.cmd.colorscheme "catppuccin-frappe"
-- vim.cmd.colorscheme "nordic"
EOF

