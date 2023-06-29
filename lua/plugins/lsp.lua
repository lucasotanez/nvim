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
            filetypes = {'c', 'cpp', 'objc'}
          }
          -- NOTE about using clangd with c++:
          -- Compiler flags should be supplied in a file at the root directory:
          -- either 'compile_flags.txt' (simple projects with pure Makefiles),
          -- or 'compile_commands.json' (projects using Cmake).
          -- These files tell the LSP how your specific project is organized so that it
          -- can be parsed accurately.
          -- https://clang.llvm.org/docs/JSONCompilationDatabase.html
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local function opts(desc)
            return {
              desc = 'lsp: ' .. desc,
              buffer = ev.buf,
              remap = false,
              silent = true,
            }
          end

          -- BEGIN CUSTOM KEYMAPS

          vim.keymap.set('n', 'E', function() vim.lsp.buf.hover() end, opts('show info'))
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
            { desc = 'Expand vim diagnostic' })
          vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end,
            opts('goto definition'))
          vim.keymap.set('n', 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
            opts('goto definition in new tab'))
          vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.goto_prev() end,
            opts('cycle previous diagnostic message'))
          vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.goto_next() end,
            opts('cycle next diagnostic message'))
          --vim.keymap.set('n', '<leader>r', function()
          --  local new_name = vim.fn.input { prompt = 'New name: ' }
          --  if #new_name == 0 then
          --    return
          --  end
          --  vim.lsp.buf.rename(new_name)
          --end)
          vim.keymap.set('n', '<leader>ca', function()
            vim.lsp.buf.code_action {
              apply = true,
            }
          end, opts('run code action'))
          vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts('codelens'))

          --END CUSTOM KEYMAPS
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'rounded' }
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = 'rounded'
        })
      vim.lsp.handlers['textDocuments/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = 'rounded',
        })
    end
  },
}
