local fn = vim.fn

local opts = {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      -- runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      workspace = {
        library = {
          [fn.expand("$VIMRUNTIME/lua")] = true,
          [fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
  -- prefer_null_ls = true,
}

return opts