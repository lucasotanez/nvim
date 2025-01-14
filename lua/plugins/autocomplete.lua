return {
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {}
      local Rule = require 'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      -- rule for: `(|)` -> Space -> `( | )` and associated deletion options
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end),
      }
      --> NOTE: uncomment to be able to delete, e.g., `{ | }`, in one keystroke
      -- for _, bracket in pairs(brackets) do
      --   npairs.add_rules {
      --     Rule(bracket[1] .. ' ', ' ' .. bracket[2])
      --         :with_pair(function() return false end)
      --         :with_move(function(opts)
      --           return opts.prev_char:match('.%' .. bracket[2]) ~= nil
      --         end)
      --         :use_key(bracket[2]),
      --   }
      -- end

      -- add closing parenthesis even if next char is '$'
      npairs.add_rule(
      -- for markdown only, change to `Rule('(', ')', 'markdown')`
        Rule('(', ')')
        :with_pair(cond.after_text('$'))
      )
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact',
      'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'php',
      'glimmer', 'handlebars', 'hbs', 'markdown',
    },
    opts = { enable_close_on_slash = false }
  },
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    config = function()
      local ls = require('luasnip')
      ls.config.set_config {
        enable_autosnippets = true,
        history = true,
      }
      require('luasnip.loaders.from_lua').lazy_load { paths = './snippets' }

      -- let ts-autotag coexist with luasnip
      local autotag = require('nvim-ts-autotag.internal')
      vim.keymap.set('i', '>', function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { '>' })
        autotag.close_tag()
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        ls.expand_auto()
      end, { remap = false })

      --vim.keymap.set('i', '/', function()
      --  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      --  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col { '/' })
      --  autotag.close_slash_tag()
      --  local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
      --  vim.api.nvim_win_set_cursor(0, { new_row, new_col + 1 })
      --  ls.expand_auto()
      --end, { remap = false })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
      local cmp = require('cmp')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- mappings
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local luasnip = require('luasnip')
      local cmp_mappings = {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping( function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping(function(fallback)
          fallback()
        end),
      }

      local cmp_config = {
        mapping = cmp_mappings,
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        sources = {
          { name = 'path' },
          { name = 'nvim_lua', ft = 'lua' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer', keyword_length = 3 },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        --experimental = {
        --  ghost_text = true,
        --},
      }

      cmp.setup(cmp_config)
    end,
  },
}
