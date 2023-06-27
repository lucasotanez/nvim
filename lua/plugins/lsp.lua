return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason' },
    build = ':MasonUpdate', -- :MasonUpdate updates registry contents
    lazy = true,
    config = function()
      require('mason').setup {
        ui = {
          border = 'rounded'
        },
      }
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      --require('lspconfig.ui.windows').default_options_border = 'rounded'
      require('mason-lspconfig').setup_handlers {
        function(server_name) -- default handler (optional)
          require('lspconfig')[server_name].setup {}
        end,
        -- server specific handlers
        ['lua_ls'] = function()
          require 'lspconfig'.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  -- Get ls to recognize `vim` global
                  globals = { 'vim' },
                },
                telemetry = { enable = false },
                runtime = {
                  version = 'LuaJIT',
                },
                format = {
                  enable = true,
                  defaultConfig = {
                    quote_style = 'single',
                    max_line_length = '80',
                    trailing_table_separator = 'smart',
                    call_arg_parantheses = 'remove_table_only',
                  },
                },
              },
            },
          }
        end,
        ['clangd'] = function()
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.offsetEncoding = { 'utf-16' }
          require('lspconfig').clangd.setup {
            capabilities = capabilities,
            cmd = { 'clangd', '--header-insertion-decorators=false' },
          }
        end,
      }
    end
  },
}
