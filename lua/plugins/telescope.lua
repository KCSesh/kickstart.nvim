return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Multi Grep function
    local live_multigrep = function(opts)
      opts = opts or {}
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local make_entry = require 'telescope.make_entry'
      local conf = require('telescope.config').values

      opts.cwd = opts.cwd or vim.uv.cwd()

      local finder = finders.new_async_job {
        command_generator = function(prompt)
          if not prompt or prompt == '' then
            return nil
          end

          local pieces = vim.split(prompt, '  ')
          local args = { 'rg' }
          if pieces[1] then
            table.insert(args, '-e')
            table.insert(args, pieces[1])
          end

          if pieces[2] then
            table.insert(args, '-g')
            table.insert(args, pieces[2])
          end

          return vim.tbl_flatten {
            args,
            { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
          }
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
      }

      pickers
        .new(opts, {
          debounce = 100,
          prompt_title = 'Live Multigrep',
          finder = finder,
          previewer = conf.grep_previewer(opts),
          sorter = require('telescope.sorters').empty(),
        })
        :find()
    end

    require('telescope').setup {
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--no-ignore',
          '-L',
        },
      },
      pickers = {
        find_files = {
          find_command = { 'fd', '--type', 'f', '--hidden', '--follow', '--no-ignore', '--exclude', '.git' },
        },
        live_grep = {
          additional_args = function(opts)
            return { '--hidden', '--no-ignore', '-L' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Setup keymaps
    local builtin = require 'telescope.builtin'
    require('config.keymaps').setup_telescope_keymaps(builtin, live_multigrep)
  end,
}
