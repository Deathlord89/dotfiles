return{
  { -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "onedark"
    end,
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char_list = { '|', '¦', '┆', '┊' },
      -- use_treesitter = true,
      -- show_current_context = true,
      show_first_indent_level = true,
      show_trailing_blankline_indent = false,
      buftype_exclude = { 'terminal', 'nofile' },
      filetype_exclude = { 'help', 'NvimTree' },
    },
  },
}
