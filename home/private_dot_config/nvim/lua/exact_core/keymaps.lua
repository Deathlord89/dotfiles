-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- copy, cut and paste direct to clipboard
keymap("v", "<C-c>", '"+y', opts)
keymap("v", "<C-x>", '"+c', opts)
keymap("v", "<C-v>", 'c<ESC>"+p', opts)
keymap("i", "<C-v>", '<ESC>"+pa', opts)

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Better window navigation
keymap("n", "<leader>sv", "<C-w>v", opts)
keymap("n", "<leader>sh", "<C-w>s", opts)
keymap("n", "<leader>se", "<C-w>=", opts)
keymap("n", "<leader>sx", ":close<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Fast saving
keymap("n", "<leader>w", ":w!<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Toggle relative numbering
keymap("n", "<leader>n", ":set rnu!<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Switch CWD to the directory of the open buffer
keymap("n", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
--keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
--keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
--keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
--keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
--keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
--keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
--keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- DAP
--keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
--keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
--keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
--keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
--keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
--keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
--keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
--keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
--keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- Lsp
--keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
