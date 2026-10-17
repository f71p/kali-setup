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

-- Copy via OSC 52: the terminal (kitty) sets the clipboard, offering the formats VMware's
-- host clipboard sync needs (xclip only offers UTF8_STRING, which never reaches the host).
-- Works through tmux (set-clipboard on) and over SSH. Paste still reads the X clipboard.
local osc52 = require("vim.ui.clipboard.osc52")
vim.g.clipboard = {
  name = "osc52-copy",
  copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = {
    ["+"] = { "xclip", "-o", "-selection", "clipboard" },
    ["*"] = { "xclip", "-o", "-selection", "primary" },
  },
}
o.undofile = true             -- undo history survives closing the file
o.splitright = true
o.splitbelow = true
o.updatetime = 250

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")          -- clear search highlight
map("n", "<leader>w", "<cmd>w<CR>")               -- save
map("n", "<leader>q", "<cmd>q<CR>")               -- quit
map("n", "<leader>e", "<cmd>Explore<CR>")         -- file browser
map("n", "<C-h>", "<C-w>h")                       -- move between splits
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
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
