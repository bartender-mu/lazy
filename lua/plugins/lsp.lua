return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
			})
			table.insert(opts.ensure_installed, "black")
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			servers = {
				-- existing servers
				cssls = {},
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
				},
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							hint = { enable = true },
						},
					},
				},
				ruff = {
					cmd_env = { RUFF_TRACE = "messages" },
					init_options = {
						settings = {
							logLevel = "error",
						},
					},
					keys = {
						{
							"<leader>co",
							LazyVim.lsp.action["source.organizeImports"],
							desc = "Organize Imports",
						},
					},
				},
				ruff_lsp = {
					keys = {
						{
							"<leader>co",
							LazyVim.lsp.action["source.organizeImports"],
							desc = "Organize Imports",
						},
					},
				},
			},
			setup = {
				ruff = function()
					LazyVim.lsp.on_attach(function(client, _)
						client.server_capabilities.hoverProvider = false
					end, ruff)
				end,
			},
		},
	},

	-- extend with more server options
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local servers = { "pyright", "basedpyright", "ruff", "ruff_lsp" }
			for _, server in ipairs(servers) do
				opts.servers[server] = opts.servers[server] or {}
			end
		end,
	},

	-- keys setup
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(keys, {
				{
					"gd",
					function()
						require("telescope.builtin").lsp_definitions({ reuse_win = false })
					end,
					desc = "Goto Definition",
					has = "definition",
				},
			})
		end,
	},

	-- Add venv-selector.nvim

	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp", -- Use this branch for the new version
		cmd = "VenvSelect",
		enabled = function()
			return LazyVim.has("telescope.nvim")
		end,
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true, -- Notify when the venv is activated
				},
			},
		},
		ft = "python",
		keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
	},

	-- Add nvim-dap-python for Python debugging
	{
		"mfussenegger/nvim-dap-python",
		-- stylua: ignore
		keys = {
			{ "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
			{ "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
		},
		config = function()
			if vim.fn.has("win32") == 1 then
				require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
			else
				require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
			end
		end,
	},
}
