" ==============================================
" BASIC SETTINGS {{{
" ==============================================
filetype indent plugin on
syntax enable on

let mapleader=","
set showmatch
set hidden
set nobackup
set nowritebackup
"set cmdheight=2

set autoread
set autoindent
set formatoptions-=cro
set incsearch
set ignorecase smartcase
set hlsearch
set wildmenu
set wildignore=*.o,*~,*.pyc
set tabstop=4
set shiftwidth=4
set softtabstop=4
set foldmethod=syntax
set nofoldenable
set noswapfile
set relativenumber number
set number
set mouse=a
set wildmode=full
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
set fileencodings=utf-8,gbk

" Semi-persistent undo
 if has("persistent_undo")
	 set undodir=$HOME."/.undodir"
	 set undofile
 endif
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Colors
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


""replace tab with space only in c and cpp
autocmd FileType vimrc,py,cpp set shiftwidth=4 | set expandtab
"snippet file must disable expand tab to space
" }}} BASIC SETTINGS

" ==============================================
" BASIC Mappings
" ==============================================

" ---------------------------------------------
" Normal Mode Setting
" ---------------------------------------------
nnoremap ; :
nnoremap m *N
xnoremap v <C-V>
vnoremap // y/<c-r>"<cr>"

" Quit
nnoremap t :q<CR>

" Escaping
inoremap jj <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
nnoremap Q @q

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>

