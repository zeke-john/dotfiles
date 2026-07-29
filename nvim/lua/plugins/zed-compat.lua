-- Plugins that make Neovim feel like Zed/Cursor/VS Code
return {
  -- Multi-cursor (Alt+click, Ctrl+D style)
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "",  -- disable default Ctrl+D, we use Alt+click
        ["Find Subword Under"] = "",
      }
      vim.g.VM_theme = "codedark"
    end,
  },

  -- Surround: cs'" to change ' to ", ysiw) to wrap word in parens, ds" to delete
  { import = "lazyvim.plugins.extras.coding.mini-surround" },

  -- Inline color previews for hex codes, rgb(), etc.
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        css = true,
        tailwind = true,
        mode = "virtualtext",
        virtualtext_inline = true,
      },
    },
  },

  -- Auto-save on focus lost (no plugin needed)
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
        callback = function()
          if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! write")
          end
        end,
      })
    end,
  },

  -- Inline git blame (shows who wrote each line)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol",
      },
    },
  },

  -- Better rename UI (inline rename like F2 in Zed/VS Code)
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
    keys = {
      {
        "<leader>cr",
        function() return ":IncRename " .. vim.fn.expand("<cword>") end,
        expr = true,
        desc = "Rename (inc-rename)",
      },
    },
  },

  -- Highlight yanked text briefly (visual feedback like Zed)
  {
    "snacks.nvim",
    opts = {
      animate = { enabled = true },
    },
  },

  -- Smooth animations for scrolling
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = true },
    },
  },

  -- LSP settings
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
    },
  },
}
