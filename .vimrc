filetype indent plugin on
" set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
set rtp+=~/.vim/bundle/Vundle.vim

" install plug
call vundle#begin()
"python
Plugin 'davidhalter/jedi'
Plugin 'davidhalter/jedi-vim'
"tmux
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'roxma/vim-tmux-clipboard'
"completion
Plugin 'Shougo/deoplete'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
"arm
Plugin 'ARM9/arm-syntax-vim'
"mark jump
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'inkarkat/vim-mark'
Plugin 'inkarkat/vim-ingo-library'
"align and move and comment
Plugin 'junegunn/vim-easy-align'
Plugin 'easymotion/vim-easymotion'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Yggdroot/indentLine'
Plugin 'jiangmiao/auto-pairs'
"plugin management
Plugin 'VundleVim/Vundle.vim'
"fast code
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"code check
Plugin 'dense-analysis/ale'
"fast find and jump
Plugin 'Yggdroot/LeaderF'
Plugin 'junegunn/fzf'
"git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
"markdown
Plugin 'plasticboy/vim-markdown'
"Plugin 'tchapi/markdown-cheatsheet' 
"show
Plugin 'vim-airline/vim-airline'
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'mg979/vim-visual-multi', {'branch': 'master'}
Plugin 'soywod/kronos.vim'
"weather
"Plugin 'Wildog/airline-weather.vim'
"Plugin 'mattn/webapi-vim'
"
""Plugin 'ludovicchabant/vim-gutentags'
"Plugin 'roxma/nvim-yarp'
"Plugin 'roxma/vim-hug-neovim-rpc'
"Plugin 'justinmk/vim-sneak'
"Plugin 'vimoutliner/vimoutliner'
"Plugin 'sbdchd/neoformat'
"Plugin 'Valloric/YouCompleteMe'
"completion plugin
"Plugin 'Shougo/deoplete.nvim'
"Plugin 'dhruvasagar/vim-table-mode'
"Plugin 'godlygeek/tabular'
"vim-visual-multi instead of vim-multiple-cursors 
"Plugin 'terryma/vim-multiple-cursors'
"Plugin 'mattn/vim-gist'
"Plugin 'preservim/nerdtree'
"Plugin 'octol/vim-cpp-enhanced-highlight'
"Plugin 'majutsushi/tagbar'
"Plugin 'mhinz/vim-signify'
"Plugin 'python-mode/python-mode'
call vundle#end()            " required

"PART 1: basic setting 
let mapleader=","

syntax enable on
"set setting 
"disable auto comment insertion
"set column highligth
"set cursorcolumn
"set line highligth
"set cursorline
set formatoptions-=cro
set incsearch
set ignorecase
set hlsearch
set wildmenu
set wildignore=*.o,*~,*.pyc
"replace tab with space only in c and cpp 
autocmd FileType c,cpp set shiftwidth=4 | set expandtab
"set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set foldmethod=indent
set foldmethod=syntax
set nofoldenable
set noswapfile 
set relativenumber number
set number
"set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode 
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
"colorscheme atom
"colorscheme zellner
colorscheme OceanicNext
highlight VertSplit guifg=#444444 guibg=#1c1c1c gui=NONE ctermfg=238 ctermbg=234 cterm=NONE
"colorscheme jellybeans
"colorscheme dracula
highlight clear SignColumn
"PART 2: basic map setting 
"Insert Mode Setting
inoremap jj <Esc>
"Normal Mode Setting 
nnoremap ; :
nnoremap m *N
nnoremap M :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap t :q<CR>
nnoremap <C-@> :w<CR>
"nmap <NUL> :wq
"Normal Mode --Ctrl Setting 
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <C-]> <C-W>]
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
xnoremap < <gv
xnoremap > >gv

