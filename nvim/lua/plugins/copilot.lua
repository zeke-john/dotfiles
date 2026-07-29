return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          dismiss = "<Esc>",
          next = "<A-]>",
          prev = "<A-[>",
        },
      },
      panel = { enabled = false },
    },
  },
}
