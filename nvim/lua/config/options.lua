-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_ts_lsp = "tsgo"
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:1"
vim.opt.fillchars:append({ diff = " " })

-- Mouse / cursor
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true
vim.opt.mousescroll = "ver:3,hor:6"
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 8
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250"

-- Search: highlight all matches, live preview as you type
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable inline diagnostic text (errors still show as signs in the gutter)
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = true,
  float = { border = "rounded" },
})

-- All buffers editable by default
vim.opt.modifiable = true
vim.opt.readonly = false

-- Force all filetypes to be editable
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.bo.readonly = false
    vim.bo.modifiable = true
  end,
})

-- Suppress noisy LSP error notifications
vim.lsp.set_log_level("off")
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("^%[lsp%]") then return end
  if type(msg) == "string" and msg:match("vtsls") then return end
  if type(msg) == "string" and msg:match("Copilot.lua") then return end
  if type(msg) == "string" and msg:match("Node.js version") then return end
  orig_notify(msg, level, opts)
end
