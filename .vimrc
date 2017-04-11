"Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится). 
set nocompatible

"Показывать положение курсора всё время. 
set ruler

"Показывать незавершённые команды в статусбаре 
set showcmd

"Не выгружать буфер, при переключении на другой (не требует сохраняться) 
set hidden

"Разное
set title
set autoread
set wildcharm=<C-Z>
set novisualbell
set t_vb= 

"Encoding
set termencoding=utf8
set fileencoding=utf8

"Окончание строки
set fileformat=unix

"Скрывать указатель мыши, когда печатаем 
set mousehide

"Indent
set autoindent
set smartindent

"Backup & swap
set backupdir=~/.vim/tmp,/tmp
set directory=~/.vim/tmp,/tmp

set history=1000

"Запоминать инфу об открытых файлах 
set viminfo+=h

"Двойные квадратная, круглая и фигурная скобки
imap [ []<LEFT>
imap ( ()<LEFT>
imap {<CR> {<CR>}<Esc>O

"Табуляция
"set expandtab "Преобразование Таба в пробелы
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab

"Подстветка найденных вариантов 
set hlsearch

"Игнотировать регистр 
set ignorecase

"Поиск по набору текста (очень полезная функция) 
set incsearch

"Не игнорировать регистр, при использовании символов разного регистра 
set smartcase

"Автозавершение по Tab
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <C-R>=InsertTabWrapper()<CR>

set complete="" " из буфера
set complete+=. " из словаря
set complete+=k " из разных буферов
set complete+=b " из тегов
set complete+=t " из открытых табов (наверное)

setlocal dictionary+=$HOME/.vim/dic/phpfunclist
setlocal dictionary+=$HOME/.vim/dic/phpproto

"CTRL-Space для omni completion
inoremap <C-Space> <C-X><C-O>

"Scroll
set scrolloff=0
set scrolljump=0
set sidescroll=0
set sidescrolloff=0

"Folding
let php_folding=1
set foldlevelstart=1
set foldmethod=syntax

"Set a nicer foldtext function
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let sub = sub . "                                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction

"Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertEnter * highlight StatusLine ctermbg=52
autocmd InsertLeave * highlight StatusLine ctermbg=236
autocmd InsertLeave * set nocursorline
autocmd CmdwinEnter * highlight StatusLine ctermbg=22
autocmd CmdwinLeave * highlight StatusLine ctermbg=236

"Languages
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1
set spelllang=en,ru
"set langmap=йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХ~ZФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;qwertyuiop[]asdfghjkl\;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>] "Работа в командном режиме в русской раскладке (не работает с UTF8)

"Status line & command line
set ch=1 "Сделать строку команд высотой в одну строку
set laststatus=2
set shortmess=tToOI
set showcmd
set statusline=%F\ %y%m%r[%{&fileencoding}]%<[%{strftime(\"%d.%m.%y\",getftime(expand(\"%:p\")))}]%k%=%-14.(%l,%c%V%)\ %P
set wildmenu

"View
set fillchars=vert:\ ,fold:\ 
set listchars+=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
set noequalalways
set nowrap
set number "Включаем нумерацию строк.
set showmatch
set winminheight=0
set winminwidth=0
set guifont=-xos4-terminus-medium-r-normal-*-*-140-*-*-c-*-iso10646-1

"Edit
set backspace=indent,eol,start whichwrap+=<,>,[,] "Использовать backspace вместо "x"
nnoremap :exe 'norm!' matchend(getline('.'),'^\s*') imap
set clipboard+=unnamed
"set virtualedit=all "Курсор может перемещаться там, где нет символов
set fo+=cr "Fix <Enter> for comment

"Syntax, etc.
syntax on "Влючить подстветку синтаксиса
filetype on
filetype plugin on
filetype indent on

"Interface colors
"http://vimdoc.sourceforge.net/htmldoc/syntax.html
"http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
set t_Co=256
highlight CursorColumn            			ctermbg=233
highlight CursorLine	cterm=none 			ctermbg=233
highlight Folded                  			ctermbg=234 	ctermfg=136
highlight LineNr                  			ctermbg=233 	ctermfg=238
highlight MatchParen              			ctermbg=240
highlight NonText                 			ctermbg=232 	ctermfg=235
highlight Pmenu                   			ctermbg=52
highlight StatusLine	cterm=none 			ctermbg=236
highlight StatusLineNC	cterm=none 			ctermbg=236 	ctermfg=243
highlight TabLine		cterm=none 			ctermbg=236 	ctermfg=145
highlight TabLineFill                   	ctermfg=236
highlight TabLineSel	cterm=none 			ctermbg=240 	ctermfg=253
highlight VertSplit                     	ctermfg=236
highlight Comment      	cterm=NONE 			ctermfg=238    	ctermbg=Black
highlight DiffAdd       ctermfg=10			ctermbg=24 
highlight DiffChange    ctermfg=Gray		ctermbg=Brown 
highlight DiffDelete    ctermfg=125			ctermbg=125
highlight DiffText      ctermfg=18			ctermbg=22
highlight FoldColumn   	ctermfg=136 		ctermbg=233		term=standout
highlight Visual 		ctermfg=DarkGray	ctermbg=Gray

"Отключение FoldColumn в режиме vimdiff
au FilterWritePre * if &diff | set fdc=0 | endif

"Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
    set t_Co=256
    nmap <Esc>OH <Home>
    imap <Esc>OH <Home>
    nmap <Esc>OF <End>
    imap <Esc>OF <End>
endif

"Сохранение файла без прав на запись в vim используя sudo. Для сохранения используется команда :Wsudo,или просто :W, если к W больше ничего не привязано
command Wsudo set buftype=nowrite | silent execute ':%w !sudo tee %' | set buftype= | e! %

"Умные Home/End
nmap <Home> :call HomeButton()<CR>
imap <Home> <C-O>:call HomeButton()<CR>
nmap <End> :call EndButton()<CR>

function HomeButton()
    if col(".") != 1
        let current_cursor_column = col(".")
        execute("normal ^")
        if col(".") == current_cursor_column
            execute("normal 0")
        endif
    endif
endfunction
 
function EndButton()
    execute("normal $")
    if col("$") != 1
        execute("normal l")
    endif
endfunction

":set list!
":set hlsearch!
":edit ++enc=utf-8<CR>
":edit ++enc=cp1251<CR>
":edit ++enc=iso-8859-1<CR> "Latin-1
":set fileformat=unix<CR>
":set fileformat=dos<CR>
":set filetype=php<CR>
":w ++ff=unix "конвертировать файл в unix-style.
