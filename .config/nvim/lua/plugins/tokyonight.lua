return {
  "folke/tokyonight.nvim",
  config = function()
    require("tokyonight").setup({
      transparent = true,
    })
    require("tokyonight").load()
  end,
}
