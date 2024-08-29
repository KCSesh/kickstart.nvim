return {
   { 'rust-lang/rust.vim' },
--      {
  --      'mrcjkb/rustaceanvim',
      --  version = '^4', -- Recommended
    --    lazy = false, -- This plugin is already lazy
      --}
  {
    "mrcjkb/rustaceanvim",
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- register which-key mappings
          local wk = require("which-key")
          wk.register({
            ["<leader>cR"] = { function() vim.cmd.RustLsp("codeAction") end, "Code Action" },
            ["<leader>dr"] = { function() vim.cmd.RustLsp("debuggables") end, "Rust debuggables" },
            --["<leader>rf"] = { function() vim.lsp.buf.format) },
          }, { mode = "n", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      }
    },

    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force",
        {},
        opts or {})
    end
  },
}

