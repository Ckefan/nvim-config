local lsp_installer = require "nvim-lsp-installer"
local servers = require "lsp.servers"

local M = {}


lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})


function M.setup()
  require("nvim-treesitter.install").command_extra_args = {
    curl = { "--proxy", "http://127.0.0.1:7890" },
  }

   for _, item in pairs(servers) do
    local name = item[1]
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end

return M
