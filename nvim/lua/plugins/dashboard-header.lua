local lines = {
  "██╗██╗ ██████╗ ██████╗ ██████╗ ███████╗ ██╗██╗",
  "╚═╝╚═╝██╔════╝██╔═══██╗██╔══██╗██╔════╝ ╚═╝╚═╝",
  "      ██║     ██║   ██║██║  ██║█████╗",
  "      ██║     ██║   ██║██║  ██║██╔══╝",
  "      ╚██████╗╚██████╔╝██████╔╝███████╗",
  "       ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝",
}

local max = 0
for _, l in ipairs(lines) do
  local w = vim.fn.strdisplaywidth(l)
  if w > max then max = w end
end
for i, l in ipairs(lines) do
  lines[i] = l .. string.rep(" ", max - vim.fn.strdisplaywidth(l))
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = table.concat(lines, "\n"),
      },
    },
  },
}
