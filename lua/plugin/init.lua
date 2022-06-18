local fn = vim.fn
local cmd = vim.cmd

local function get_setup(name)
  return string.format('require("plugin.config.%s")', name)
end

local M = {}

function M.setup()
  local packer_bootstrap = false

  local function packer_init()
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      cmd [[packadd packer.nvim]]
    end
    cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  local function plugins(use)
    use "wbthomason/packer.nvim"
    use "williamboman/nvim-lsp-installer"
    use "neovim/nvim-lspconfig"
    use "onsails/lspkind-nvim"
    use "hrsh7th/nvim-cmp"
    use {
      "hrsh7th/cmp-nvim-lsp",
      requires = {
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
      },
      config = get_setup("cmp")
    }
    use "saadparwaiz1/cmp_luasnip"
    use { "L3MON4D3/LuaSnip",
      config = function()
        require("luasnip.loaders.from_lua").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load {
        }
        require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = get_setup("treesitter")
    }
    use {
      "windwp/nvim-autopairs",
      config = get_setup("autopairs")
    }
    use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
    use "folke/lsp-colors.nvim"
    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      config = get_setup("nvim-tree")
    }
    use "nvim-lua/plenary.nvim"
    use {
      "nvim-telescope/telescope.nvim",
      config = get_setup("telescope")
    }
    use {
      "jose-elias-alvarez/null-ls.nvim",
      config = get_setup("null-ls")
    }

    use {
      "akinsho/toggleterm.nvim",
      branch = "main",
      config = get_setup("terminal"),
    }

    use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    }

    use "thinca/vim-quickrun"

    -- 主题
    use "frenzyexists/aquarium-vim"
    use 'folke/tokyonight.nvim'

    use {
      "ahmedkhalf/project.nvim",
      config = get_setup("project")
    }

    use {
      'goolord/alpha-nvim',
      config = get_setup('alpha')
    }

    use "github/copilot.vim"

    use {
      "numToStr/Comment.nvim",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring"
      },
      event = "BufRead",
      config = get_setup('comment')
    }

    use {
      "simrat39/rust-tools.nvim",
      config = get_setup('rust-tools')
    }

    use "rizzatti/dash.vim"
    use "vim-test/vim-test"
    use "hrsh7th/cmp-path"
    use 'mfussenegger/nvim-dap'

    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim', config = get_setup('flutter-tools') }

    -- 底部状态栏美化
    use {
      "windwp/windline.nvim",
      config = function()
        require('wlsample.bubble')
      end
    }
    -- 顶部菜单栏
    use { 'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons', config = get_setup('bufferline') }

    -- 添加修改字符两头符号
    use { "ur4ltz/surround.nvim", config = function()
      require "surround".setup { mappings_style = "surround" }
    end
    }

    -- Git
    use { 'lewis6991/gitsigns.nvim', config = function()
      require('gitsigns').setup()
    end
    }

    -- 输入提示 input prompt
    use { "folke/which-key.nvim", config = get_setup('whichkey') }

    -- 缩进指南 indent guide
    use { "lukas-reineke/indent-blankline.nvim", config = get_setup('indent-blankline') }

    -- 代码大纲 code catalog
    use { 'stevearc/aerial.nvim', config = function()
      require('aerial').setup()
    end
    }

    -- git 日志 git log
    use 'f-person/git-blame.nvim'

    -- 字符跳转 character jump
    use 'ggandor/lightspeed.nvim'

    -- 记录历史文件并打开 record history open file
    use 'gaborvecsei/memento.nvim'

    -- 彩虹括号🌈 rainbow brackets
    use 'p00f/nvim-ts-rainbow'

    -- 自动保存 auto save file :qa!
    -- use { "Pocco81/AutoSave.nvim", config = function()
    --   require('autosave').setup()
    -- end
    -- }

    --  透明背景
    use { "xiyaowong/nvim-transparent", config = get_setup('transparent-config') }

    -- 代码色值显示
    use { 'norcalli/nvim-colorizer.lua', config = function()
      require('colorizer').setup()
    end
    }

    -- 方法底部导航
    use { "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" }
    
    -- 批量光标
    use 'terryma/vim-multiple-cursors'

    use({
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn["mkdp#util#install"]() end,
    })

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()
  local packer = require "packer"
  packer.init()
  packer.startup(plugins)
end

return M
