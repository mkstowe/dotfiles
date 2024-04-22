lvim.autocommands = {{
		{{
				{{ "ColorScheme" }},
				{{
						pattern = "*",
						callback = function()
							-- change `Normal` to the group you want to change
							-- and `#ffffff` to the color you want
							-- see `:h nvim_set_hl` for more options
							vim.api.nvim_set_hl(0, "Comment", {{ fg = "{color5}" }})
						end,
					}},
			}}
	}}
