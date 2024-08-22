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
		local util = require("conform.util")
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
				markdown = { { "prettierd", "prettier" } },
				php = function()
					-- local cmd = get_local_bin("phpcbf")
					if is_wordpress_standard() then
						return { "phpcbf_wordpress" }
					else
						return { "phpcbf_psr12" }
					end
				end,
			},
			notify_on_error = true,
			fallback_on_error = function(bufnr)
				vim.notify("Formatting failed. Please check your code.", vim.log.levels.ERROR)
			end,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					async = false,
					timeout_ms = 10000,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters = {
				phpcbf_wordpress = {
					meta = {
						url = "https://phpqa.io/projects/phpcbf.html",
						description = "PHP Code Beautifier and Fixer fixes violations of a defined coding standard.",
					},
					command = util.find_executable({
						"vendor/bin/phpcbf",
					}, "phpcbf"),
					args = {
						"-q",
						"--stdin-path=",
						"$FILENAME",
						"-",
						"--standard=PSR12", -- Adjust as necessary for your project,
					},
					stdin = true,
					-- 0: no errors found
					-- 1: errors found
					-- 2: fixable errors found
					-- 3: processing error
					exit_codes = { 0, 1, 2 },
					inherit = false,
				},
				phpcbf_psr12 = {
					meta = {
						url = "https://phpqa.io/projects/phpcbf.html",
						description = "PHP Code Beautifier and Fixer fixes violations of a defined coding standard.",
					},
					command = util.find_executable({
						"vendor/bin/phpcbf",
					}, "phpcbf"),
					args = {
						"-q",
						"--stdin-path=",
						"$FILENAME",
						"-",
						"--standard=@PSR12", -- Adjust as necessary for your project,
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

			-- Debugging: Track formatting steps
			vim.api.nvim_create_autocmd("BufWritePost", {
				callback = function()
					vim.notify("File was formatted and saved successfully.", vim.log.levels.INFO)
				end,
			}),
		})
	end,
}
