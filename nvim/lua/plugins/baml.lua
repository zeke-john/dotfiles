vim.filetype.add({
    extension = {
        baml = "baml",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "baml",
    callback = function(ev)
        local root = vim.fs.root(ev.buf, { "baml_src", ".bamlrc" })
        if not root then
            root = vim.fn.getcwd()
        end

        vim.lsp.start({
            name = "baml",
            cmd = { "baml-cli", "lsp" },
            root_dir = root,
        })
    end,
})

return {}
