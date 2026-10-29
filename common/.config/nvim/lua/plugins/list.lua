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
    -- veryl
    { 'veryl-lang/veryl.vim'},

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
          config = function()
            require('presence').setup({
                -- General options
                auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
                neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
                main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
                log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
                debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
                enable_line_number  = false,                      -- Displays the current line number instead of the current project
                blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
                buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
                file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
                show_time           = true,                       -- Show the timer

                -- Rich Presence text options
                editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
            })
          end,
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
