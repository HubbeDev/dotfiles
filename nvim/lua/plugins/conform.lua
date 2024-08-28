return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufNewFile" },
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_fallback = true, range = true })
			end,
			mode = "v",
			desc = "[F]ormat selection",
		},
	},
	config = function()
		local conform = require("conform")

		-- Function to detect WordPress coding standard
		local function is_wordpress_standard()
			local paths = { ".phpcs.xml", "phpcs.xml", ".phpcs.xml.dist", "phpcs.xml.dist" }
			for _, path in ipairs(paths) do
				if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. path) == 1 then
					return true
				end
			end
			return false
		end

		-- Function to detect local binaries in the project
		local function get_local_bin(cmd)
			local cwd = vim.fn.getcwd()
			local local_bin = cwd .. "/vendor/bin/" .. cmd
			if vim.fn.executable(local_bin) == 1 then
				return local_bin
			else
				-- Fallback to global binary
				return cmd
			end
		end

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				svelte = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				rust = { "rustfmt", lsp_format = "fallback" },
				markdown = { { "prettierd", "prettier" } },
				--[[ php = function()
					local cmd = get_local_bin("phpcbf")
					if vim.fn.executable(cmd) == 1 then
						return { "phpcbf" }
					else
						return { "php_cs_fixer" }
					end
				end, ]]
			},
			notify_on_error = true,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					async = false,
					timeout_ms = 10000,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters = {
				phpcbf = {
					command = get_local_bin("phpcbf"),
					args = {
						"--standard=WordPress", -- Adjust as necessary for your project,
						"-q",
						"--stdin-path=",
						"$FILENAME",
						"-",
					},
					stdin = true,
					-- 0: no errors found
					-- 1: errors found
					-- 2: fixable errors found
					-- 3: processing error
					exit_codes = { 0, 1, 2 },
					inherit = false,
				},
				php_cs_fixer = {
					command = "php-cs-fixer",
					args = {
						"fix",
						"--rules=@PSR12", -- Formatting preset for PSR-12 standard.
						"$FILENAME",
					},
					stdin = false,
				},
			},
		})
	end,
}
