-- Paste this in Neovim and run: :luafile check_servers.lua
-- Or run: :lua dofile('C:/Users/ekarni/.vim/myplugins/check_servers.lua')

local clients = vim.lsp.get_active_clients()
print("\n=== Active LSP Clients ===")
for _, client in ipairs(clients) do
    if vim.bo.filetype == "python" or client.name:match("py") or client.name:match("jedi") then
        print(string.format("\nClient: %s (id: %d)", client.name, client.id))
        print("  Buffers: " .. vim.inspect(client.attached_buffers))
        if client.server_capabilities.completionProvider then
            print("  ✓ completionProvider: ENABLED")
            print("    " .. vim.inspect(client.server_capabilities.completionProvider))
        else
            print("  ✗ completionProvider: DISABLED or FALSE")
        end
    end
end
