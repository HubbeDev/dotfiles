return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		local wk = require("which-key")
		wk.setup({
			-- Du kan lägga till fler inställningar här om du vill anpassa which-key
			plugins = {
				marks = true, -- visar bokmärken
				registers = true, -- visar registerinnehåll
				spelling = {
					enabled = true,
					suggestions = 20,
				},
			},
			window = {
				border = "single", -- enkel ram runt popupen
				position = "bottom", -- placerar popupen längst ner
			},
		})

		-- Normal mode mappings
		wk.register({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>c_", hidden = true },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>d_", hidden = true },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>r_", hidden = true },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>s_", hidden = true },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>w_", hidden = true },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>t_", hidden = true },
			{ "<leader>h", group = "Git [H]unk" },
			{ "<leader>h_", hidden = true },
		}, { mode = "n" })

		-- Visual mode mapping
		wk.register({
			{ "<leader>h", desc = "Git [H]unk" },
		}, { mode = "v" })
	end,
}
