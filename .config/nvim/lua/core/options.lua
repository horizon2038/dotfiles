local vim_option = vim.opt
local vim_global = vim.g

-- common configuration
vim_option.number = true
vim_option.hlsearch = true
vim_option.expandtab = true
vim_option.tabstop = 4
vim_option.shiftwidth = 4
vim_option.list = true
vim_option.listchars = {
    tab = '»-',
    trail = '-',
    eol = '↲',
    extends = '»',
    precedes = '«',
    nbsp = '%',
    space = '_'
}
vim_option.smartindent = true
vim_option.autoindent = true
vim_option.smarttab = true
vim_option.incsearch = true
vim.cmd('syntax on')
vim_option.termguicolors = true
vim_option.ttimeoutlen = 10

-- status line configuration
vim_option.laststatus = 2
vim_option.statusline = table.concat({
    "file:%f",
    "%r",
    "%= ",
    "E:%{&fileencoding}",
    "  ",
    "L:%l/%L",
}, " ")

-- font configration
-- vim_option.guifont = "HackNerdFont:h11"
vim_option.guifont = "FiraCode Nerd Font:h11"
vim_option.guifontwide = "Hiragino Kaku Gothic ProN"

-- theme configration
vim.cmd.colorscheme "iceberg"

-- global plugin configration (airline)
vim_global.airline_deus_bg = 'dark'
vim_global.airline_powerline_fonts = 1
vim_global.airline_extensions_tabline_enabled = 1
vim_global.airline_extensions_tabline_buffer_idx_mode = 1
vim_global.airline_extensions_branch_enabled = 1
vim_global.airline_theme = 'deus'
vim_global.NERDTreeShowHidden = 1
vim_global.NERDTreeIgnore = { '\\.DS_Store$', '\\.[oa]$' }
vim_global.mkdp_command_for_global = 1
