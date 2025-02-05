return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},
	{
		"catppuccin",
		opts = {
			transparent_background = true,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = function(_, opts)
			local autocmd = vim.api.nvim_create_autocmd
			autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					-- Make sure the numbers themselves are visible
					vim.cmd("highlight LineNr guifg=#8B8AA1")
				end,
			})
		end,
	},
}