"
"nnoremap f     <C-B>
"nnoremap z     <C-F>
"cursor shape changes between insert and normal mode
"if has("autocmd")
  "au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  "au InsertEnter,InsertChange *
    "\ if v:insertmode == 'i' | 
    "\   silent execute '!echo -ne "\e[6 q"' | redraw! |
    "\ elseif v:insertmode == 'r' |
    "\   silent execute '!echo -ne "\e[4 q"' | redraw! |
    "\ elseif v:insertmode == 'v' |
    "\   silent execute '!echo -ne "\e[2 q"' | redraw! |
    "\ endif
  "au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
"endif
"tips
"
"nnoremap <C-M> ggVGg?
":%!xxd  turn file to 16
":%!xxd -r return back 
"Visual Mode Setting 
xnoremap ; :
xnoremap v <C-V>
iab xdt <c-r>=strftime("        %F %A")
vnoremap // y/<c-r>"<cr>"
"Command Mode Setting 
cmap ww w !sudo tee % > /dev/null

"Visual mode and Select mode 

"PART 3: plug config 

"arm-syntax-vim
"au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7"
au BufNewFile,BufRead *.s,*.S,*.txt set filetype=arm " arm = armv6/7"
"airline-vim
let g:airline#extensions#tabline#fnamemod = ':t'

"source ~/.vim/vimrcs/plugins/ultisnips.vim
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
let g:UltiSnipsSnippetsDirectories="~/.vim/bundle/vim-snippets/UltiSnips"
"let g:UltiSnipsSnippetDirectories=["UltiSnips"]

"source ~/.vim/vimrcs/plugins/youcompletme.vim
highlight Pmenu ctermfg=2 ctermbg=3 guifg=#005f87 guibg=#EEE8D5
highlight PmenuSel ctermfg=2 ctermbg=3 guifg=#AFD700 guibg=#106900
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_complete_in_comments=0
let g:ycm_confirm_extra_conf=0
let g:ycm_collect_identifiers_from_tags_files=1
"set tags+=/data/misc/software/misc./vim/stdcpp.tags
set completeopt-=preview
let g:ycm_min_num_of_chars_for_completion=9
let g:ycm_cache_omnifunc=1
let g:ycm_seed_identifiers_with_syntax=1

"source ~/.vim/vimrcs/plugins/LeaderF.vim
" don't show the help in normal mode
let g:Lf_HideHelp = 0
let g:Lf_PreviewCode = 1
let g:Lf_UseCache = 1
let g:Lf_UseVersionControlTool = 1
let g:Lf_IgnoreCurrentBufferName = 0
let g:Lf_WindowPosition = 'bottom'
let g:Lf_WindowHeight = 0.35
let g:Lf_CursorBlink = 0
let g:Lf_PreviewResult = {
        \ 'File': 1,
        \ 'Buffer': 1,
        \ 'Mru': 1,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 1,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \}
let g:Lf_HistoryExclude = {
        \ 'cmd': ['^w!?', '^q!?', '^.\s*$'],
        \ 'search': ['^Plug']
        \}
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}
"vim version influence
let g:Lf_JumpToExistingWindow = 0
"ctags installed path
let g:Lf_Ctags = "/usr/local/bin/ctags"
let g:Lf_CtagsFuncOpts = {
        \ 'c': '--c-kinds=fp',
        \ 'rust': '--rust-kinds=f',
        \ }

let g:Lf_MruFileExclude = ['*.so']
let g:Lf_StlSeparator = { 'left': '►', 'right': '◄', 'font': '' }
" popup mode
"let g:Lf_WindowPosition = 'popup'
"let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 1, 'BufTag': 0 }
let g:Lf_ShortcutF = '<C-P>'
"quicker way to show
noremap <leader>f :Leaderf! rg -e 
"noremap <leader>j <Plug>LeaderfRgVisualLiteralNoBoundary 
xnoremap <leader>j :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
"noremap <leader><leader>f :Leaderf function --bottom <CR>
noremap <leader>w :LeaderfFunction!<CR>
noremap <leader>g :<C-U><C-R>=printf("Leaderf! rg %s", expand("<cword>"))<CR><CR>
noremap <leader>b :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>m :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>t :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>l :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
"noremap <leader>jr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>s :<C-U><C-R>=printf("Leaderf! gtags --symbol %s", expand("<cword>"))<CR>
"noremap <leader>jd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>r :<C-U><C-R>=printf("Leaderf! gtags --reference %s ", expand("<cword>"))<CR>
noremap <leader>d :<C-U><C-R>=printf("Leaderf! gtags --definition %s ", expand("<cword>"))<CR>
noremap <leader>o :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>ln :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>lp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
" search visually selected text literally
noremap go :<C-U>Leaderf! rg --recall<CR>
"noremap <C-M> :<C-U><C-R>=printf("LeaderfFunction! %s",expand("<cword>"))<CR>
"noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR><CR>
" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
"python-mode setting from :h pymode
"1. common setting
let g:pymode = 0
let g:pymode_warnings = 1
let g:pymode_trim_whitespaces = 1
"let g:pymode_options = 1
let g:pymode_options_colorcolumn = 0
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 8
let g:pymode_preview_height = &previewheight
let g:pymode_preview_position = 'botright'
"2.1 python version
let g:pymode_python = 'python3'
"2.2 python intdent
let g:pymode_indent = 0
"2.3 python folding :enabel fold
let g:pymode_folding = 0
"2.4 python motion like vim
let g:pymode_motion = 1
"2.5 use 'K' 
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
"2.6 
"let g:pymode_virtualenv = 1
"2.7 run select python in buffer
let g:pymode_run = 1
let g:pymode_run_bind = '<Leader>pr'
"2.8 breadpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>pb'
"3 code checking 
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_on_fly = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
"error check
"not open quickfix window if error happens
let g:pymode_lint_cwindow = 1
let g:pymode_lint_sort = ['E','C','I']
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'
"???3.repo
let g:pymode_rope = 1
let g:pymode_rope_lookup_project = 0
"光标下单词查阅文档
let g:pymode_rope_show_doc_bind = '<Leader>pd'
""项目修改后重新生成缓存
let g:pymode_rope_regenerate_on_write = 1
"4.1 Completion 
"let g:pymode_rope_completion = 1
"let g:pymode_rope_complete_on_dot = 1
"let g:pymode_rope_completion_bind = '<C-Tab>'
"4.2 find definition
let g:pymode_rope_goto_definition_bind = '<leader>pg'
let g:pymode_rope_goto_definition_cmd = 'vnew'
"重命名光标下的函数，方法，变量及类名
"let g:pymode_rope_rename_bind = '<C-c>rr'
""重命名光标下的模块或包
let g:pymode_rope_rename_module_bind = '<C-c>r1r'

""vim-easy-motion.vim
""vim-easyalign.vim
""gutentags
"" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
"let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

"" 所生成的数据文件的名称
"let g:gutentags_ctags_tagfile = '.tags'

"" 同时开启 ctags 和 gtags 支持：
"let g:gutentags_modules = []
"if executable('ctags')
	"let g:gutentags_modules += ['ctags']
"endif
"if executable('gtags-cscope') && executable('gtags')
	"let g:gutentags_modules += ['gtags_cscope']
"endif

"" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
"let g:gutentags_cache_dir = expand('~/.cache/tags')

"" 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
"let g:gutentags_ctags_executable = '/usr/local/bin/ctags'
"let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
""let g:gutentags_ctags_extra_args = ['--fields=+niazS']
"let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
"let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"" 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
""let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

"" 禁用 gutentags 自动加载 gtags 数据库的行为
"let g:gutentags_auto_add_gtags_cscope = 0
""let g:gutentags_ctags_executable = '/snap/bin/ctags'
"let g:gutentags_define_advanced_commands = 1
""let g:gutentags_trace = 1


"vim-table-mode
function! s:isAtStartOfLine(mapping)
    let text_before_cursor = getline('.')[0 : col('.')-1]
    let mapping_pattern = '\V' . escape(a:mapping, '\')
    let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
    return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
            \ <SID>isAtStartOfLine('\|\|') ?
            \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
            \ <SID>isAtStartOfLine('__') ?
            \ '<c-o>:silent! TableModeDisable<cr>' : '__'
"""
  "Common Usage
"""


"leetcode.vim
"let g:leetcode_browser = 'firefox'
"let g:leetcode_china = 1
"let g:leetcode_solution_filetype = 'cpp'
"nnoremap <leader>ll :LeetCodeList<cr>
"nnoremap <leader>lt :LeetCodeTest<cr>
"nnoremap <leader>ls :LeetCodeSubmit<cr>
"nnoremap <leader>li :LeetCodeSignIn<cr>

"vim-bookmarks
"nmap <Leader><Leader> <Plug>BookmarkToggle
"nmap <Leader>i <Plug>BookmarkAnnotate
"nmap <Leader>a <Plug>BookmarkShowAll
"nmap <Leader>j <Plug>BookmarkNext
"nmap <Leader>k <Plug>BookmarkPrev
"nmap <Leader>c <Plug>BookmarkClear
"nmap <Leader>x <Plug>BookmarkClearAll
"nmap <Leader>kk <Plug>BookmarkMoveUp
"nmap <Leader>jj <Plug>BookmarkMoveDown
"nmap <Leader>g <Plug>BookmarkMoveToLine
"let g:bookmark_no_default_key_mappings = 1
"highlight BookmarkSign ctermbg=whatever ctermfg=whatever
"highlight BookmarkAnnotationSign ctermbg=whatever ctermfg=whatever
"highlight BookmarkLine ctermbg=whatever ctermfg=whatever
"highlight BookmarkAnnotationLine ctermbg=whatever ctermfg=whatever
"let g:bookmark_save_per_working_dir = 1
"let g:bookmark_auto_save = 1
"" Finds the Git super-project directory.
"function! g:BMWorkDirFileLocation()
    "let filename = 'bookmarks'
    "let location = ''
    "if isdirectory('.git')
        "" Current work dir is git's work tree
        "let location = getcwd().'/.git'
    "else
        "" Look upwards (at parents) for a directory named '.git'
        "let location = finddir('.git', '.;')
    "endif
    "if len(location) > 0
        "return location.'/'.filename
    "else
        "return getcwd().'/.'.filename
    "endif
"endfunction
let g:bookmark_no_default_key_mappings = 1
function! BookmarkMapKeys()
    nmap mm :BookmarkToggle<CR>
    nmap mi :BookmarkAnnotate<CR>
    nmap mn :BookmarkNext<CR>
    nmap mp :BookmarkPrev<CR>
    nmap ma :BookmarkShowAll<CR>:BookmarkShowAll<CR>
    nmap mc :BookmarkClear<CR>
    nmap mx :BookmarkClearAll<CR>
    nmap mkk :BookmarkMoveUp
    nmap mjj :BookmarkMoveDown
endfunction
function! BookmarkUnmapKeys()
    unmap mm
    unmap mi
    unmap mn
    unmap mp
    unmap ma
    unmap mc
    unmap mx
    unmap mkk
    unmap mjj
endfunction
autocmd BufEnter * :call BookmarkMapKeys()
autocmd BufEnter NERD_tree_* :call BookmarkUnmapKeys()


" ale
"let g:ale_fixers['html'] = ['prettier'] 
"prettier need install by npm: npm install --save-dev --save-exact prettier
let g:ale_fixers = {
\   'python': ['yapf'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\	'html'		: ['prettier']
\}
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'ruby': ['standardrb', 'rubocop'],
\   'javascript': ['eslint'],
\}
"let g:ale_linters_explicit = 1
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:airline#extensions#ale#enabled = 1
" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0

"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

"let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
"let g:ale_keep_list_window_open = 1
let g:ale_c_parMe_makefile=1
"nmap <silent> <A-k> <Plug>(ale_previous_wrap)
"nmap <silent> <A-j> <Plug>(ale_next_wrap)
""""""deoplete.vim
let g:deoplete#enable_at_startup = 1

"function! LinterStatus() abort
  "let l:counts = ale#statusline#Count(bufnr(''))

  "let l:all_errors = l:counts.error + l:counts.style_error
  "let l:all_non_errors = l:counts.total - l:all_errors

  "return l:counts.total == 0 ? '✨ all good ✨' : printf(
        "\   '😞 %dW %dE',
        "\   all_non_errors,
        "\   all_errors
        "\)
"endfunction

"set statusline=
"set statusline+=%m
"set statusline+=\ %f
"set statusline+=%=
"set statusline+=\ %{LinterStatus()}

"vim-fugitive
nnoremap <Space> :Gblame<CR>

"jedi-vim
"goto definition on new tab not buffer
let g:jedi#use_tabs_not_buffers = 1
"let g:jedi#use_splits_not_buffers = "left"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-m>"
let g:jedi#rename_command = "<leader>u"


"weather plugin setting,has HARD BUG!!!! so must be disable
"let g:weather#area = 'shenzhen,china'
"let g:weather#unit = 'metric'
"let g:weather#appid = '24a6838bc30c6fad3e268a8736ddc82b'
"let g:weather#cache_file = '~/.cache/.weather'
"let g:weather#cache_ttl = '1800'


let g:kronos_backend = '~/.vim/bundle/kronos.vim/.database' "| 'taskwarrior'
nmap <cr>   <plug>(kronos-toggle)
nmap K      <plug>(kronos-info)
nmap gc     <plug>(kronos-context)
nmap gs     <plug>(kronos-sort-asc)
nmap gS     <plug>(kronos-sort-desc)
nmap gh     <plug>(kronos-hide-done)
nmap gw     <plug>(kronos-worktime)
"nmap <c-n>  <plug>(kronos-next-cell)
"nmap <c-p>  <plug>(kronos-prev-cell)
nmap dic    <plug>(kronos-delete-in-cell)
nmap cic    <plug>(kronos-change-in-cell)
nmap vic    <plug>(kronos-visual-in-cell)

" ============================================================================
" FZF {{{
" ============================================================================

let $FZF_DEFAULT_OPTS .= ' --inline-info'

" All files
command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  \ })))

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

"if exists('$TMUX')
  "let g:fzf_layout = { 'tmux': '-p90%,60%' }
"else
  "let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
"endif

"nnoremap <silent> <Leader><Leader> :Files<CR>
noremap <leader>q :FZF<CR>
