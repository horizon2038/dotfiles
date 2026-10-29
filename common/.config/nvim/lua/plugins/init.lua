-- lua/plugins/init.lua

-- lazy.nvimのパス
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvimがなければgit cloneする
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- lazy.nvimの安定版を使う
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvimをセットアップする
-- 'plugins.list' は lua/plugins/list.lua を指す
require("lazy").setup("plugins.list", {
  -- 必要に応じてlazy.nvim自体の設定をここに書く
  dev = {
      path = "~/dev",
      patterns = {"nvim-treesitter"},
      fallback = true
  },
  performance = {
    rtp = {
      -- rtpを無効化して起動を高速化する（highly recommended）
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  }
})
