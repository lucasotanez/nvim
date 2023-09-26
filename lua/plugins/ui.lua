return {
  { 'catppuccin/nvim', name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        flavour = 'macchiato'
      }
      --require('catppuccin').load()
    end,
  },
  {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        colors = {
          white = '#eeeeee',
        },
        highlights = {
          -- make comments stand out less 
          -- use '$grey' for even quieter comments
          ['@comment'] = { fg = '$light_grey' },

          --['@variable'] = { fg = '$white' }
        },
        diagnostics = {
          undercurl = false,
        },
      }
      require('bamboo').load()
    end,
  },
  {
    'projekt0n/caret.nvim',
  },
  {
    'ellisonleao/gruvbox.nvim',
  },
  {
    'navarasu/onedark.nvim',
    -- Primary (default loaded) colorscheme should not lazy load, 
    -- as it may cause conflict with other lazy plugins such as lualine
    --lazy = false,
    event = { 'VeryLazy' },
    config = function()
      require('onedark').setup {
        --style = 'warmer',
        highlights = {
          -- make pop up windows blend better with the background
          ['FloatBorder'] = { bg = '$bg0' },
          ['NormalFloat'] = { bg = '$bg0' },
          ['NvimTreeNormal'] = { bg = '$bg0' },
          ['NvimTreeEndOfBuffer'] = { bg = '$bg0', fg = '$bg0' },
          -- prevent Lua constructor tables from being bolded
          ['@constructor.lua'] = { fg = '$yellow', fmt = 'none' },
          ['@function.builtin'] = { fg = '$orange' },
          -- italicize parameters and conditionals
          ['@parameter'] = { fmt = 'italic' },
          ['@conditional'] = { fmt = 'italic' },
          -- change bracket color so that it doesn't conflict with string color
          ['TSRainbowGreen'] = { fg = '$fg' },
          -- better match paren highlights
          ['MatchParen'] = { fg = '$orange', fmt = 'bold' },
          -- better dashboard styling
          ['@alpha.title'] = { fg = '$green' },
          ['@alpha.header'] = { fg = '$yellow', fmt = 'bold' },
          ['@alpha.footer'] = { fg = '$red', fmt = 'italic' },
        },
        diagnostics = {
          darker = false,
        }
      }
      --require('onedark').load()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = { 'VeryLazy' },
    config = function()
      -- statusline that shows current and total line number 
      local function line_total()
        local curs = vim.api.nvim_win_get_cursor(0)
        return curs[1] ..
          '/' ..
          vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. ' ' .. curs[2]
      end

      require('lualine').setup {
                sections = {
          lualine_z = { line_total },
        },
        options = {
          disabled_filetypes = {
            'alpha',
          },
          -- Powerline looks good with 'catppuccin'
          --theme = 'powerline'
          theme = 'onedark',
        },
      }
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup {
        -- Uncomment below for current context highlighting (not sure if useful yet...)
        -- show_current_context = true,
        -- show_current_context_start = true,
        max_indent_increase = 1,
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      -- Toggle filetree
      { '<leader>t', '<Cmd>NvimTreeToggle<CR>' },
    },
    cmd = { 'NvimTreeFindFileToggle', 'NvimTreeToggle' },
    config = function()
      local HEIGHT_RATIO = 0.75
      local WIDTH_RATIO = 0.5
      -- turning off float will show a VSCode-style file explorer on left
      local FLOAT_ENABLED = true

      -- custom mappings
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- BEGIN CUSTOM MAPPINGS

        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))

        -- END CUSTOM MAPPINGS

        local function tab_with_close()
          if not FLOAT_ENABLED then vim.api.nvim_command('wincmd h') end
          api.node.open.tab()
        end
      end

      require('nvim-tree').setup {
        on_attach = on_attach,
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        view = {
          float = {
            enable = FLOAT_ENABLED,
            open_win_config = function()
              -- center the window
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) -
                  vim.opt.cmdheight:get()

              return {
                relative = 'editor',
                border = 'rounded',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
        },
        renderer = {
          -- '/' at the end of a folder
          add_trailing = false,
          icons = {
            show = {
              -- icons
              modified = true,
              git = false,
            },
          },
        },
        tab = {
          sync = {
            open = true,
            close = true,
          },
        },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('gitsigns').setup {
        sign_priority = 0,
        preview_config = {
          border = 'rounded',
        },
      }
    end,
  },
  {
    'akinsho/bufferline.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'tabs',
          separator_style = 'slant',
          color_icons = true,
          show_close_icon = false,
          show_buffer_close_icons = false,
          always_show_bufferline = false,
          modified_icon = '',
          diagnostics = 'nvim_lsp',
          -- TODO: show diagnostic info in buffer tabs
        },
      }
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    keys = {
      { '<leader>ff' },
      { '<leader>fg' },
      { '<leader>fb' },
      { '<leader>fh' }
    },
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
    config = function()
      local actions = require('telescope.actions')

      -- open selected buffers in new tabs
      local function multi_tab(prompt_bufnr)
        local state = require 'telescope.actions.state'
        local picker = state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local str = ''
        if #multi > 0 then
          for _, j in pairs(multi) do
            str = str .. 'tabe ' .. j.filename .. ' | '
          end
          actions.close(prompt_bufnr)
          vim.api.nvim_command(str)
        else
          require('telescope.actions').select_tab(prompt_bufnr)
        end
      end

      local function close_with_action(prompt_bufnr)
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd [[NvimTreeFindFileToggle]]
      end

      local putils = require('telescope.previewers.utils')
      local telescope = require('telescope')

      telescope.setup {
        defaults = {
          preview = {
            filetype_hook = function(_, bufnr, opts)
              -- no display pdf previews
              if opts.ft == 'pdf' then
                putils.set_preview_message(bufnr, opts.winid,
                  'Not displaying ' .. opts.ft)
                return false
              end
            return true
          end,
          },
          layout_config = {
            horizontal = {
              preview_cutoff = 0,
            },
          },
          prompt_prefix = ' 󰍉 ',
          initial_mode = 'insert',
          mappings = {
            n = {
              ['<Tab>'] = multi_tab,
              ['<leader>t'] = close_with_action,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              -- using <Space> here causes a delay since it is leader key.
              -- it's fine for now since i usually use the bind in insert mode only.
              ['<Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['q'] = {
                actions.close,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
            },
            i = {
              ['<Tab>'] = multi_tab,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['<C-l>'] = false -- override Telescope default
            },
          },
        },
      }

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    end
  },
}
