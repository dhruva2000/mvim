local M = {
	{
		"rubiin/fortune.nvim",
		version = "*",
		config = function()
			require("fortune").setup({
				max_width = 60, -- max width the fortune section should take place
				display_format = "short", -- the fortune form
				content_type = "quotes"
			})
		end,
	},

}
return M
