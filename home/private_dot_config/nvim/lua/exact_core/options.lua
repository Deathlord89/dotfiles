local options = {
  -- general options
  autoread = true,                         -- Reload files changed outside vim
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  ffs = { "unix", "mac", "dos" },          -- Use unix as the standard file type
  fileencoding = "utf-8",                  -- the encoding written to a file
  hidden = true,                           -- This makes vim act like all other editors
  lazyredraw = true,                       -- skip redrawing screen in some cases
  modelines = 2,                           -- Enable modelines in files
  mouse = "a",                             -- allow the mouse to be used in neovim
  number = true,                           -- set numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  relativenumber = true,                   -- set relative numbered lines
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  timeoutlen = 400,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300,                        -- faster completion (4000ms default)

  -- apperance
  -- background = "dark",
  conceallevel = 0,                        -- so that `` is visible in markdown files
  cursorline = true,                       -- highlight the current line
  errorbells = false,                      -- No Beep!
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  laststatus = 2,                          -- always show the status line
  pumheight = 10,                          -- pop up menu height
  scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
  showtabline = 2,                         -- always show tabs
  sidescroll = 1,
  sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  visualbell = true,                       -- Blink!

  -- tabs and indention
  expandtab = true,                        -- Give me spaces or give me death
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  smartindent = true,                      -- make indenting smarter again
  softtabstop = 2,                         -- insert 2 spaces for a tab
  tabstop = 2,                             -- insert 2 spaces for a tab

  -- Display tabs and trailing spaces visually
  list = true,
  listchars = { trail = "◇", tab = "»·", extends = ">", precedes = "<"},
  -- listchars = { trail = "◇", tab = "»·", extends = ">", precedes = "<", eol = "↵" },

  -- line wrapping
  linebreak = true,                        -- companion to wrap, don't split words
  whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next linie
  wrap = false,                            -- display lines as one long line

  -- search settings
  history = 10000,                          -- History size
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  incsearch = true,                        -- highlight as you type you search phrase
  smartcase = true,                        -- smart case

  backup = false,                          -- creates a backup file
  swapfile = false,                        -- creates a swapfile
  undofile = true,                         -- enable persistent undo
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use
