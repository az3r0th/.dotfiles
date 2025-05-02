return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    local keymap = vim.keymap.set
    harpoon:setup()

    -- Harpoon specific keymaps
    keymap("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add current buffer to harpoon" })
    keymap("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle harpoon quick menu" })
    keymap("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Switch to Harpoon buffer 1" })
    keymap("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Switch to Harpoon buffer 2" })
    keymap("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Switch to Harpoon buffer 3" })
    keymap("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Switch to Harpoon buffer 4" })
    keymap("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Go to previous Harpoon buffer" })
    keymap("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Go to next Harpoon buffer" })
  end
}
