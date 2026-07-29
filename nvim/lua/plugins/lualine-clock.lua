return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Clickable Diff toggle button (matches the arrow/accent color)
    local diff_button = {
      function()
        local ok, lib = pcall(require, "diffview.lib")
        if ok and lib.get_current_view() then
          return "󰊢 Diff ✕"
        end
        return "󰊢 Diff"
      end,
      color = function()
        local mode_hl = {
          n = "lualine_a_normal",
          i = "lualine_a_insert",
          v = "lualine_a_visual",
          V = "lualine_a_visual",
          ["\22"] = "lualine_a_visual",
          c = "lualine_a_command",
          R = "lualine_a_replace",
          s = "lualine_a_visual",
          S = "lualine_a_visual",
          t = "lualine_a_terminal",
        }
        local mode = vim.api.nvim_get_mode().mode
        local hl = vim.api.nvim_get_hl(0, { name = mode_hl[mode] or "lualine_a_normal", link = false })
        local fg = hl.bg and string.format("#%06x", hl.bg) or "#7aa2f7"
        return { fg = fg, bg = "#292e42", gui = "bold" }
      end,
      padding = { left = 2, right = 2 },
      on_click = function()
        local ok, lib = pcall(require, "diffview.lib")
        if ok and lib.get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
    }

    opts.sections.lualine_y = { "progress", diff_button }

    -- Strip out the noice command (showcmd "i"/"5"), noice mode, dap, and
    -- lazy plugin-update counter from lualine_x. Keep only the git diff.
    opts.sections.lualine_x = vim.tbl_filter(function(c)
      return type(c) == "table" and c[1] == "diff"
    end, opts.sections.lualine_x or {})

    -- Remove LSP breadcrumbs/symbols from statusline (trouble.nvim integration)
    local filtered_c = {}
    for i, comp in ipairs(opts.sections.lualine_c or {}) do
      if i <= 4 then
        filtered_c[i] = comp
      end
    end
    opts.sections.lualine_c = filtered_c

    -- Replace the default 24h clock with 12h AM/PM
    for i, comp in ipairs(opts.sections.lualine_z or {}) do
      if type(comp) == "function" or (type(comp) == "table" and vim.inspect(comp):find("hour")) then
        opts.sections.lualine_z[i] = { function() return os.date("%I:%M %p") end }
        return
      end
    end
    opts.sections.lualine_z = { function() return os.date("%I:%M %p") end }
  end,
}