" Tags
nnoremap <C-]> g<C-]>
nnoremap g[ :pop<cr>

" Window Switch
nnoremap <tab> <C-W>w

" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
"nnoremap ]t :tabn<cr>
"nnoremap [t :tabp<cr>
nnoremap <leader>t :tabs<cr>
" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv
xnoremap <silent> <C-h> <gv
xnoremap <silent> <C-l> >gv

" ----------------------------------------------------------------------------
" <Leader>c Close quickfix/location window
" ----------------------------------------------------------------------------
" nnoremap <leader>c :cclose<bar>lclose<cr>

" ----------------------------------------------------------------------------
" #gi / #gpi | go to next/previous indentation level
" ----------------------------------------------------------------------------
function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction
nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

cmap ww w !sudo tee % > /dev/null
iab xdt <c-r>=strftime("        %F %A")

" }}} BASIC MAPPING

" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" :Count
" ----------------------------------------------------------------------------
command! -nargs=1 Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``


" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root()

" ----------------------------------------------------------------------------
" <F5> / <F6> | Run script
" ----------------------------------------------------------------------------
function! s:run_this_script(output)
  let head   = getline(1)
  let pos    = stridx(head, '#!')
  let file   = expand('%:p')
  let ofile  = tempname()
  let rdr    = " 2>&1 | tee ".ofile
  let win    = winnr()
  let prefix = a:output ? 'silent !' : '!'
  " Shebang found
  if pos != -1
    execute prefix.strpart(head, pos + 2).' '.file.rdr
  " Shebang not found but executable
  elseif executable(file)
    execute prefix.file.rdr
  elseif &filetype == 'ruby'
    execute prefix.'/usr/bin/env ruby '.file.rdr
  elseif &filetype == 'tex'
    execute prefix.'latex '.file. '; [ $? -eq 0 ] && xdvi '. expand('%:r').rdr
  elseif &filetype == 'dot'
    let svg = expand('%:r') . '.svg'
    let png = expand('%:r') . '.png'
    " librsvg >> imagemagick + ghostscript
    execute 'silent !dot -Tsvg '.file.' -o '.svg.' && '
          \ 'rsvg-convert -z 2 '.svg.' > '.png.' && open '.png.rdr
  else
    return
  end
  redraw!
  if !a:output | return | endif

  " Scratch buffer
  if exists('s:vim_exec_buf') && bufexists(s:vim_exec_buf)
    execute bufwinnr(s:vim_exec_buf).'wincmd w'
    %d
  else
    silent!  bdelete [vim-exec-output]
    silent!  vertical botright split new
    silent!  file [vim-exec-output]
    setlocal buftype=nofile bufhidden=wipe noswapfile
    let      s:vim_exec_buf = winnr()
  endif
  execute 'silent! read' ofile
  normal! gg"_dd
  execute win.'wincmd w'
endfunction
nnoremap <silent> <F5> :call <SID>run_this_script(0)<cr>
nnoremap <silent> <F6> :call <SID>run_this_script(1)<cr>

" ----------------------------------------------------------------------------
" EX | chmod +x
" ----------------------------------------------------------------------------
command! EX if !empty(expand('%'))
         \|   write
         \|   call system('chmod +x '.expand('%'))
         \|   silent e
         \| else
         \|   echohl WarningMsg
         \|   echo 'Save the file first'
         \|   echohl None
         \| endif


" {{{ FUNCTIONS & COMMANDS


" ----------------------------------------------------------------------------
" AutoSave                                                                     
" ----------------------------------------------------------------------------
function! s:autosave(enable)                                                   
  augroup autosave
    autocmd!
    if a:enable
      autocmd TextChanged,InsertLeave <buffer>
            \  if empty(&buftype) && !empty(bufname(''))
            \|   silent! update
            \| endif
    endif
  augroup END
endfunction

command! -bang AutoSave call s:autosave(<bang>1)



" ===============================================
" VIM-Plug BLOCK {{{
" ===============================================
silent! if plug#begin('~/.vim/plugged')
" Plugin Manager

" Edit
Plug 'tpope/vim-repeat'        
Plug 'tpope/vim-surround'      
Plug 'tpope/vim-endwise'       
Plug 'tpope/vim-commentary'    
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
	"map <Leader>. <Plug>(easymotion-prefix)
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
    map  gc  <Plug>Commentary    
    nmap gcc <Plug>CommentaryLine
Plug 'mbbill/undotree'
    let g:undotree_WindowLayout = 2
    nnoremap U :UndotreeToggle<CR>
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    let g:UltiSnipsExpandTrigger="<leader><tab>"
    "source ~/.vim/vimrcs/plugins/ultisnips.vim
    let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
    let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
    let g:UltiSnipsSnippetsDirectories="~/.vim/bundle/vim-snippets/UltiSnips"
    "let g:UltiSnipsSnippetDirectories=["UltiSnips"]
  
" Edit Completion
Plug 'neoclide/coc.nvim', { 'branch': 'release'}

" Browsing
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  autocmd! User indentLine doautocmd indentLine Syntax
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#616161'

" File Manager
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END

" Tag Manager
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_sort = 0


" Git
Plug 'tpope/vim-fugitive'
  nmap     gst :Gstatus<CR>gg<c-n>
  nnoremap gdf :Gdiff<CR>
Plug 'tpope/vim-rhubarb'  " like hub
Plug 'airblade/vim-gitgutter'

Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = ['git']
  let g:signify_skip_filetype = { 'journal': 1 }
  let g:signify_sign_add          = '+'
  let g:signify_sign_change       = '~'
  let g:signify_sign_changedelete = '-'

" Lang Python
Plug 'davidhalter/jedi', { 'for': 'python'  } 
Plug 'davidhalter/jedi-vim', { 'for': ['python','vim']  }   "jump and completion
"Plug 'python-mode/python-mode' "lint completion
Plug 'heavenshell/vim-pydocstring', { 'for': 'python'  } 
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    let g:pydocstring_doq_path="$HOME/.local/bin/doq"
    let g:pydocstring_formatter = 'google'
Plug 'pixelneo/vim-python-docstring', { 'for' : 'python'  } 

" Lang Arm
Plug 'ARM9/arm-syntax-vim'
au BufNewFile,BufRead *.s,*.S,*.txt set filetype=arm " arm = armv6/7"

" Lang Cpp
Plug 'octol/vim-cpp-enhanced-highlight', { 'for' : 'cpp' }

" Lint
Plug 'dense-analysis/ale'
    "\   'python':     ['flake8', 'pylint','pycodestyle','pydocstyle','pyflakes','mypy'],
    let g:ale_linters = {
	\   'python': ['pylint'],
    \   '*':          ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['eslint'],
    \	'html':       ['prettier'],
    \   'c':          ['gcc','clang','ccls', 'clang', 'clangd', 'clangtidy', 'cppcheck', 'cquery', 'flawfinder', 'gcc'],
    \   'cpp':        ['gcc','clang','ccls', 'clang', 'clangd', 'clangtidy', 'cppcheck', 'cquery', 'flawfinder', 'gcc'],
    \}

    let g:ale_fixers = {
    \   'python':     ['yapf','autopep8','isort','add_blank_lines_for_python_control_statements','black','reorder-python-imports'],
    \   'ruby':       ['standardrb', 'rubocop'],
    \   'javascript': ['eslint'],
      \	'c':          ['pclint','clang-format','clangtidy','uncrustify'],
      \	'cpp':        ['clang-format','clangtidy','uncrustify'],
    \}
	let g:ale_keep_list_window_open          = 0
	"let g:ale_open_list						 = 1
	let g:ale_set_loclist                    = 1
	let g:ale_set_quickfix                   = 0
	let g:ale_set_signs                      = 1
	let g:ale_sign_column_always             = 0
	highlight clear ALEErrorSign
	highlight clear ALEWarningSign
	highlight ALEWarning ctermbg=DarkMagenta
	let g:ale_sign_error                     = '✖'
	let g:ale_sign_info                      = 'ⓘ'
	let g:ale_sign_offset                    = 1000000
	let g:ale_sign_style_error               = '✖'
	let g:ale_sign_style_warning             = '⚠'
	let g:ale_sign_warning                   = '⚠'
	let g:ale_lint_on_enter                  = 1
	let g:ale_lint_on_filetype_changed       = 1
	let g:ale_list_window_size               = 10
	"let g:ale_loclist_msg_format             = '%severity%:%s %linter%: %s'
	let g:ale_python_autoimport_executable   = "autoimport"
    let g:ale_lint_delay                     = 1000
	let g:ale_python_auto_pipenv             = 1
    let g:ale_python_pylint_auto_pipenv      = 1
	let g:ale_python_pylint_use_msg_id = 1
	let g:ale_python_pylint_executable       = 'pylint'
	"let g:ale_python_pylint_options          = "--init-hook='import sys; sys.path.append(\".\")'"
	"let g:ale_python_pylint_options          = "--rcfile $HOME/.pylintrc"
	let g:ale_python_pylint_use_global       = 1
	"fix import error
	let g:ale_python_pylint_change_directory = 0
    let g:ale_python_flake8_auto_pipenv      = 0
    let g:ale_python_flake8_change_directory = 0

    let g:ale_python_flake8_executable       = 'flake8'
    let g:ale_python_flake8_options          = '--max-line-length=120 --ignore=E265,E266,E501,W503'
	let g:ale_statusline_format              = ['✗ %d', '⚡ %d', '✔ OK']
    nmap <silent> [a <Plug>(ale_previous_wrap)
    nmap <silent> ]a <Plug>(ale_next_wrap)

Plug 'Yggdroot/LeaderF'
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
    let g:airline#extensions#tabline#show_splits = 1
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
  let g:gruvbox_contrast_dark = 'soft'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'sbdchd/neoformat'
Plug 'plasticboy/vim-markdown'

call plug#end()
endif
colorscheme molokai
silent! colo seoul256

" }}} VIM-PluginIN BLOCK


" ============================================================================
" PLUGINS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" LeaderF
" ----------------------------------------------------------------------------
"source ~/.vim/vimrcs/plugins/LeaderF.vim
"let g:Lf_TabpagePosition=2
"let g:Lf_WildIgnore = {
			"\ 'dir': ['.svn','.git','.hg'],
			"\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
			"\}
"" let g:Lf_Ctags = '/usr/local/bin/ctags'
"let g:Lf_CtagsFuncOpts = {
		"\ 'c': '--c-kinds=fp',
		"\ 'rust': '--rust-kinds=f',
		"\ }

"let g:Lf_MruFileExclude = ['*.so']
"let g:Lf_StlSeparator = { 'left': '►', 'right': '◄', 'font': '' }
"" popup mode
"let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
"let g:Lf_PreviewResult = {'Function': 1, 'BufTag': 0 }
"let g:Lf_ShortcutF = '<C-P>'
""quicker way to show
"autocmd FileType c,cpp 
"\noremap <leader>d :<C-U><C-R>=printf("Leaderf! gtags --definition %s ", expand("<cword>"))<CR>
"autocmd FileType c,cpp 
"\noremap <leader>r :<C-U><C-R>=printf("Leaderf! gtags --reference %s ", expand("<cword>"))<CR>
"autocmd FileType c,cpp 
"\noremap <leader>s :<C-U><C-R>=printf("Leaderf! gtags --symbol %s", expand("<cword>"))<CR>
"noremap <leader>f :Leaderf! rg -e 
"noremap <leader>w :LeaderfFunction!<CR>
"noremap <leader>b :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
"noremap <leader>m :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
"noremap <leader>t :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
"noremap <leader>l :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
"noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR><CR>
"noremap go :<C-U>Leaderf! rg --recall<CR>
"let g:Lf_GtagsAutoGenerate = 1
"let g:Lf_Gtagslabel = 'native-pygments'

" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowHeight=0.3
" popup mode
"let g:Lf_WindowPosition = 'popup'
"let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
let g:Lf_TabpagePosition=2
let g:Lf_WildIgnore = {
			\ 'dir': ['.svn','.git','.hg'],
			\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
			\}

let g:Lf_ShortcutF = '<C-P>'
noremap <leader>fs :<C-U><C-R>=printf("Leaderf! rg -F -e ")<CR>
noremap <leader>ff :LeaderfFunction!<CR>
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

noremap <C-M> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR><CR>
" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><CR>
noremap go :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

" ----------------------------------------------------------------------------
" python-mode
" ----------------------------------------------------------------------------
"python-mode setting from :h pymode
"let g:pymode = 1
"let g:pymode_warnings = 0
"let g:pymode_paths = []


" ----------------------------------------------------------------------------
" jedi-vim
" ----------------------------------------------------------------------------
"jedi-vim
"goto definition on new tab not buffer
"let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = "right"
nmap <buffer> <silent> <Leader>g :vs<CR> :call jedi#goto()<CR>
"autocmd FileType c nnoremap <buffer> 
let g:jedi#goto_command             = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command       = "<leader>s"
let g:jedi#rename_command           = "<leader>u"
let g:jedi#usages_command           = "<leader>r"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command    = "K"
let g:jedi#completions_command      = "<C-N>"
"disable jedi mapping with 0
"let g:jedi#auto_initialization=0



" ----------------------------------------------------------------------------
" coc.nvim
" ----------------------------------------------------------------------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
	  \ pumvisible() ? "\<C-n>" :
	  \ <SID>check_back_space() ? "\<TAB>" :
	  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
	execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
	call CocActionAsync('doHover')
  else
	execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
  "nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  "inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  "inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  "vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" }}}
" ============================================================================
" FZF {{{
" ============================================================================

"let $FZF_DEFAULT_OPTS .= ' --inline-info'

"" All files
"command! -nargs=? -complete=dir AF
  "\ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  "\   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  "\ })))


""if exists('$TMUX')
  ""let g:fzf_layout = { 'tmux': '-p90%,60%' }
""else
  ""let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
""endif

"" Terminal buffer options for fzf
"autocmd! FileType fzf
"autocmd  FileType fzf set noshowmode noruler nonu

"nnoremap <silent> <Leader><Leader> :Files<CR>
"nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
"" nnoremap <silent> <Leader>c        :Colors<CR>
"nnoremap <silent> <Leader><Enter>  :Buffers<CR>
"nnoremap <silent> <Leader>l        :Lines<CR>
"nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
"nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
"xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
"nnoremap <silent> <Leader>m        :Marks<CR>
"" nnoremap <silent> q: :History:<CR>
"" nnoremap <silent> q/ :History/<CR>

"inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)
