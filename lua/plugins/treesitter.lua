return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "lua",
                "javascript",
                "typescript",
                "html",
                "css",
                "json",
                "yaml",
                "svelte",
                "tsx",
                "markdown",
                "bash",
                "vim",
                "vimdoc",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
