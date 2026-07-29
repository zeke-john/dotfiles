return {
  {
    "sindrets/diffview.nvim",
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = true,
        default_args = {
          DiffviewOpen = { "--diffopt=iwhite" },
        },
        hooks = {
          diff_buf_win_enter = function(_, winid, ctx)
            if ctx.symbol == "a" then
              vim.api.nvim_set_option_value(
                "winhl",
                "DiffChange:DiffChangeOld,DiffText:DiffTextOld,DiffAdd:DiffDelete",
                { win = winid }
              )
            end
          end,
        },
        keymaps = {
          view = {
            -- Restore <C-w> window navigation (global mapping overrides it to :bd)
            { "n", "<C-w>", "<C-w>", { noremap = true, desc = "Window commands" } },
            -- Toggle the file panel
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle file panel" } },
            -- Cycle through changed files
            { "n", "<Tab>", actions.select_next_entry, { desc = "Next changed file" } },
            { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Prev changed file" } },
          },
          file_panel = {
            { "n", "<Tab>", actions.select_next_entry, { desc = "Next changed file" } },
            { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Prev changed file" } },
          },
        },
      })

      vim.api.nvim_create_user_command("Diff", function()
        local lib = require("diffview.lib")
        if lib.get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end, {})

      -- GitHub dark mode diff colors
      local function set_diff_highlights()
        vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#234f35" })
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4f2323" })
        vim.api.nvim_set_hl(0, "DiffChange", { bg = "#234f35" })
        vim.api.nvim_set_hl(0, "DiffText", { bg = "#3d9952", fg = "#e6edf3" })
        -- Left panel (old) variants — red instead of green
        vim.api.nvim_set_hl(0, "DiffChangeOld", { bg = "#4f2323" })
        vim.api.nvim_set_hl(0, "DiffTextOld", { bg = "#923d3d", fg = "#e6edf3" })
      end

      set_diff_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_diff_highlights,
      })
    end,
  },
}
