local utils = require("utils")
local fn = vim.fn

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

--- Install packer if it has not been installed.
--- Return:
--- true: if this is a fresh install of packer
--- false: if packer has been installed
local function packer_ensure_install()
  -- Where to install packer.nvim -- the package manager (we make it opt)
  local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

  if fn.glob(packer_dir) ~= "" then
    return false
  end

  -- Auto-install packer in case it hasn't been installed.
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})

  local packer_repo = "https://github.com/wbthomason/packer.nvim"
  local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)
  vim.cmd(install_cmd)

  return true
end


local fresh_install = packer_ensure_install()

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require("packer.util")

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

packer.init({
  git = {
    clone_timeout = 180
  }
})

packer.startup {
  function(use)
    -- it is recommended to put impatient.nvim before any other plugins
    use { "lewis6991/impatient.nvim", config = [[require('impatient')]] }

    use { "wbthomason/packer.nvim", opt = true }

    use { "onsails/lspkind-nvim", event = "VimEnter" }

    use { "github/copilot.vim", event = "VimEnter" }

    -- auto-completion engine
    use { "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]] }

    -- nvim-cmp completion sources
    use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
    use { "hrsh7th/cmp-path", after = "nvim-cmp" }
    use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
    use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
    use { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "ultisnips" } }
    if vim.g.is_mac then
      use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
    end

    -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
    use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]] }

    use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufEnter",
      run = ":TSUpdate",
      config = [[require('config.treesitter')]],
    }

    use {
      "~/.dotfiles/custom-nvim-plugins/reply.vim",
      cmd = "Repl"
    }

    -- Python indent (follows the PEP8 style)
    use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

    -- Python-related text object
    use { "jeetsukumaran/vim-pythonsense", ft = { "python" } }

    use { "machakann/vim-swap", event = "VimEnter" }

    -- Super fast buffer jump
    use {
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim_hop")
        end, 2000)
      end,
    }

    -- Show match number and index for searching
    use {
      "kevinhwang91/nvim-hlslens",
      branch = "main",
      keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
      config = [[require('config.hlslens')]],
    }

    use {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
      }
    }

    use { "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" }

    -- A list of colorscheme plugin you may want to try. Find what suits you.
    use { "lifepillar/vim-gruvbox8", opt = true }
    use { "mcchrish/zenbones.nvim", opt = true }
    use { "navarasu/onedark.nvim", opt = true }
    use { "sainnhe/edge", opt = true }
    use { "sainnhe/sonokai", opt = true }
    use { "sainnhe/gruvbox-material", opt = true }
    use { "shaunsingh/nord.nvim", opt = true }
    use { "NTBBloodbath/doom-one.nvim", opt = true }
    use { "sainnhe/everforest", opt = true }
    use { "EdenEast/nightfox.nvim", opt = true }
    use { "rebelot/kanagawa.nvim", opt = true }
    use { "catppuccin/nvim", as = "catppuccin", opt = true }
    use { "ericbn/vim-solarized", opt = true }
    use { "ishan9299/nvim-solarized-lua", opt = true }
    use { "Abstract-IDE/Abstract-cs", opt = true }

    use { "kyazdani42/nvim-web-devicons", event = "VimEnter" }

    -- Warnings
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons"
    }

    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.statusline')]],
    }

    use { "akinsho/bufferline.nvim", event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.bufferline')]] }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "VimEnter",
      config = [[require('config.indent-blankline')]],
    }

    -- Highlight URLs inside vim
    use { "itchyny/vim-highlighturl", event = "VimEnter" }

    -- notification plugin
    use {
      "rcarriga/nvim-notify",
      event = "BufEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim-notify")
        end, 2000)
      end,
    }

    -- Only install these plugins if ctags are installed on the system
    if utils.executable("ctags") then
      -- show file tags in vim window
      use { "liuchengxu/vista.vim", cmd = "Vista" }
    end

    -- Snippet engine and snippet template
    use { "SirVer/ultisnips", event = "InsertEnter" }
    use { "~/.dotfiles/custom-nvim-plugins/vim-snippets", after = "ultisnips" }

    -- Automatic insertion and deletion of a pair of characters
    use { "Raimondi/delimitMate", event = "InsertEnter" }

    -- Comment plugin
    use { "tpope/vim-commentary", event = "VimEnter" }

    -- Multiple cursor plugin like Sublime Text?
    -- use 'mg979/vim-visual-multi'

    -- Autosave files on certain events
    use { "907th/vim-auto-save", event = "InsertEnter" }

    -- Manage your yank history
    if vim.g.is_win or vim.g.is_mac then
      use { "svermeulen/vim-yoink", event = "VimEnter" }
    end

    -- Handy unix command inside Vim (Rename, Move etc.)
    use { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } }

    -- Repeat vim motions
    use { "tpope/vim-repeat", event = "VimEnter" }

    use { "nvim-zh/better-escape.vim", event = { "InsertEnter" } }

    if vim.g.is_mac then
      use { "lyokha/vim-xkbswitch", event = { "InsertEnter" } }
    elseif vim.g.is_win then
      use { "Neur1n/neuims", event = { "InsertEnter" } }
    end

    -- Auto format tools
    use { "sbdchd/neoformat", cmd = { "Neoformat" } }

    -- Peek into zip files
    use { "lbrayner/vim-rzip" }

    -- Git command inside vim
    use { "tpope/vim-fugitive", event = "User InGitRepo", config = [[require('config.fugitive')]] }

    -- Better git log display
    use { "rbong/vim-flog", requires = "tpope/vim-fugitive", cmd = { "Flog" } }

    use { "christoomey/vim-conflicted", requires = "tpope/vim-fugitive", cmd = { "Conflicted" } }

    use {
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      event = "User InGitRepo",
      config = [[require('config.git-linker')]],
    }

    -- Show git change (change, delete, add) signs in vim sign column
    use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }

    -- Better git commit experience
    use { "rhysd/committia.vim", opt = true, setup = [[vim.cmd('packadd committia.vim')]] }

    use { "kevinhwang91/nvim-bqf", ft = "qf", config = [[require('config.bqf')]] }

    -- Another markdown plugin
    use { "preservim/vim-markdown", ft = { "markdown" } }

    -- Faster footnote generation
    -- use { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } }

    -- Pandoc

    -- (sk) Pandoc
    use { "vim-pandoc/vim-pandoc", ft = { "tex", "md", "markdown", "pandoc" } }
    use { "vim-pandoc/vim-pandoc-syntax", ft = { "tex", "md", "markdown", "pandoc" } }

    -- Vim tabular plugin for manipulate tabular, required by markdown plugins
    use { "godlygeek/tabular", cmd = { "Tabularize" } }

    -- Markdown JSON header highlight plugin
    use { "elzr/vim-json", ft = { "json", "markdown" } }

    use { "folke/zen-mode.nvim", cmd = "ZenMode", config = [[require('config.zen-mode')]] }

    if vim.g.is_mac then
      use { "rhysd/vim-grammarous", ft = { "markdown" } }
    end

    use { "chrisbra/unicode.vim", event = "VimEnter" }

    -- Additional powerful text object for vim, this plugin should be studied
    -- carefully to use its full power
    use { "wellle/targets.vim", event = "VimEnter" }

    -- Plugin to manipulate character pairs quickly
    use { "machakann/vim-sandwich", event = "VimEnter" }

    -- Add indent object for vim (useful for languages like Python)
    use { "michaeljsmith/vim-indent-object", event = "VimEnter" }

    -- Vimtex
    use { "lervag/vimtex", ft = { "tex" } }

    -- Since tmux is only available on Linux and Mac, we only enable these plugins
    -- for Linux and Mac
    if utils.executable("tmux") then
      -- .tmux.conf syntax highlighting and setting check
      use { "tmux-plugins/vim-tmux", ft = { "tmux" } }
    end

    -- Modern matchit implementation
    use { "andymass/vim-matchup", event = "VimEnter" }

    use { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } }

    -- Asynchronous command execution
    use { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } }

    use { "cespare/vim-toml", ft = { "toml" }, branch = "main" }

    -- Debugger plugin
    if vim.g.is_win or vim.g.is_linux then
      use { "sakhnik/nvim-gdb", run = { "bash install.sh" }, opt = true, setup = [[vim.cmd('packadd nvim-gdb')]] }
    end

    -- Session management plugin
    use { "tpope/vim-obsession", cmd = "Obsession" }

    if vim.g.is_linux then
      use { "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" } }
    end

    -- The missing auto-completion for cmdline!
    use { "gelguy/wilder.nvim", opt = true, setup = [[vim.cmd('packadd wilder.nvim')]] }

    -- showing keybindings
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.which-key")
        end, 2000)
      end,
    }

    -- show and trim trailing whitespaces
    use { "jdhao/whitespace.nvim", event = "VimEnter" }

    use { "ii14/emmylua-nvim", ft = "lua" }

    use { "j-hui/fidget.nvim", after = "nvim-lspconfig", config = [[require('config.fidget-nvim')]] }
  end,
  config = {
    max_jobs = 16,
    compile_path = packer_util.join_paths(fn.stdpath("data"), "site", "lua", "packer_compiled.lua"),
  },
}

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
  -- So plugin installation should be done after the startup process.
  packer.sync()
else
  local status, _ = pcall(require, "packer_compiled")
  if not status then
    local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
    vim.notify(msg, vim.log.levels.ERROR, { title = "Neovim" })
  end
end
