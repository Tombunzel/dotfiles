return {
	-- Installs LSP servers, formatters, and linters
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Bridges mason.nvim with nvim-lspconfig for automatic server setup
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			-- This is your list of servers that mason-lspconfig will ensure are installed.
			ensure_installed = {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				-- "typescript-language-server",
				"css-lsp",
				"html",
				"yamlls",
				"vtsls",
				"terraform-ls",
				"pyright",
				"ruff",
			},
		},
	},

	-- The main LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		-- This config function REPLACES the LazyVim default, fixing the hover bug.
		config = function()
			-- This function runs for each LSP server that attaches to a buffer.
			-- It's the perfect place for our keymaps.
			local on_attach = function(client, bufnr)
				-- --- Your Custom Keymaps ---
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (Type/Docs)" })
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show Line Diagnostics" })
				vim.keymap.set("n", "gd", function()
					require("telescope.builtin").lsp_definitions({ reuse_win = false })
				end, { buffer = bufnr, desc = "Goto Definition (Telescope)" })

				-- --- Other Standard LSP Keymaps ---
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
			end

			-- Standard capabilities for LSP servers.
			-- If you use nvim-cmp or blink.cmp for autocompletion, you would get these from there.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local has_blink, blink = pcall(require, "blink.cmp")
			if has_blink then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end
			-- Force utf-16 to resolve position encoding mismatch warnings
			capabilities.offsetEncoding = { "utf-16" }

			local lspconfig = require("lspconfig")

			-- --- Your Custom Server Configurations ---
			-- We define a table holding all your server-specific settings.
			local servers = {
				cssls = {},
				tailwindcss = {
					root_dir = lspconfig.util.root_pattern(".git"),
				},
				vtsls = {
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)

						local root = require("lspconfig.util").root_pattern(".git")(vim.api.nvim_buf_get_name(bufnr))
						if root and vim.fn.filereadable(root .. "/.prettierrc") > 0 then
							-- 3. If found, it disables the vtsls formatter to prevent conflicts
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end
					end,
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoImportCompletions = true,
								typeCheckingMode = "standard",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								indexing = true,
								extraPaths = { "." },
							},
						},
					},
				},
				ruff = {
					on_attach = function(client, bufnr)
						-- Run the global keymaps first
						on_attach(client, bufnr)
						-- Disable hover from Ruff to prefer Pyright's more detailed docs
						client.server_capabilities.hoverProvider = false
					end,
					init_options = {
						settings = {
							-- Any extra ruff settings can go here
							args = {},
						},
					},
				},
				-- tsserver = {
				-- 	single_file_support = false,
				-- 	settings = {
				-- 		typescript = {
				-- 			inlayHints = {
				-- 				includeInlayParameterNameHints = "literal",
				-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				-- 				includeInlayFunctionParameterTypeHints = true,
				-- 				includeInlayVariableTypeHints = false,
				-- 				includeInlayPropertyDeclarationTypeHints = true,
				-- 				includeInlayFunctionLikeReturnTypeHints = true,
				-- 				includeInlayEnumMemberValueHints = true,
				-- 			},
				-- 		},
				-- 		javascript = {
				-- 			inlayHints = {
				-- 				includeInlayParameterNameHints = "all",
				-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				-- 				includeInlayFunctionParameterTypeHints = true,
				-- 				includeInlayVariableTypeHints = true,
				-- 				includeInlayPropertyDeclarationTypeHints = true,
				-- 				includeInlayFunctionLikeReturnTypeHints = true,
				-- 				includeInlayEnumMemberValueHints = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
				html = {},
				terraformls = {
					filetypes = { "terraform", "tf", "tfvars" },
				},
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
							completion = { workspaceWord = true, callSnippet = "Both" },
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = { privateName = { "^_" } },
							type = { castNumberToInteger = true },
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								groupSeverity = { strong = "Warning", strict = "Warning" },
								groupFileStatus = {
									ambiguity = "Opened",
									await = "Opened",
									codestyle = "None",
									duplicate = "Opened",
									global = "Opened",
									luadoc = "Opened",
									redefined = "Opened",
									strict = "Opened",
									strong = "Opened",
									["type-check"] = "Opened",
									unbalanced = "Opened",
									unused = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = { enable = false },
						},
					},
				},
			}

			-- This loop sets up every server with your custom settings.
			for server_name, server_config in pairs(servers) do
				-- Merge the server-specific settings with our shared settings
				local final_config = vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
					-- This carries over your global preference from your old file
					inlay_hints = { enabled = false },
				}, server_config)

				lspconfig[server_name].setup(final_config)
			end
		end,
	},

	-- We can keep your markview config here, correctly configured to be lazy.
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown" }, -- Only loads for markdown files
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
