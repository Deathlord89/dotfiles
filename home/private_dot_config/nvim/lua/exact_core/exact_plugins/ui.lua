return{
  { -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "onedark"
    end,
  },
  { -- File explorer
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      renderer = {
        root_folder_modifier = ":t",
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      view = {
        width = 30,
        side = "left",
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
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
