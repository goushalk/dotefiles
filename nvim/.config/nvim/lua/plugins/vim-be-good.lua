-- ~/.config/nvim/lua/plugins/vim-be-good.lua

return {
  "ThePrimeagen/vim-be-good",
  -- It's a good practice to set a keymap to easily launch the game
  keys = {
    -- The keymap <leader>vbg will execute the command to start the game
    { "<leader>vbg", "<cmd>VimBeGood<cr>", desc = "VimBeGood (Game)" },
  },
}
