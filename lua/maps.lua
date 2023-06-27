local keymap = vim.keymap

-- system clipboard
keymap.set({ 'n', 'v' }, '<C-y>', '"+y')
keymap.set({ 'n', 'v' }, '<C-p>', '"+p')

-- do not yank with x
keymap.set({'n', 'x'}, 'x', '"_x') 

-- highlight block indentation
vim.keymap.set('x', '<Tab>', '>gv', { remap = false })
vim.keymap.set('x', '<S-Tab>', '<gv', { remap = false })
vim.keymap.set('n', '<Tab>', '>>', { remap = false })
vim.keymap.set('n', '<S-Tab>', '<<', { remap = false })

-- navigation in insert mode 
keymap.set({ 'i', 'c' }, '<C-k>', '<Up>', { remap = false})
keymap.set({ 'i', 'c' }, '<C-h>', '<Left>', { remap = true})
keymap.set({ 'i', 'c' }, '<C-j>', '<Down>', { remap = false})
keymap.set({ 'i', 'c' }, '<C-l>', '<Right>', { remap = false})
keymap.set({ 'i', 'c' }, '<C-w>', '<C-Right>', { remap = false}) 
keymap.set({ 'i', 'c' }, '<C-b>', '<C-Left>', { remap = false})

-- delete word backward in insert mode
-- vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', {noremap = true})
keymap.set({ 'i', 'c' }, '<M-BS>', '<C-w>', { remap = false })

-- delete word backward in normal mode
keymap.set('n', 'dw', 'db')

-- increment/decrement
keymap.set('n', '+', '<C-a>', { remap = false })
keymap.set('n', '-', '<C-x>', { remap = false })

-- select all
keymap.set('n', '<C-a>', 'gg<S-v>G', { remap = false })

-- new buffer
keymap.set('n', '<C-t>', ':tabedit<Return>')
-- split window
keymap.set('n', '<C-down>', ':split<Return><C-w>w')
keymap.set('n', '<C-right>', ':vsplit<Return><C-w><w')
-- navigate buffer
keymap.set('n', '<C-w>', '<C-w>w')
keymap.set('', '<C-h>', '<C-w>h')
keymap.set('', '<C-j>', '<C-w>j')
keymap.set('', '<C-k>', '<C-w>k')
keymap.set('', '<C-l>', '<C-w>l')

--resize
keymap.set('n', '<left>', '<C-w><')
keymap.set('n', '<right>', '<C-w>>')
keymap.set('n', '<up>', '<C-w>+')
keymap.set('n', '<down>', '<C-w>-')
