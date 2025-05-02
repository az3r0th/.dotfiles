return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim'
  },
  config = function()
    local builtin = require('telescope.builtin')
    local keymap = vim.keymap.set
    local telescope = require('telescope')
    -- Load telescope file browser extension
    telescope.load_extension('file_browser')

    -- Telescope specific keymaps
    keymap('n', '<leader>ff', function()
      builtin.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
    end, { desc = 'Telescope find files' })
    keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    keymap('n', '<leader>fe', function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.expand("%:p:h"),
        respect_gitignore = true,
        hidden = true,
        grouped = true,
        previewer = true,
        initial_mode = "normal",
        layout_config = { height = 40 }
      })
    end, { desc = "Open Telescope file browser" })

    -- Harpoon telescope integration
    local harpoon = require('harpoon')
    harpoon:setup({})

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    keymap("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })
  end
}
