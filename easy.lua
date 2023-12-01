local easy = {}
easy.lsp_attached = false

-- Specify what colorscheme to use for the editor.
-- @param plugin_name The name of the lazy.nvim plugin that contains the desired colorscheme.
-- @param scheme_name The name of the desired colorscheme to use from the plugin.
-- @return A colorscheme object to provide to easy.configure(...).
easy.colorscheme = function(plugin_name, scheme_name)
    assert(plugin_name and scheme_name)
    return { plugin_name = plugin_name, scheme_name = scheme_name }
end

-- Define a list of language servers to download and use in the editor.
-- @param ... String names of the servers to load (see :help lspconfig-all).
-- @return The LSP list.
easy.lsps = function(...)
    return { ... }
end

-- Define a keymap inside a mode.
-- @param keys The vim key combination to map an action to (e.g. "<C-F>" for Ctrl + F).
-- @param action_func The function to call when the key combination is pressed.
-- @return A map object to provide to mode(...).
easy.map = function(keys, action_func)
    assert(keys and action_func)
    return { keys = keys, action = action_func }
end

-- Define a keymap inside a mode that depends on an active LSP to be used.
-- @param keys The vim key combination to map an action to (e.g. "<C-F>" for Ctrl + F).
-- @param action_func The function to call when the key combination is pressed.
-- @return A map object to provide to mode(...).
easy.map_lsp = function(keys, action_func)
    local b = easy.map(keys, action_func)
    b.group = "lsp"
    return b
end

-- Define a set of keymaps that work in one or more editor modes.
-- @param label "i" for insert mode, "n" for normal, "v" for visual, or "" for all modes.
-- @param ... The keymaps to add to this mode from map(...) or map_lsp(...).
-- @return A mode object to provide to keymaps(...).
easy.mode = function(label, ...)
    assert(label)
    return { label = label, maps = { ... } }
end

-- Define all keymaps in all modes that you wish to provide to easy.configure(...).
-- @param ... mode(...) objects that contain keymaps from map(...) or map_lsp(...).
-- @return The keymap object to provide to easy.configure(...).
easy.keymaps = function(...)
    return { ... }
end

-- Optionally define a .vim or .vimrc file to load settings from a vanilla vim installation.
-- @param path A path to a .vim or .vimrc file.
-- @return An object to pass to easy.configure(...).
easy.vimrc = function(path)
    assert(path)
    return { path = path }
end

-- Add a core neovim plugin from a git repository.
-- @param name The name to save the plugin under, for use in require(name).
-- @param git_url The url of the git repository to download the plugin from.
-- @param branch The branch of the git repository to use for the plugin version.
-- @return The result of require(name).
easy.add_core_plugin = function(name, git_url, branch)
    local path = vim.fn.stdpath("data") .. "/" .. name
    if not vim.loop.fs_stat(path) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            git_url,
            "--branch="..branch,
            path,
        })
    end
    vim.opt.rtp:prepend(path)
end

-- Each time this function is called, cycle between the definition, the declaration,
-- and all references of the token at the cursor position.
easy.smart_cycle = function(...)
    local on_definition = false
    local on_declaration = false
    local tokens = vim.lsp.semantic_tokens.get_at_pos()
    if tokens then
        for k,token in pairs(tokens) do
            if token.modifiers["definition"] then
                on_definition = true
            elseif token.modifiers["declaration"] then
                on_declaration = true
            end
        end
        
        if not on_definition and not on_declaration then
            return vim.lsp.buf.definition(...)
        elseif on_definition then
            return vim.lsp.buf.declaration(...)
        elseif on_declaration then
            return vim.lsp.buf.references(...)
        end
    end
end

-- Load a .vim file, load all required lazy plugins, set colorscheme, setup lsps, and set keybinds.
-- @param vimrc a .vim or .vimrc file with vanilla .vim config.
-- @param colorscheme the result of easy.colorscheme(...) or nil.
-- @param lsps the result of lsps(...) or nil.
-- @param keymaps the result of keymaps(...) or nil.
easy.setup = function(vimrc, colorscheme, lsps, keymaps)
    -- Load any vanilla vim config from a given vim file
    if vimrc then
        vim.cmd("source " .. vimrc.path)
    end

    -- Add lazy
    easy.add_core_plugin(
        "lazy/lazy.nvim", 
        "https://github.com/folke/lazy.nvim.git",
        "stable")

    -- Add lazy plugins
    local plugins = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "neovim/nvim-lspconfig" },
    }
    if colorscheme then 
        table.insert(plugins, { colorscheme.plugin_name, priority = 1000 })
    end
    require("lazy").setup(plugins)

    -- Set colorscheme
    if colorscheme then
        vim.cmd("colorscheme " .. colorscheme.scheme_name)
    end

    -- Setup language servers
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = lsps,
    })

    local lspconfig = require("lspconfig")
    for k,lsp in pairs(lsps) do
        lspconfig[lsp].setup({})
    end

    if keymaps then
        function set_map(mode, map, opts)
            vim.keymap.set(mode.label, map.keys, map.action, opts)
        end

        -- Set plain keymaps while gathering "lsp" grouped maps in a separate list
        local lsp_modes = {}
        for mode_name,mode in pairs(keymaps) do
            for k,map in pairs(mode.maps) do
                if map.group == "lsp" then
                    if not lsp_modes[mode_name] then
                        lsp_modes[mode_name] = { 
                            label = mode.label,
                            maps = {}
                        }
                    end
                    table.insert(lsp_modes[mode_name].maps, map)
                else
                    set_map(mode, map)
                end
            end
        end

        -- Set keymaps that require lsp context
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }
                for k,mode in pairs(lsp_modes) do
                    for k,map in pairs(mode.maps) do
                        set_map(mode, map, opts)
                    end
                end
            end
        })
    end
end

return easy
