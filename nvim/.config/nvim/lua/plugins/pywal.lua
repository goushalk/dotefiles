-- ~/.config/nvim/lua/plugins/pywal.lua



return {
  "AlphaTechnolog/pywal.nvim",
  name = "pywal",
  lazy = false,
  priority = 1000,
  config = function()
    require("pywal").setup()
    vim.cmd("colorscheme pywal") -- auto-apply
  end,
}

