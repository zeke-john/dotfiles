-- Increase Ghostty background opacity while neovim is running
-- so colorscheme backgrounds aren't washed out by terminal transparency
local ghostty_config = vim.fn.expand("~/.config/ghostty/config")
local original_opacity = nil

local function get_opacity()
	local output = vim.fn.system("grep '^background-opacity' " .. ghostty_config)
	return output:match("background%-opacity%s*=%s*([%d%.]+)")
end

local function set_opacity(value)
	vim.fn.system(
		string.format("sed -i 's/^background-opacity = .*/background-opacity = %s/' %s", value, ghostty_config)
	)
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		original_opacity = get_opacity()
		if original_opacity then
			set_opacity("0.8")
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if original_opacity then
			set_opacity(original_opacity)
		end
	end,
})
