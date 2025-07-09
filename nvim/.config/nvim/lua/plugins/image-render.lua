return {
  "edluffy/hologram.nvim",
  enabled = vim.fn.has("unix") == 1 and vim.fn.getenv("TERM") == "xterm-kitty",
  config = function()
    require("hologram").setup {
      auto_display = true,
    }
  end,
}

