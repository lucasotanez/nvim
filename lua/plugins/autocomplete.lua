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
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lua' },
    },
    config = function()
      local cmp = require('cmp')
      local cmp_config = {
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        sources = {
          { name = 'path' },
          { name = 'nvim_lua', ft = 'lua' },
          { name = 'nvim_lsp' },
          { name = 'buffer', keyword_length = 3 },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_test = true,
        },
      }

      cmp.setup(cmp_config)
    end,
  },
}
