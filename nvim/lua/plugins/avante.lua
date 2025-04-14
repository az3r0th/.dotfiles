return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make build-templates && make",
  config = function()
    require("avante").setup({
      -- Provider configuration
      provider = "gemini",
      api_key = vim.env.GEMINI_API_KEY,
      -- UI customization
      ui = {
        -- You can customize the UI here
        border = "rounded",
      },
      -- Keymaps
      keymaps = {
        -- Toggle avante sidebar
        toggle = "<leader>a",
        -- Edit selected code
        edit = "<leader>ae",
        -- Get suggestions
        suggest = "<Tab>",
      },
    })
  end,
  -- Dependencies
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
} 
