-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})
-- Force Tree-sitter to attach to Python files on every window entry
-- This fixes the 'second file highlight' bug during buffer switching
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "*.py",
	callback = function()
		-- vim.schedule ensures the buffer is fully loaded before we "kick" the highlighter
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()
			-- Check if it's actually a python file and not already highlighted
			if vim.bo[buf].filetype == "python" then
				vim.treesitter.start(buf)
			end
		end)
	end,
})
