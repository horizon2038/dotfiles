local vim_map = vim.keymap.set

-- normal mode configuration
-- vim_map('n', '<C-p>', '<Plug>AirlineSelectPrevTab', { noremap = true, silent = true, desc = "move to a preview tab" })
-- vim_map('n', '<C-n>', '<Plug>AirlineSelectNextTab', { noremap = true, silent = true, desc = "move to a next tab" })
vim_map('n', '<C-n>', ':bnext<CR>', { desc = "move to next buffer", silent = true })
vim_map('n', '<C-p>', ':bprevious<CR>', { desc = "move to preview buffer", silent = true })
vim_map('n', 'cdf', '<Plug>(coc-definition)', { noremap = true, silent = true, desc = "CoC: jump to definition" })
vim_map('n', 'crf', '<Plug>(coc-references)', { noremap = true, silent = true, desc = "CoC: jump to references" })
vim_map('n', 'crn', '<Plug>(coc-rename)', { noremap = true, silent = true, desc = "CoC: change names" })
vim_map('n', 'cfmt', '<Plug>(coc-format)', { noremap = true, silent = true, desc = "CoC: format" })
vim_map('n', '<F2>', ':NERDTreeToggle<CR>', { noremap = true, silent = true, desc = "NERDTree: toggle " })
vim_map('n', '<C-w>g', ':Telescope live_grep<CR>', { noremap = true, silent = true, desc = "Telescope: live grep" })
vim_map('n', '<C-w>f', ':Telescope find_files<CR>', { noremap = true, silent = true, desc = "Telescope: find files" })

-- terminal mode configuration
vim_map('t', '<C-w>n', '<C-\\><C-n>', { noremap = true, silent = true, desc = "terminal to normal" })

-- insert mode configuration
vim_map('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : "\\<Tab>"', { expr = true, silent = true })
vim_map('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<S-Tab>"', { expr = true, silent = true })
vim_map('i', '<Enter>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<Enter>"', { expr = true, silent = true })

