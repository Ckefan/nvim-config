local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

local keymaps = {
  insert_mode = {
  },
  normal_mode = {
    ["<leader>e"] = ":NvimTreeToggle<CR>",
    ["<leader>f"] = "<cmd>lua vim.diagnostic.open_float()<CR>",
    ["<leader>ff"] = "<cmd>lua require('telescope.builtin').find_files()<CR>",
    ["<leader>fg"] = "<cmd>lua require('telescope.builtin').live_grep()<CR>",
    ["<leader>fb"] = "<cmd>lua require('telescope.builtin').buffers()<CR>",
    ["<leader>fh"] = "<cmd>lua require('telescope.builtin').help_tags()<CR>",
    ["<leader>fc"] = "<cmd>lua require('telescope.builtin').colorscheme()<CR>",
    ["<leader>mt"] = "<cmd>lua require('memento').toggle()<CR>",
    ["<leader>mc"] = "<cmd>lua require('memento').clear_history()<CR>",
    ["<leader>g"] = "<cmd>lua _lazygit_toggle()<CR>",
    ["<leader>r"] = ":QuickRun<CR>",
    ["<leader>a"] = ":AerialToggle<CR>",
    ["<leader>p"] = ":PackerSync<CR>",
    ["<leader>dd"] = ":Dash<CR>",
    
    ["<C-s>"]=":w<CR>",
    -- 下option + hjkl  窗口之间跳转
    ["∑"] = "<C-w>w",
    ["˙"] = "<C-w>h",
    ["∆"] = "<C-w>k",
    ["˚"] = "<C-w>j",
    ["¬"] = "<C-w>l",

     --上下左右分屏
    ["<space>v"] = ":vsp<CR>",
    ["<space>h"] = ":sp<CR>",
    ["<leader>c"] = ":BufferLinePickClose<CR>",

    -- 左右上下等比 比例控制
    ["<space>,"] = ":vertical resize -20<CR>",
    ["<space>."] = ":vertical resize +20<CR>",
    ["<space>j"] = ":resize +10<CR>",
    ["<space>k"] = ":resize -10<CR>",
    ["<space>="] = "<C-w>=",

    -- 左右切换tab
    ["<C-h>"] = ":BufferLineCyclePrev<CR>",
    ["<C-l>"] = ":BufferLineCycleNext<CR>",

    -- 上下移动选中文本
    ["K"] = ":m .-2<CR>",
    ["J"] = ":m .+1<CR>",
 
  },
  visual_mode = {
    -- 上下移动选中文本
    ["J"] = ":move '>+1<CR>gv-gv",
    ["K"] = ":move '<-2<CR>gv-gv",
  }
}
function M.append_to_defaults(keymaps)
  for mode, mappings in pairs(keymaps) do
    for k, v in pairs(mappings) do
      keymaps[mode][k] = v
    end
  end
end

function M.clear(keymaps)
  local default = M.get_defaults()
  for mode, mappings in pairs(keymaps) do
    local translated_mode = mode_adapters[mode] or mode
    for key, _ in pairs(mappings) do
      if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
        pcall(vim.api.nvim_del_keymap, translated_mode, key)
      end
    end
  end
end

function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] or generic_opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  if val then
    vim.api.nvim_set_keymap(mode, key, val, opt)
  else
    pcall(vim.api.nvim_del_keymap, mode, key)
  end
end

function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

function M.load()
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

return M
