return {
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "jay-babu/mason-null-ls.nvim",
  "nvimtools/none-ls.nvim",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config
      local cmp = require("cmp")

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_lua").load({ paths = "./lua/custom/code_snippets" })
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html" })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      lsp_defaults.capabilities = vim.tbl_deep_extend("force", lsp_defaults.capabilities, capabilities)

      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "rust_analyzer",
          -- "lua_ls",
          -- "taplo",
          -- "bashls",
          -- "clangd",
          -- "pyright",
          -- "tailwindcss",
          -- "ts_ls",
          -- "gopls",
          -- "jdtls"
        },
        handlers = {
          function(server)
            lspconfig[server].setup({
              capabilities = capabilities,
            })
          end,
        },
      })

      -- require 'lspconfig'.clangd.setup {
      --   cmd = { "clangd", "--compile-commands-dir=build" },
      -- }


      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
          -- vim.keymap.set('n', '<C-f>', function()
          -- vim.lsp.buf.format { async = true }
          --end, opts)
        end,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        mapping = {
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-g>"] = cmp.mapping.complete(),
          ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      })


      require("mason-null-ls").setup({
        ensure_installed = { "prettierd", "black" },
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.black,
        },
      })

      vim.keymap.set("n", "<C-f>", vim.lsp.buf.format, {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
}
