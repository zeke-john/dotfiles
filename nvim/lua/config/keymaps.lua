-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Hyprland already translates physical Alt+key to Ctrl+key via sendshortcut.
-- So we just need Neovim to respond to the Ctrl sequences.

-- Ctrl+S: Save (from Hyprland ALT+S → Ctrl+S)
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Ctrl+Z: Undo (from Hyprland ALT+Z → Ctrl+Z)
vim.keymap.set({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })

-- Ctrl+Shift+Z: Redo
vim.keymap.set({ "n", "i" }, "<C-S-z>", "<cmd>redo<cr>", { desc = "Redo" })
vim.keymap.set({ "n", "i" }, "<C-y>", "<cmd>redo<cr>", { desc = "Redo" })

-- Copy/Paste: Ghostty handles Shift+Insert paste natively, no Neovim mapping needed
vim.keymap.set("v", "<C-Insert>", '"+y', { desc = "Copy" })
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut" })

-- Ctrl+A / Ctrl+Shift+A: Select all (from Hyprland ALT+A / SUPER+A)
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("n", "<C-S-a>", "ggVG", { desc = "Select all" })

-- Ctrl+F: Open search, then n/N to cycle through matches
vim.keymap.set("n", "<C-f>", "/", { desc = "Search in file" })
vim.keymap.set("i", "<C-f>", "<Esc>/", { desc = "Search in file" })

-- Ctrl+/: Toggle comment
vim.keymap.set("n", "<C-/>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gcc", true, false, true), "m", false)
end, { desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gc", true, false, true), "m", false)
end, { desc = "Toggle comment" })

-- Ctrl+Shift+K: Delete line
vim.keymap.set({ "n", "i" }, "<C-S-k>", "<cmd>normal! dd<cr>", { desc = "Delete line" })

-- Ctrl+Shift+D: Duplicate line
vim.keymap.set("n", "<C-S-d>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
vim.keymap.set("i", "<C-S-d>", "<Esc><cmd>t.<cr>gi", { desc = "Duplicate line down" })

-- Ctrl+W: Close buffer (from Hyprland ALT+W in non-terminal apps, but in terminal it sends Ctrl+W)
vim.keymap.set({ "n", "i", "v" }, "<C-w>", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Ctrl+T: New tab / Ctrl+R: Reload won't override — these come from Hyprland too
-- Ctrl+N removed — conflicts with N for search cycling

-- Ctrl+Click: Go to definition
vim.keymap.set("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

-- LSP navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code action" })

-- F2: Rename symbol
vim.keymap.set("n", "<F2>", function() return ":IncRename " .. vim.fn.expand("<cword>") end, { expr = true, desc = "Rename symbol" })

-- Ctrl+P: Command palette
vim.keymap.set("n", "<C-p>", "<cmd>lua Snacks.picker.commands()<cr>", { desc = "Command palette" })

-- Ctrl+L: Address bar (from Hyprland) — in Neovim, select line
vim.keymap.set("n", "<C-l>", "V", { desc = "Select line" })

-- Navigate back/forward
vim.keymap.set("n", "<C-[>", "<C-o>", { desc = "Go back" })
vim.keymap.set("n", "<C-]>", "<C-i>", { desc = "Go forward" })

-- Shift+Scroll for horizontal scrolling (trackpad workaround)
vim.keymap.set({ "n", "v", "i" }, "<S-ScrollWheelUp>", "zh", { desc = "Scroll left" })
vim.keymap.set({ "n", "v", "i" }, "<S-ScrollWheelDown>", "zl", { desc = "Scroll right" })
