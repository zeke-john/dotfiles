return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            default_component_configs = {
                icon = {
                    provider = function(icon, node)
                        if node.type == "file" or node.type == "terminal" then
                            local name = node.type == "terminal" and "terminal" or node.name
                            local mini_icon, hl = require("mini.icons").get("file", name)
                            icon.text = mini_icon or icon.text
                            icon.highlight = hl or icon.highlight
                        elseif node.type == "directory" then
                            local mini_icon, hl = require("mini.icons").get("directory", node.name)
                            if mini_icon then
                                icon.text = mini_icon
                                icon.highlight = hl
                            end
                        end
                    end,
                },
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    show_hidden_count = false,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {},
                    never_show = {},
                    never_show_by_pattern = {
                        "*.js",
                        "*.js.map",
                        "*.d.ts",
                    },
                },
            },
        },
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
        },
    },
}
