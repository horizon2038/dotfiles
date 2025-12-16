-- lua/plugins/list.lua

return {
    ----------------------------------------
    -- always load
    ----------------------------------------
    { 'nvim-lua/plenary.nvim' }, 
    -- themes
    {
      "cocopon/iceberg.vim",
      priority = 1000,
      -- config = function()
      --     vim.cmd.colorscheme "iceberg"
      -- end
    },

    ----------------------------------------
    -- UI plugins
    ----------------------------------------
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    section_separators = { left = '' },
                    component_separators = { left = '' },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {{'filename', path = 1}},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                -- バッファリストをタブとして表示する設定
                tabline = {
                    lualine_a = {{'buffers', mode = 2}}, -- mode=2でバッファリストを表示
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                },
            })
        end,
    },

    -----------------------------------------
    -- load when executing a command
    -----------------------------------------
    -- file explorer
    { 'preservim/nerdtree', cmd = { "NERDTreeToggle", "NERDTreeFind" } },
    
    -- buffer management
    {
        'ojroques/nvim-bufdel',
        cmd = { "Bd", "Bda", "Bdo" },
        config = function()
            vim.api.nvim_create_user_command('Bd', 'BufDel', {})
            vim.api.nvim_create_user_command('Bda', 'BufDelAll', {})
            vim.api.nvim_create_user_command('Bdo', 'BufDelOther', {})
        end,
    },
    
    -- Git
    { 'tpope/vim-fugitive', cmd = { "Git", "G", "Gwrite", "Gadd" } },
    
    -- fuzzy finder
    {
      'nvim-telescope/telescope.nvim',
      cmd = "Telescope",
      tag = '0.1.6', 
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local telescope = require("telescope")
        telescope.setup({
          defaults = {
            file_ignore_patterns = { "^.git/", "^.cache" },
            vimgrep_arguments = {
              "rg", "--color=never", "--no-heading", "--with-filename",
              "--line-number", "--column", "--smart-case", "-uu",
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
          },
        })
        telescope.load_extension("fzf")
        vim.api.nvim_create_user_command('Tlg', 'Telescope live_grep', {})
        vim.api.nvim_create_user_command('Tff', 'Telescope find_files', {})
      end,
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      dependencies = { 'telescope.nvim' },
    },
    -- glslView-nvim
    {
        'timtro/glslView-nvim',
        ft = {'glsl'},
        cmd = 'GlslView',
        config = function()
            local glslViewer = require('glslView')
            glslViewer.setup({
                viewer_path = 'glslViewer', -- Path to glslViewer executable
                args = { '-l' }, -- Additional arguments for glslViewer
            })
        end,
    },

    -----------------------------------------
    -- load when opening a specific file type
    -----------------------------------------
    -- rust
    { 'rust-lang/rust.vim', ft = "rust" },
    -- Markdown Preview
    {
        'iamcco/markdown-preview.nvim',
        ft = "markdown",
        build = 'cd app && npx --yes yarn install',
        config = function()
            vim.api.nvim_create_user_command('Mdp', 'MarkdownPreview', {})
            vim.api.nvim_create_user_command('Mdps', 'MarkdownPreviewStop', {})
            vim.api.nvim_create_user_command('Mdpt', 'MarkdownPreviewToggle', {})
        end,
    },
    
    -----------------------------------------
    -- load when opening a file and inputting text
    -----------------------------------------
    -- lsp
    { 'neoclide/coc.nvim', branch = 'release', event = { "BufReadPost", "BufNewFile" }, },

    -- Copilot
    {
        'github/copilot.vim',
        event = { "BufReadPost", "BufNewFile" },

        init = function()
            vim.g.copilot_no_tab_map = true
        end,

        config = function()
            vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<Tab>")', {
                expr = true,
                silent = true,
                replace_keycodes = false
            })
        end,
    },
    -- { 'CopilotC-Nvim/CopilotChat.nvim' }, 
    
    -- syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      event = { "BufReadPost", "BufNewFile" },
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          -- indent = { enable = true },
        }
      end,
    },
    
    -- LSP/Mason
    { 'neovim/nvim-lspconfig', enabled = false },
    {
      'williamboman/mason.nvim',
      cmd = "Mason",
      build = ':MasonUpdate',
      config = function()
        require('mason').setup()
      end,
    },
    { 'williamboman/mason-lspconfig.nvim', event = "BufReadPost", enabled = false },
    
    -- surround
    {
      'kylechui/nvim-surround',
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("nvim-surround").setup()
      end,
    },

    -- presence
    {
        'andweeb/presence.nvim',
        lazy = false,
    },
    
    ----------------------------------------
    -- other plugins
    -- -------------------------------------
    { 'winter-again/wezterm-config.nvim' },
    -- transparent
    {
        'xiyaowong/transparent.nvim',
        event = 'VimEnter',
        config = function()
            vim.api.nvim_create_user_command('Tt', 'TransparentToggle', {})
        end,
    },

    ----------------------------------------
    -- disable plugins
    ----------------------------------------
    {'catppuccin/nvim', enabled = false },
    { 'AlexvZyl/nordic.nvim', enabled = false },
}
