local map = vim.keymap.set
local M = {}

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== BASIC NAVIGATION =====
-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- File explorer
map("n", "<leader>pv", vim.cmd.Ex)

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ===== TEXT MANIPULATION =====
-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Better line joining
map("n", "J", "mzJ`z")

-- Center screen on navigation
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better paste
map("x", "<leader>p", [["_dP]])
map("x", "<leader>P", function()
	local clipboard_content = vim.fn.getreg("+")
	local selected_text = vim.fn.getreg('"')
	vim.fn.setreg("+", selected_text)
	vim.cmd('normal! "_dP')
	vim.fn.setreg("+", clipboard_content)
end)

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map({ "n", "v" }, "<leader>Y", [["+Y]])

-- Better escape
map("i", "<C-c>", "<Esc>")

-- Disable Q
map("n", "Q", "<nop>")

-- ===== QUICKFIX/LOCATION LISTS =====
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- ===== UTILITY =====
-- Format
map("n", "<leader>f", vim.lsp.buf.format)

-- Search and replace
map("n", "<leader>sub", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Go error snippet
map("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Tmux sessionizer
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>lt", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Source current file
map("n", "<leader>so", function()
	vim.cmd("so")
end)

-- ===== DIAGNOSTICS =====
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- ===== GIT (Fugitive) =====
map("n", "<leader>gs", vim.cmd.Git)
map("n", "gu", "<cmd>diffget //2<CR>")
map("n", "gh", "<cmd>diffget //3<CR>")

-- ===== UNDOTREE =====
map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- ===== NEOTREE =====
map("n", "\\", ":Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true })

-- ===== BUFFER NAVIGATION =====
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- ===== LAZYGIT =====
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- ===== LSP KEYMAPS SETUP FUNCTION =====
local M = {}

M.setup_lsp_keymaps = function(event)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- Inlay hints toggle (if supported)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints")
	end
end

-- ===== PLUGIN KEYMAP SETUP FUNCTIONS =====
-- M.setup_harpoon_keymaps = function(harpoon, toggle_telescope)
--   map('n', '<leader>a', function() harpoon:list():add() end)
--   map('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = 'Open harpoon window' })
--   map('n', '<C-t>', function() harpoon:list():select(2) end)
--   map('n', '<C-n>', function() harpoon:list():select(3) end)
--   map('n', '<C-s>', function() harpoon:list():select(4) end)
--   map('n', '<leader><C-h>', function() harpoon:list():replace_at(1) end)
--   map('n', '<leader><C-t>', function() harpoon:list():replace_at(2) end)
--   map('n', '<leader><C-n>', function() harpoon:list():replace_at(3) end)
--   map('n', '<leader><C-s>', function() harpoon:list():replace_at(4) end)
-- end

M.setup_telescope_keymaps = function(builtin, live_multigrep)
	map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	map("n", "<leader>sg", live_multigrep, { desc = "[S]earch by [G]rep" })
	map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

	map("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	map("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	map("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	map("n", "<leader>sen", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [E]dit [N]eovim files" })
end

M.setup_gitsigns_keymaps = function(gitsigns)
	local function map_git(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = opts.buffer or 0
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map_git("n", "]c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "]c", bang = true })
		else
			gitsigns.nav_hunk("next")
		end
	end, { desc = "Jump to next git [c]hange" })

	map_git("n", "[c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "[c", bang = true })
		else
			gitsigns.nav_hunk("prev")
		end
	end, { desc = "Jump to previous git [c]hange" })

	-- Actions
	map_git("v", "<leader>hs", function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "stage git hunk" })
	map_git("v", "<leader>hr", function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "reset git hunk" })
	map_git("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
	map_git("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
	map_git("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
	map_git("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
	map_git("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
	map_git("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
	map_git("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
	map_git("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
	map_git("n", "<leader>hD", function()
		gitsigns.diffthis("@")
	end, { desc = "git [D]iff against last commit" })
	map_git("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
	map_git("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
end

M.setup_completion_keymaps = function(cmp, luasnip)
	return cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),
		["<C-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
	})
end

M.setup_rustacean_keymaps = function(bufnr)
	local opts = { buffer = bufnr }
	map("n", "<leader>cR", function()
		vim.cmd.RustLsp("codeAction")
	end, vim.tbl_extend("force", opts, { desc = "Code Action" }))
	map("n", "<leader>dr", function()
		vim.cmd.RustLsp("debuggables")
	end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))
end

return M
