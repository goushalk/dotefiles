-- ~/.config/nvim/lua/plugins/harpoon.lua

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
  end,
  keys = {
    -- Keymap to add the current file to the harpoon list
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
        vim.notify("Harpoon: Marked file " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "Harpoon" })
      end,
      desc = "Harpoon: Add file",
    },
    -- Keymap to open the Telescope UI for harpoon
    {
      "<leader>h",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon: Open UI (Telescope)",
    },

    -- Keymaps to quickly navigate to marked files
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4" },
    { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon to file 5" },

    -- Toggle previous & next buffers stored within Harpoon list
    -- You can use any keys you like, e.g., <C-h> and <C-l>
    {
      "<A-p>",
      function() require("harpoon"):list():prev() end,
      desc = "Harpoon: Previous",
    },
    {
      "<A-n>",
      function() require("harpoon"):list():next() end,
      desc = "Harpoon: Next",
    },
  },
}
