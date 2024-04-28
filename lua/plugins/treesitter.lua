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
                "php",
                "markdown",
                "bash",
                "vim",
                "vimdoc",
                "sql",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
