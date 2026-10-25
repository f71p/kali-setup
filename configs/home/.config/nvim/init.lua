-- Plain Neovim config: sensible defaults, no plugins.

vim.g.mapleader = " "

local o = vim.opt
-- Display
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.wrap = false
o.termguicolors = true
-- Indentation
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
-- Search
o.ignorecase = true
o.smartcase = true
-- Behaviour
o.mouse = "a"
o.clipboard = "unnamedplus"   -- share the system clipboard

-- Copy via OSC 52: the terminal (kitty) sets the clipboard, so copying works through tmux
-- (set-clipboard on) and over SSH. Paste still reads the X clipboard
-- (on WSL: the Windows clipboard, through win32yank from the wsl role).
local osc52 = require("vim.ui.clipboard.osc52")
local wsl_paste = vim.env.WSL_DISTRO_NAME and { "win32yank.exe", "-o", "--lf" }
vim.g.clipboard = {
  name = "osc52-copy",
  copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = {
    ["+"] = wsl_paste or { "xclip", "-o", "-selection", "clipboard" },
    ["*"] = wsl_paste or { "xclip", "-o", "-selection", "primary" },
  },
}
o.undofile = true             -- undo history survives closing the file
o.splitright = true
o.splitbelow = true
o.updatetime = 250
o.list = true                 -- show tabs, trailing spaces and odd spaces (handy for pasted payloads)
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.spelllang = "en_gb"

-- Finding things (built in, no plugins): :find uses fd, :grep uses rg, both skip .git
o.wildoptions:append("fuzzy")
o.wildmode = "noselect:lastused,full"   -- show matches without filling in the first one
o.pumheight = 15
o.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
local files_cache
function _G.FdFind(arg)
  files_cache = files_cache or vim.fn.systemlist({ "fd", "--type=f", "--hidden", "--exclude=.git" })
  return arg == "" and files_cache or vim.fn.matchfuzzy(files_cache, arg)
end
o.findfunc = "v:lua.FdFind"
-- Run fd once per command line, not on every key
vim.api.nvim_create_autocmd("CmdlineEnter", { pattern = ":", callback = function() files_cache = nil end })
-- Show matches as you type in :find and :buffer
vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = ":",
  callback = function()
    if vim.fn.getcmdline():match("^%s*fin?d?%s") or vim.fn.getcmdline():match("^%s*b%a*%s") then
      vim.fn.wildtrigger()
    end
  end,
})
-- Open the match list after :grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", { pattern = "grep", command = "cwindow" })
-- Spell check prose only
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function() vim.opt_local.spell = true end,
})

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")          -- clear search highlight
map("n", "<leader>w", "<cmd>w<CR>")               -- save
map("n", "<leader>q", "<cmd>q<CR>")               -- quit
map("n", "<leader>e", "<cmd>Explore<CR>")         -- file browser
map("n", "<leader>f", ":find ")                   -- find a file by name (fuzzy)
map("n", "<leader>g", ":silent grep! ")           -- search inside files; ]q/[q step through matches
map("n", "<leader>b", ":buffer ")                 -- switch open file
map({ "n", "i", "v" }, "<S-Esc>", "<cmd>confirm qa<CR>") -- shut everything down (asks if unsaved)
-- Splits use the stock Ctrl+W layer (Ctrl+W h/j/k/l, Ctrl+W q), as in keybinds.md
map("v", "<", "<gv")                              -- keep selection when indenting
map("v", ">", ">gv")
map("v", "<LeftRelease>", "ygv")                 -- mouse drag copies, selection stays

-- Transparent background: use the terminal's background instead of the colorscheme's
local function clear_bg()
  for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer" }) do
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = group }), { bg = "NONE" }))
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_bg })
clear_bg()

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})

-- Return to last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
