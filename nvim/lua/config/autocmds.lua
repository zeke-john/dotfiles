-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Right-click context menu with file operations for neo-tree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.keymap.set("n", "<RightMouse>", function()
      -- Move cursor to clicked position first
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", false)
      vim.schedule(function()
        local actions = {
          { "New File", "a" },
          { "Rename", "r" },
          { "Delete", "d" },
          { "Copy", "c" },
          { "Cut", "x" },
          { "Paste", "p" },
        }
        vim.ui.select(
          vim.tbl_map(function(a) return a[1] end, actions),
          { prompt = "File action:" },
          function(choice)
            if not choice then return end
            for _, a in ipairs(actions) do
              if a[1] == choice then
                vim.schedule(function()
                  vim.api.nvim_feedkeys(a[2], "m", false)
                end)
                return
              end
            end
          end
        )
      end)
    end, { buffer = true, desc = "Neo-tree file actions menu" })
  end,
})
