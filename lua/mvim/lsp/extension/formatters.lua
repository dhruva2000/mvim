local M = {}

local null_ls = require("null-ls")
local services = require("mvim.lsp.extension.services")

local tbl_isempty = vim.tbl_isempty
local method = null_ls.methods.FORMATTING

function M.list_registered(filetype)
  local providers = services.list_registered_providers_names(filetype)
  return providers[method] or {}
end

function M.list_supported(filetype)
  local s = require("null-ls.sources")
  local supported_formatters = s.get_supported(filetype, "formatting")
  table.sort(supported_formatters)
  return supported_formatters
end

function M.setup(formatter_configs)
  if tbl_isempty(formatter_configs) then
    return
  end

  services.register_sources(formatter_configs, method)
end

return M