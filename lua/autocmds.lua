-- specify tab widths on certain files
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = {
    'xml',
    'html',
    'xhtml',
    'css',
    'scss',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'markdown',
    'lua',
    'latex'
  },
  command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
})

-- discontinue comment when entering a new line
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

-- lazy load keymap and user-defined commands
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('loadMaps', { clear = true }),
  pattern = 'VeryLazy',
  callback = function()
    require('maps')
  end,
})

--vim.api.nvim_create_augroup('setSpell', { clear = true })
--vim.api.nvim_create_autocmd('FileType', {
--  group = 'setSpell',
--  pattern = { 'markdown' },
--  command = 'set spell'
--})
