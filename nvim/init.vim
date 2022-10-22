let g:copilot_filetypes = {
   \ 'gitcommit': v:true,
   \ }

call plug#begin()
Plug 'github/copilot.vim' " copilot
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'sbdchd/neoformat' " prettier
Plug 'neovim/nvim-lspconfig' " LSP
call plug#end()

augroup fmt " prettier
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" relative numbers
:set number relativenumber

lua require('config')
