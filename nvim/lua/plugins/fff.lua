-- Hidden paths to always include in fff searches (negates .gitignore exclusions).
-- These get written to a .ignore file in the project root so the Rust scanner picks them up.
local hidden_include = {
  "!.github/",
  "!.env*",
  "!.claude/",
}

--- Ensure a .ignore file exists at `dir` with our negation patterns.
--- Only writes if the file is missing or doesn't contain our marker.
local function ensure_ignore_file(dir)
  if not dir or dir == "" then return end
  local ignore_path = dir .. "/.ignore"
  local marker = "# fff-hidden-include"

  local f = io.open(ignore_path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    if content:find(marker, 1, true) then return end -- already has our block
    -- Append our block
    f = io.open(ignore_path, "a")
    if not f then return end
    f:write("\n" .. marker .. "\n" .. table.concat(hidden_include, "\n") .. "\n")
    f:close()
  else
    -- Create new file
    f = io.open(ignore_path, "w")
    if not f then return end
    f:write(marker .. "\n" .. table.concat(hidden_include, "\n") .. "\n")
    f:close()
  end
end

return {
  -- Keep telescope installed (LazyVim needs it internally) but we use fff instead
  { "nvim-telescope/telescope.nvim", keys = {}, cmd = {} },

  -- FFF: freakin fast fuzzy file finder
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    init = function()
      -- Write .ignore file on startup and directory change so fff indexes hidden paths
      ensure_ignore_file(vim.fn.getcwd())
      vim.api.nvim_create_autocmd("DirChanged", {
        group = vim.api.nvim_create_augroup("fff_hidden_include", { clear = true }),
        callback = function(ev)
          ensure_ignore_file(ev.file ~= "" and ev.file or vim.fn.getcwd())
        end,
      })
    end,
    keys = {
      {
        "<leader><leader>",
        function() require("fff").find_files() end,
        desc = "FFFind files",
      },
      {
        "<leader>g",
        function() require("fff").live_grep() end,
        desc = "LiFFFe grep",
      },
    },
  },
}
