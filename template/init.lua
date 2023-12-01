-- Generate an absolute path to a file in the same folder as this script.
-- @param filename The name (including extension) of the file to return a path for.
-- @return The path to the file.
function local_file(filename)
	local path = debug.getinfo(1).source
	path = path:sub(2, path:find("%w*%.lua")-1)
	return path .. filename
end

-- Add this script's folder as a place to import other scripts from.
package.path = local_file("?.lua") .. ";" .. package.path

-- Import and set up easy.
local easy = require("easy")
easy.setup(
    easy.vimrc(local_file("settings.vim")), -- Load vanilla vim settings from settings.vim
    easy.colorscheme("catppuccin/nvim", "catppuccin-mocha"), -- Set theme to catppuccin-mocha
    easy.lsps("clangd", "rust_analyzer"), -- Add C/C++ and rust language servers
    easy.keymaps(
        easy.mode("", 
            -- CTRL + F => Cycle between definition, declaration, and references
            easy.map_lsp("<C-F>", easy.smart_cycle)
        ),
        easy.mode("i",
            -- CTRL + Space => LSP Autocomplete
            easy.map_lsp("<C-Space>", vim.lsp.omnifunc)
        )
    )
)
