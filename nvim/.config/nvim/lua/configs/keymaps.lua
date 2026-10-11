-- General File Operations:
-- <leader>w  - Save current file
-- <leader>q  - Close current window
-- <leader>Q  - Close all windows
-- <leader>x  - Save and close current window
-- <leader>X  - Save and close all windows
-- <leader>q! - Force close current window without saving
-- <leader>Q! - Force close all windows without saving
-- <leader>c  - Close current buffer

-- Buffer Navigation:
-- <S-h>      - Switch to previous buffer
-- <S-l>      - Switch to next buffer

-- Search and Replace:
-- <leader>s  - Find and replace current word under cursor
-- <leader>S  - Find and replace with last search pattern
-- <leader>h  - Clear search highlights

-- File Explorer:
-- -          - Open parent directory in file explorer
-- <leader>e  - Open file explorer

-- Terminal:
-- <leader>tt - Toggle terminal
-- <leader>tg - Toggle lazygit

-- Command Mode:
-- ;          - Enter command mode
-- :          - Enter command mode

-- Help and Documentation:
-- <leader>?  - Open cheatsheet for keybindings
-- <leader>ch - Open cheatsheet for keybindings
-- <leader>cm - Open full runtime keybind + command cheatsheet
-- <leader>ct - Open Telescope runtime keybind + command cheatsheet
-- :KeymapCheatsheet - Open full runtime keybind + command cheatsheet
-- :CheatsheetTelescope - Open Telescope runtime keybind + command cheatsheet

-- Configuration:
-- <leader>rl - Reload Neovim configuration and sync plugins

-- Window Navigation (vim-tmux-navigator):
-- <c-h>      - Navigate left
-- <c-j>      - Navigate down
-- <c-k>      - Navigate up
-- <c-l>      - Navigate right
-- <c-\>      - Navigate to previous window

local keymap = vim.keymap.set

-- General File Operations
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save current file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current window" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Close all windows" })
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and close current window" })
keymap("n", "<leader>X", "<cmd>xa<cr>", { desc = "Save and close all windows" })
keymap("n", "<leader>q!", "<cmd>q!<cr>", { desc = "Force close current window without saving" })
keymap("n", "<leader>Q!", "<cmd>qa!<cr>", { desc = "Force close all windows without saving" })
keymap("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- Buffer Navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Switch to previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })

-- Search and Replace
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and replace current word under cursor" })
keymap("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Find and replace with last search pattern" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- File Explorer
keymap("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory in file explorer" })
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Terminal
local terminal = require("configs.terminal")
keymap("n", "<leader>tt", terminal.regular_term_toggle, { desc = "Toggle terminal" })
keymap("n", "<leader>tg", terminal.lazygit_toggle, { desc = "Toggle lazygit" })

-- Command Mode
keymap("n", ";", ":", { desc = "Enter command mode" })
keymap("n", ":", ":", { desc = "Enter command mode" })

-- Help and Documentation
keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })
keymap("n", "<leader>ch", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })

-- Configuration
local function ReloadLazyConfig()
    for name, _ in pairs(package.loaded) do
        if name:match("^plugins") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.fn.stdpath("config") .. "/init.lua")
    vim.cmd("Lazy sync")
end
keymap("n", "<leader>rl", ReloadLazyConfig, { desc = "Reload Neovim configuration and sync plugins" })

