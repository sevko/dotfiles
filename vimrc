" =============== default ===============  

	" This line should not be removed as it ensures that various options are
	" properly set to work with the Vim-related packages available in Debian.
	runtime! debian.vim

	call pathogen#incubate()
	call pathogen#helptags()

	if has("syntax")
	  syntax on
	endif

	if filereadable("/etc/vim/vimrc.local")
	  source /etc/vim/vimrc.local
	endif

	" jump to the last position when reopening a file
	if has("autocmd")
	  au bufreadpost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	endif

	if &term =~ '^screen'
		execute "set <S-Up>=\e[1;2A"
		execute "set <S-Down>=\e[1;2B"
		execute "set <S-Right>=\e[1;2C"
		execute "set <S-Left>=\e[1;2D" 
	endif

" =============== Settings ===============	

	filetype indent on
	filetype plugin on

	set showcmd
	set autowrite

	" file backup
		" backup to ~/.tmp; get rid of .swp files
		set backup 
		set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
		set backupskip=/tmp/*,/private/tmp/* 
		set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
		set writebackup

	set number
	set nowrap
	set linebreak 

	set timeoutlen=300
	set scrolloff=25 sidescrolloff=40
	set noshowmatch
	set wildmenu wildmode=longest,list,full
	set backspace=indent,eol,start	" allow deletion of tab-spaces

	" indentation
		set autoindent
		set noexpandtab tabstop=4 shiftwidth=4

	" code folding settings
		set foldmethod=indent	
		set foldnestmax=10 
		set nofoldenable foldlevel=1 

	set splitbelow splitright

	set laststatus=2
	set incsearch
	set nocursorline
	set t_Co=256

	set list
	set list lcs=tab:\·\  

	" colorscheme
		syntax enable
		set background=dark
		colorscheme solarized
	
	" lightline
	let g:lightline = {
		\ "colorscheme": "solarized",
		\ "component": {
		\	'readonly': '%{&readonly?"":""}',
		\ },
		\ "active": {
		\	"left": [ [ "mode" ], ["fugitive", "filename"] ],
		\	"right": [ [ "lineinfo" ], [ "percent" ], [ "fileformat" ] ]
		\}
	\}

	" NERDTree
		" key-maps
		let NERDTreeMapOpenSplit="s"
		let NERDTreeMapOpenVSplit="v"

		let NERDTreeMapActivateNode="h"
		let NERDTreeMapToggleHidden="<c-h>"

		let NERDTreeMapJumpFirstChild="<leader>k"
		let NERDTreeMapJumpLastChild="<leader>j"

		let NERDTreeWinSize=26
	
	" smart pasting
		let &t_SI .= "\<Esc>[?2004h"
		let &t_EI .= "\<Esc>[?2004l"

	" tmux/vim pane navigation"
		let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
		let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
		let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

" =============== Highlightinng =============== 

	hi CursorLineNR ctermfg=red ctermbg=0
	hi Folded ctermbg=2 ctermfg=black
	hi StatusLine cterm=none ctermfg=245 ctermbg=235
	hi WildMenu cterm=none ctermfg=232 ctermbg=2
	hi SpecialKey cterm=none ctermfg=DarkGrey ctermbg=none
	hi NonText ctermfg=red 
	hi VertSplit ctermfg=black ctermbg=2
	hi StatusLineNC cterm=none ctermfg=black ctermbg=2

	" autocomplete menu
		hi Pmenu cterm=none ctermbg=2 ctermfg=233
		hi PmenuSel ctermbg=233 ctermfg=red
		hi PmenuSbar cterm=none ctermbg=black
		hi PmenuThumb cterm=none ctermbg=red

	" tab-bar
		hi TabLine ctermbg=green ctermfg=black
		hi TabLineSel ctermbg=none ctermfg=red

" =============== AutoCommands =============== 

	augroup window
		autocmd!
		autocmd WinEnter	*	call NERDTreeQuit()
	augroup END

	augroup new_buffer
		autocmd!
		autocmd bufnewfile			*.java	:0r ~/.vim/templates/java.txt 
							\| exe "normal gg2e2li" . expand("%:t:r") 
							\. " \<Esc> 2ji" .  expand("%:t:r") 
							\. "() \<Esc>oa\<BS>\<tab>"

		autocmd bufnewfile		*.html	:0r~/.vim/templates/html.txt | exe "normal 4j"
		autocmd bufnewfile		*.c		:0r ~/.vim/templates/c.txt

		autocmd bufnewfile		*		exe "normal Gddk"
		autocmd bufnewfile		*		startinsert

		autocmd BufRead,BufNewFile	*		syn match parens /[()\[\]{}]/ | hi parens ctermfg=green 
		autocmd BufRead,BufNewFile	*		hi MatchParen ctermfg=DarkRed ctermbg=none
	augroup END

	augroup file_specific
		autocmd!
		autocmd BufRead   ~/.vimrc  	exe "normal! zM"
		autocmd BufWrite  ~/.vimrc  	source ~/.vimrc
		autocmd BufWrite  ~/.bashrc 	!source ~/.bashrc
		autocmd BufWritePost  ~/.zshrc      !source ~/.zshrc
	augroup END

	augroup universal
		autocmd FileType  *	call <SID>def_base_syntax()
		"au BufWritePre   *	:set binary | set noeol
		"au BufWritePost  *	:set nobinary | set eol
	augroup END

	augroup filetype_vim
		autocmd!
		autocmd FileType vim    inoremap  <buffer>  func    	func!<space><cr>endfunc<Esc><Up>$a
		autocmd FileType vim    inoremap  <buffer>  if      	if<cr>endif<Esc>k$a<space>
		autocmd FileType vim    inoremap  <buffer>  while   	while<cr>endwhile<Esc>k$a<space>
		autocmd FileType vim    inoremap  <buffer>  augroup 	augroup<cr>autocmd!<cr>augroup END<Esc>2k$a<space>
	augroup END

	augroup filetype_sh
		autocmd!
		autocmd FileType sh     inoremap	<buffer>  if        if<cr>then<cr>fi<Esc>2k$a<space>
		autocmd FileType sh     inoremap	<buffer>  for       for<cr>do<cr>done<Esc>2k$a<space>
		autocmd FileType sh     inoremap	<buffer>  while     while<cr>do<cr>done<Esc>2k$a<space>
	augroup END

	augroup filetype_html
		autocmd!
		autocmd FileType html,htmldjango	inoremap <buffer>	<	<><Left>
		autocmd FileType html,htmldjango	inoremap <buffer>	%	%<Space><Space>%<Left><Left>
		autocmd FileType html,htmldjango	inoremap <buffer>	%%	%
	augroup END

	augroup filetype_java 
		autocmd!
		autocmd FileType java	inoremap <buffer>	psvm 	public static void main(String[] args){<cr>}<Esc>O
		autocmd FileType java	inoremap <buffer>	if   	if()<Left>
		autocmd FileType java	inoremap <buffer>	for  	for(;;)<Left><Left><Left>
		autocmd FileType java	inoremap <buffer>	while	while()<Left>
	augroup END

	augroup filetype_c
		autocmd!
		autocmd FileType c	inoremap <buffer>	if   	if()<Left>
		autocmd FileType c	inoremap <buffer>	for  	for(;;)<Left><Left><Left>
		autocmd FileType c	inoremap <buffer>	while	while()<Left>
	augroup END

	augroup filetype_text
		autocmd!
		autocmd Filetype gitcommit	setlocal spell textwidth=72
		autocmd Filetype markdown 	setlocal spell textwidth=72
	augroup END

	augroup filetype_sh
		autocmd!
		autocmd FileType sh 	inoremap <buffer> 	if 	if<space>[  ]<cr>then<cr>fi<Esc>2<Up>4<Right>i
	augroup END

	augroup relativeLnNum	
		autocmd! 
		autocmd InsertEnter 	*	:set number	
		autocmd InsertLeave 	*	:set relativenumber
		autocmd FocusLost   	*	:set number
		autocmd FocusGained 	*	:set relativenumber
	augroup END

" =============== Key Mappings =============== 

	let mapleader = " "
 
	" =============== GLOBAL ===============  
		
		noremap 	<F1>     	:NERDTreeToggle<cr>

		map 		<leader>c   	<plug>NERDCommenterToggle
		map 		<leader>cz		<plug>NerdComComment

	" =============== Normal ===============   

		noremap 	<leader>ev	:vsplit $MYVIMRC<cr>
		nnoremap	<leader>w	<esc>:w<cr> 
		nnoremap	<leader>q	<esc>:q<cr>
		nnoremap	<leader>wq	<esc>:wq<cr>
		nnoremap	<leader>fq	<esc>:q!<cr>
		nnoremap	<leader>wa	<esc>:wa<cr>

		" Faster navigation
		nnoremap	H   		b
		nnoremap	L   		w
		nnoremap	J   		4j
		nnoremap	K   		4k
		nnoremap	<leader>l	$
		nnoremap	<leader>h	^
		nnoremap	<leader>j	G
		nnoremap	<leader>k	gg

		nnoremap	<leader>n	:call NumberToggle()<cr>
		nnoremap	<Tab>		.
		nnoremap	=    		=<cr>
		nnoremap	f    		za
		nnoremap	F    		zi
		nnoremap	<leader>t	:tabnext<CR>

		nnoremap	<leader>r	:wincmd r<CR>

		nnoremap	<c-a>		ggvG$
		nnoremap	b   		<c-v>
		nnoremap	rt  		:retab!<cr>
		nnoremap	tt  		:tabf 
		nmap		gs  		ysiw

		" tmux/vim pane navigation
		if exists('$TMUX')
			nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
			nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
			nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
			nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
		else
			map <C-h> <C-w>h
			map <C-j> <C-w>j
			map <C-k> <C-w>k
			map <C-l> <C-w>l
		endif

	" =============== Operator-Pending =============== 

		" Faster navigation
		onoremap	H   		b
		onoremap	L   		w
		onoremap	J   		4j
		onoremap	K   		4k
		onoremap	<leader>l	$
		onoremap	<leader>h	^
		onoremap	<leader>j	G
		onoremap	<leader>k	gg
	
	" =============== Insert ===============  

		inoremap	<special><expr>		<Esc>[200~ SmartPaste()
		inoremap	<c-u>   	<esc>lwbveUe 
		inoremap	<expr> j	((pumvisible())?("\<C-n>"):("j"))	"Scroll down auto-complete menu w/ j
		inoremap	<expr> k	((pumvisible())?("\<C-p>"):("k"))	"Scroll up auto-complete menu w/ k
		inoremap	<Tab>   	<C-R>=Tab_Or_Complete()<CR>
		inoremap	jk      	<esc>
		inoremap	"   		""<Left>
		inoremap	'   		''<Left>
		inoremap    ""          "
		inoremap    ''          '
		inoremap	(   		()<Left>
		inoremap	((  		()
		inoremap	[   		[]<Left>
		inoremap	{{  		{}<Left>
		inoremap	{   		{<CR>}<Esc>O

		inoremap	<up>    	<esc>:call ResizeUp()<cr>
		inoremap	<down>  	<esc>:call ResizeDown()<cr>
		inoremap	<left>  	<esc>:call ResizeLeft()<cr>
		inoremap	<right> 	<esc>:call ResizeRight()<cr>

		imap		<S-up>   	<up><up>
		imap		<S-down> 	<down><down>
		imap		<S-left> 	<left><left>
		imap		<S-right>	<right><right>
	
		imap		<c-c>    	<plug>NERDCommenterInsert

	" =============== Visual ===============  

		vnoremap jk				<esc>	

		" Faster navigation"
		vnoremap	<leader>l	$
		vnoremap	<leader>h	0
		vnoremap	<leader>j	G
		vnoremap	<leader>k	gg
		vnoremap	H   		b
		vnoremap	L   		w
		vnoremap	J   		4j
		vnoremap	K   		4k

		vnoremap	<tab>		>gv 	"Indent blocks of text
		vnoremap	<s-tab>		<Left><gv	"De-indent blocks of text
		vnoremap	"			:<bs><bs><bs><bs><bs>call BlockEnquote()<cr>
		vnoremap	<c-c>		"+y

" =============== Functions =============== 

	" toggles between relative-ln and real-ln
	function! NumberToggle()
		if(&relativenumber == 1)
			set nornu
		else
			set rnu
		endif
	endfunc		

	"tab-key completion
	function! Tab_Or_Complete()
		let curX = col('.')
		if curX>1 && strpart( getline('.'), curX-2, 3 ) =~ '^\w'
			return "\<C-N>"
		else
			return SmartTab(curX)
		endif
	endfunc

	func! SmartTab(colPos)
		if getline('.')[:a:colPos - 2] =~ "^[\t]*$" || a:colPos == 1
			return "\<Tab>"
		else
			return repeat(" ", &tabstop - 1)
		endif
	endfunc

	"automatically enter paste mode when pasting (from system clipboard) in insert mode
	function! SmartPaste()
		set pastetoggle=<Esc>[201~
		set paste
		return ""
	endfunction

	"common operator highlighting
	function! s:def_base_syntax()
		let currExt = expand("%:e")

		"the following filetypes will be ignored
		let badFiletypes = ["html"]
		let toHighlight = 1

		for fileExt in badFiletypes
			if fileExt == currExt
				let toHighlight = 0
				break
			endif
		endfor

		if toHighlight
			syntax match commonOperator "+\|\~\|\.\|,\|=\|%\|>\|<\|!\|&\||\|-\|\^\|\*"
			hi commonOperator ctermfg = red
			hi baseDelimiter ctermfg = DarkGrey
		endif 
	endfunction

	function! NERDTreeQuit()
		redir => buffersoutput
		silent buffers
		redir END
		let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
		let windowfound = 0

		for bline in split(buffersoutput, "\n")
			let m = matchlist(bline, pattern)

			if (len(m) > 0)
				if (m[2] =~ '..a..')
					let windowfound = 1
				endif
			endif
		endfor

		if (!windowfound)
			quitall
		endif
	endfunction

	function! TmuxOrSplitSwitch(wincmd, tmuxdir)
		let previous_winnr = winnr()
		silent! execute "wincmd " . a:wincmd
		if previous_winnr == winnr()
			call system("tmux select-pane -" . a:tmuxdir)
		redraw!
		endif
	endfunction