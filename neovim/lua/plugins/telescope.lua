return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()

    local telescope = require("telescope")
    local telescopeConfig = require("telescope.config")

    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find file in project" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find string in project" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find file " })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find file" })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find word in current buffer" })
  end,
}