local function OpenFullCheatsheet()
    local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
    local lines = {
        "# Neovim Keybind and Command Cheatsheet",
        "",
        "Generated at runtime from active mappings and user commands.",
        "",
        "## Global Keymaps",
        "",
    }

    local global_maps = {}
    for _, mode in ipairs(modes) do
        for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
            if map.lhs and map.lhs ~= "" then
                local rhs = map.rhs
                if rhs == nil or rhs == "" then
                    rhs = map.callback and "<Lua function>" or ""
                end
                table.insert(global_maps, {
                    mode = mode,
                    lhs = map.lhs,
                    rhs = rhs,
                    desc = map.desc or "",
                })
            end
        end
    end

    table.sort(global_maps, function(a, b)
        if a.mode == b.mode then
            return a.lhs < b.lhs
        end
        return a.mode < b.mode
    end)

    if #global_maps == 0 then
        table.insert(lines, "No global keymaps found.")
    else
        for _, map in ipairs(global_maps) do
            local suffix = map.desc ~= "" and (" - " .. map.desc) or ""
            table.insert(lines, string.format("- `%s` `%s` -> `%s`%s", map.mode, map.lhs, map.rhs, suffix))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "## Buffer-Local Keymaps")
    table.insert(lines, "")

    local buffer_maps = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            local short = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
            for _, mode in ipairs(modes) do
                for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do
                    if map.lhs and map.lhs ~= "" then
                        local rhs = map.rhs
                        if rhs == nil or rhs == "" then
                            rhs = map.callback and "<Lua function>" or ""
                        end
                        table.insert(buffer_maps, {
                            buffer = short,
                            mode = mode,
                            lhs = map.lhs,
                            rhs = rhs,
                            desc = map.desc or "",
                        })
                    end
                end
            end
        end
    end

    table.sort(buffer_maps, function(a, b)
        if a.buffer == b.buffer then
            if a.mode == b.mode then
                return a.lhs < b.lhs
            end
            return a.mode < b.mode
        end
        return a.buffer < b.buffer
    end)

    if #buffer_maps == 0 then
        table.insert(lines, "No buffer-local keymaps found.")
    else
        for _, map in ipairs(buffer_maps) do
            local suffix = map.desc ~= "" and (" - " .. map.desc) or ""
            table.insert(lines, string.format("- `%s` `%s` `%s` -> `%s`%s", map.buffer, map.mode, map.lhs, map.rhs, suffix))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "## User Commands")
    table.insert(lines, "")

    local commands = {}
    for name, cmd in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        table.insert(commands, {
            name = name,
            nargs = cmd.nargs or "0",
            def = cmd.definition or "",
        })
    end

    table.sort(commands, function(a, b)
        return a.name < b.name
    end)

    if #commands == 0 then
        table.insert(lines, "No user commands found.")
    else
        for _, cmd in ipairs(commands) do
            local def = cmd.def ~= "" and (" -> `" .. cmd.def .. "`") or ""
            table.insert(lines, string.format("- `:%s` (nargs=%s)%s", cmd.name, cmd.nargs, def))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "Press `q` to close this window.")

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = "markdown"

    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.85)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true
    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf, nowait = true, silent = true })
end

local function OpenCheatsheetTelescope()
    local ok = pcall(require, "telescope")
    if not ok then
        vim.notify("telescope.nvim is not available", vim.log.levels.ERROR)
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
    local entries = {}

    for _, mode in ipairs(modes) do
        for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
            if map.lhs and map.lhs ~= "" then
                local rhs = map.rhs
                if rhs == nil or rhs == "" then
                    rhs = map.callback and "<Lua function>" or ""
                end
                local desc = map.desc or ""
                table.insert(entries, {
                    display = string.format("[keymap] %s %s -> %s%s", mode, map.lhs, rhs,
                        desc ~= "" and (" (" .. desc .. ")") or ""),
                    kind = "keymap",
                    value = map.lhs,
                })
            end
        end
    end

    for name, cmd in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        local def = cmd.definition or ""
        table.insert(entries, {
            display = string.format("[command] :%s%s", name, def ~= "" and (" -> " .. def) or ""),
            kind = "command",
            value = name,
        })
    end

    table.sort(entries, function(a, b)
        return a.display < b.display
    end)

    pickers.new({}, {
        prompt_title = "Cheatsheet (Keymaps + Commands)",
        finder = finders.new_table({
            results = entries,
            entry_maker = function(item)
                return {
                    value = item,
                    display = item.display,
                    ordinal = item.display,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection and selection.value then
                    if selection.value.kind == "command" then
                        vim.api.nvim_feedkeys(":" .. selection.value.value, "n", false)
                    else
                        vim.notify(selection.value.display)
                    end
                end
            end)
            return true
        end,
    }):find()
end

if vim.fn.exists(":KeymapCheatsheet") == 2 then
    vim.api.nvim_del_user_command("KeymapCheatsheet")
end
vim.api.nvim_create_user_command("KeymapCheatsheet", OpenFullCheatsheet,
    { desc = "Open complete keymap and command cheatsheet" })
if vim.fn.exists(":CheatsheetTelescope") == 2 then
    vim.api.nvim_del_user_command("CheatsheetTelescope")
end
vim.api.nvim_create_user_command("CheatsheetTelescope", OpenCheatsheetTelescope,
    { desc = "Open keymap and command cheatsheet in Telescope" })
keymap("n", "<leader>cm", "<cmd>KeymapCheatsheet<cr>", { desc = "Open full keymap+command cheatsheet" })
keymap("n", "<leader>ct", "<cmd>CheatsheetTelescope<cr>", { desc = "Open keymap+command cheatsheet in Telescope" })

-- Window Navigation keymaps moved to vim-navigator.lua plugin config
