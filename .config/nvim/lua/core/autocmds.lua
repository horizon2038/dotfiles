-- aliases configuration
local vim_api = vim.api

-- vim.api.nvim_create_user_command('Bd', 'BufDel', {})
-- vim.api.nvim_create_user_command('Bda', 'BufDelAll', {})
-- vim.api.nvim_create_user_command('Bdo', 'BufDelOther', {})
-- vim.api.nvim_create_user_command('Mdp', 'MarkdownPreview', {})
-- vim.api.nvim_create_user_command('Mdps', 'MarkdownPreviewStop', {})
-- vim.api.nvim_create_user_command('Mdpt', 'MarkdownPreviewToggle', {})
-- vim.api.nvim_create_user_command('Tlg', 'Telescope live_grep', {})
-- vim.api.nvim_create_user_command('Tff', 'Telescope find_files', {})

local fileTypeIndentGroup = vim.api.nvim_create_augroup('FileTypeIndentGroup', { clear = true })

-- web-specific configuration
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.html', '*.css', '*.js', '*.ts' },
    group = fileTypeIndentGroup,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Makefile-specific configuration
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = 'Makefile',
    group = fileTypeIndentGroup,
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- typst-specific configuration
local fileTypeDetectGroup = vim.api.nvim_create_augroup('FileTypeDetectGroup', { clear = true })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.typ',
    group = fileTypeDetectGroup,
    command = 'setfiletype typst',
})
