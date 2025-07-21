return {
  "AlphaTechnolog/pywal.nvim",
  name = "pywal",
  lazy = false,
  priority = 1000,
  config = function()
    require("pywal").setup()

    local wal_colors = vim.fn.expand("~/.cache/wal/colors-wal.vim")
    if vim.fn.filereadable(wal_colors) == 1 then
      vim.cmd("source " .. wal_colors)
      vim.cmd("set background=dark")
      vim.cmd("colorscheme pywal") -- might be redundant
    else
      vim.notify("pywal colors not found. Run `wal -i`!", vim.log.levels.WARN)
    end
  end,
}

