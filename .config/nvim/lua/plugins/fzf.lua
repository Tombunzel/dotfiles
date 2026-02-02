return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			winopts = {
				height = 30,
				width = 100,
				row = 10,
				col = 10,
				preview = {
					layout = "vertical",
					vertical = "down:50%",
				},
			},
			ui_select = {
				winopts = {
					height = 15,
					width = 80,
					row = 10,
					col = 10,
				},
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")
			if not _G.__fzf_ui_select_registered then
				fzf.setup(opts)
				fzf.register_ui_select()
				_G.__fzf_ui_select_registered = true
			else
				fzf.setup(opts)
			end
		end,
	},
}
