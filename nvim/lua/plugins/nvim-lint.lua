return {
	"mfussenegger/nvim-lint",
	event = {
		"BufWritePre",
		"BufNewFile",
	},
	keys = {
		{
			"<leader>l",
			function()
				require("lint").try_lint()
			end,
			mode = "",
			desc = "[Lint] current buffer",
		},
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			svelte = { "eslint_d" },
			json = { "jsonlint" },
			php = { "phpcs" },
			css = { "stylelint" },
		}

		local phpcs = lint.linters.phpcs
		phpcs.args = {
			"-q",
			"--standard=WordPress",
			"--report=json",
			"-", -- need `-` at the end for stdin support
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
		vim.diagnostic.config({ virtual_text = true })
	end,
}
