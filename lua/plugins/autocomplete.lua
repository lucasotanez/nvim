return {
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {}
      local Rule = require 'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      -- rule for: `(|)` -> Space -> `( | )` and associated deletion options
      -- NOTE: this adds a rule to delete both spaces if the cursor is in
      -- between two of them NO MATTER WHAT. if this gets annoying it may need
      -- a change
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
}
