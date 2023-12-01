# easy.nvim

Easily configure neovim with language servers, themes, and custom keybinds.

## Getting Started

### Prerequisites

Easy.nvim requires [neovim](https://neovim.io/) v0.9 or later.

### Installation

On **Ubuntu** and some other Linux distros, installation is as simple as cloning this repository and runnning `./install.sh`:

```
git clone https://github.com/danstuff/easy.nvim.git
cd easy.nvim
./install.sh
```

The installl script will copy `easy.nvim/easy.lua` to the Neovim config folder at `~/.config/nvim/`, along with 2 example configuration files if desired. 

On **Windows** and other platforms where the Neovim config folder is not `~/.config/nvim/`, you can copy `easy.nvim/easy.lua` into the config folder manually.

### Usage

To use easy.nvim, you will need an `init.lua` file in your Neovim configuration folder. In that file, you can use `local easy = require("nvim/easy")` to import easy.nvim, and use `easy.setup(...)` to initialize and configure neovim as desired. 

Below is a possible configuration for `init.lua`, which can also be found [in the examples folder](examples/init.lua).

```
local easy = require("nvim/easy")
easy.setup(
    easy.vimrc("nvim/settings.vim"), -- Load vanilla vim settings from a settings.vim file
    easy.colorscheme("catppuccin/nvim", "catppuccin-mocha"), -- Set theme to catppuccin-mocha
    easy.lsps("clangd", "rust_analyzer"), -- Add C/C++ and rust language servers
    easy.keymaps(
        easy.mode("", -- Add the following keymaps to all modes

            -- CTRL + Space => Autocomplete, use LSP if attached
            easy.map("<C-Space>", easy.omnifunc), 
            
            -- CTRL + F => Cycle between definition, declaration, and references
            easy.map_lsp("<C-F>", easy.smart_cycle)
        )
    )
)

```

For more information, please refer to the in-code documentation in [easy.lua](easy.lua).
