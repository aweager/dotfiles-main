call plug#begin()

"motions and text objects
Plug 'bkad/CamelCaseMotion'
Plug 'michaeljsmith/vim-indent-object'

"better folding
Plug 'pedrohdz/vim-yaml-folds'
Plug 'tmhedberg/SimpylFold'

"fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"kitty.conf syntax highlighting
Plug 'fladson/vim-kitty'

"completion engine
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

"colorschemes
Plug 'morhetz/gruvbox'
Plug 'dracula/vim'
Plug 'cocopon/iceberg.vim'

"debugging
Plug 'puremourning/vimspector'

if has('nvim')
    "make it pretty
    Plug 'nanozuki/tabby.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    "plugin manager for lsp, lint, format
    Plug 'williamboman/mason.nvim'

    "formatter and linter
    Plug 'mhartington/formatter.nvim'
    Plug 'mfussenegger/nvim-lint'

    "lsp config
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'kosayoda/nvim-lightbulb'

    "neovim lsp-based completion
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/nvim-cmp'

    "neovim lua symbol includes
    Plug 'folke/neodev.nvim'
endif

call plug#end()

colorscheme iceberg
