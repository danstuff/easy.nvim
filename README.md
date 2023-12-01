# easy.nvim

Easily configure neovim with language servers, themes, and custom keybinds.

## Getting Started

### Prerequisites

Easy.nvim requires [neovim](https://neovim.io/) v0.9 or later.

### Installation

On **Ubuntu** and similar Linux distros, installation is as simple as cloning this repository and runnning `./install.sh`:

```
git clone https://github.com/danstuff/easy.nvim.git
cd easy.nvim
./install.sh
```

The installl script will copy `easy.nvim/easy.lua` to the Neovim config folder at `~/.config/nvim/`, along with 2 template configuration files if desired. 

On **Windows** or other platforms where the Neovim config folder is not `~/.config/nvim/`, you can copy `easy.nvim/easy.lua` and/or the template files into the config folder manually.

### Usage

Take a look at the [template init.lua file](template/init.lua) for an example configuration to help you get started. If you previously used vanilla vim, a good place to start is to import your settings by changing the path given to `easy.vimrc(...)`.

For more information, please refer to the in-code documentation in [easy.lua](easy.lua).
