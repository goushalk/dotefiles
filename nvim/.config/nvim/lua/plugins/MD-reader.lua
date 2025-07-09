return {
  'MeanderingProgrammer/render-markdown.nvim',
  event = 'BufReadPre *.md',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    bullets = { "●", "○", "◆", "•" },
    checkbox = {
      enabled = true,
      symbols = {
        unchecked = "󰄱", -- nf-md-checkbox-blank-outline
        checked = "󰄲",   -- nf-md-checkbox-marked
        indeterminate = "󰡖", -- optional
      },
    },
    headings = {
      enabled = true,
      icons = { "󰲡", "󰲢", "󰲣", "󰲤", "󰲥", "󰲦" }, -- Nerd fonts for h1-h6
    },
    codeblock = {
      enabled = true,
      background = "Float", -- or "Normal", "None"
    },
    quote = {
      enabled = true,
      icon = "",
    },
    table = {
      enabled = true,
      style = "simple", -- or "rounded", "classic"
    },
    conceal = {
      enabled = true,
      level = 2, -- 0 = no conceal, 2 = max clean
      cursor = false,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- Optional: tweak conceal settings globally
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
        vim.opt_local.wrap = true
      end,
    })
  end,
}

