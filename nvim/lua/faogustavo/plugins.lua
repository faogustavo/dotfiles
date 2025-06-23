local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "nvim-tree/nvim-tree.lua",
    "ThePrimeagen/vim-be-good",
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { 
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate" 
    },
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000 },
    {
        "nvim-telescope/telescope.nvim", 
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
}

require("lazy").setup(plugins, opts)

