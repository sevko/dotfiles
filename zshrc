alias tmux="TERM=screen-256color-bce tmux"
if [ "$(ps -al | grep tmux )" = "" ]
	then tmux attach || tmux new
fi

# vars
DOT=$HOME/.dotfiles/zsh/
ZSH=$DOT/plugins/oh-my-zsh
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HISTFILE=~/.histfile
HISTSIZE=9000
SAVEHIST=9000
PATH=$PATH:~/.dotfiles/scripts:~/bin/:~/.local/bin
PATH=$PATH:~/bin/pyprocessing:~/bin/elasticsearch-1.5.1/bin:~/.cabal/bin:~/.rvm/bin
KEYTIMEOUT=1
EDITOR=vim
TMPDIR=/tmp
PAGER=less
LESS=-RScI

# settings
setopt extendedglob
setopt GLOB_COMPLETE
setopt NO_HUP
setopt NO_CHECK_JOBS
setopt braceccl
setopt autocd
setopt ksh_glob
setopt extendedglob
setopt prompt_subst
setopt inc_append_history

eval $(dircolors $DOT/dircolors)

# completion
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U vcs_info && vcs_info

zmodload zsh/complist
zmodload zsh/terminfo
zmodload zsh/zle

zstyle ":completion:*" menu select verbose,auto-description
zstyle ":completion:*:processes-names" command "ps -e -o comm="
zstyle ":completion:*:*:vim:*" ignored-patterns \
	"*.(o|pyc|jpg|png|jpeg|bz2|deb|zip|gz|gpx|jar|xz|pdf|png|gif|pbf|dbf|sh[px]|prj|cpg|hi)"
zstyle ":completion:*:*:pylint:*" file-patterns "*.py *(-/)"
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename '/home/sevko/.zshrc'

plugins=(last-working-dir fzf)
mkdir -p $ZSH/cache/    # For last-working-dir plugin.

if [ -d $ZSH ]; then
	source $ZSH/oh-my-zsh.sh
fi

# Set fzf installation directory path
export FZF_BASE=~/.dotfiles/zsh/plugins/oh-my-zsh/plugins/fzf/

# Configure zsh syntax highlighting
source $DOT/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)

source $DOT/prompt.zsh

# Highlight flag descriptions.
# zstyle ':completion:*:options' list-colors '=(-- *)=32'

# aliases
func_alias(){
	# A convenience function-creation wrapper that allows easy creation of
	# aliases with positional arguments. Also used to fake aliases when we
	# want to bind them to custom completion functions, and, at the same
	# time, want to preserve expansion-then-completion for all others
	# (which appear to be two conflicting goals without a clear zsh
	# configuration solution).
	#
	# use: func_alias ALIAS BODY
	# args:
	#   ALIAS: The alias/function name.
	#   BODY: The body of the function. MUST be enclosed in single quotes
	#       to prevent argument expansion (eg, 'echo $1' vs "echo $1",
	#       since `$1` in the latter would get expanded before being
	#       declared as the function body).

	eval "$1(){$2}"
}

alias ipm="/usr/lib/inkdrop/resources/app/ipm/bin/ipm"
alias bpy="bpython+ 3"
func_alias cc 'gcc $* -o ${*[-1]%.c}'
alias clip="xclip -select clipboard"
alias gcc="gcc -Wall -Wextra"
alias gth=gthumb
alias ghd="git rev-parse --short HEAD | tr --delete '\n'"
alias jsw="jekyll serve --watch"
alias jq="noglob jq"
alias ka=killall
alias open=xdg-open
alias py=python3
func_alias cppath 'readlink -e $1 | tr -d "\n" |  clip'
alias so=source
alias soz="source ~/.zshrc"
alias sudo="sudo "
alias t="command tmux"
alias uz=unzip
alias v="vim -p"
func_alias zipd 'zip -r $1.zip $1'
func_alias markdown2pdf 'pandoc -o ${1:r}.pdf --from markdown --template ~/.dotfiles/res/pandoc_template.latex --listings $*'
func_alias tmux-capture-screen 'tmux capture-pane -pS 2 | v -'

# apt-get
alias agi="sudo apt-get -y install"
alias agu="sudo apt-get update"
alias agr="sudo apt-get remove"
alias agrp="sudo apt-get remove --purge"
alias acs="sudo apt-cache search"

# core utils
alias l="ls --color=auto -h --group-directories-first -p -X"
alias ll="l -al"
alias m=man
alias mk="make -j"
alias mkd=mkdir
alias rmd=rmdir
alias rmrf="rm -rf"
alias wg="noglob wget"
alias curl="noglob curl"
alias tree='tree -C'

# git
alias g=git
alias ga="git add"
alias gau="git add -u"
alias gb="git branch"
alias gba="git branch -a"
func_alias gbd "git branch -d"
alias gbm="git branch --merged"
alias gbnm="git branch --no-merged"
alias gc="git commit --verbose"
func_alias gco 'git checkout $*'
alias gcob="noglob git checkout -b"
alias gwd="git diff --word-diff-regex='.' --word-diff=color"
alias gwd2="git diff --word-diff=color"
alias gd="git diff"
alias gf="git fetch"
alias gi="git init"
alias gm="git merge --no-ff"
alias gp="git pull"
alias gpu="noglob git push"
func_alias gpub \
	'git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias gpuo="git push origin"
func_alias grf 'noglob git rebase -i $1^'
alias grb="git rebase"
alias grh="git reset HEAD"
alias grhh="git reset --hard HEAD"
alias grm="git rm"
alias gs="git status"
alias gst="git stash"
alias gsta="git stash apply"
alias gstl="git stash list"
alias gsu="git submodule"
alias gu="git up"
alias feh='feh --action1 ";xclip -selection clipboard -t image/png -i %F"'

alias pyawk='noglob pyawk'

# background
exec_background(){
	# Detach and silently execute a command.
	#
	# use: exec_background CMD [ARGS ...]
	#   CMD: the command to execute
	#   ARGS: any args to pass to the command.

	(command nohup $* &) > /dev/null 2>&1
}

alias_bg(){
	# Wrapper for `alias` for processes meant to be run in the
	# background.
	#
	# use: alias_bg ALIAS_NAME [ALIAS_CONTENTS ...]
	#   ALIAS_NAME (str) : The name of the alias, as passed to `alias`.
	#   ALIAS_CONTENTS (str) : The contents of the alias, as passed to
	#       `alias`. Will be wrapped in `exec_background()`. If no
	#       argument(s) is/are given, `ALIAS_NAME` will be used as
	#       `ALIAS_CONTENTS`.

	[ $# -eq 1 ] && local cmd="$1" || local cmd="${@[2, -1]}"
	alias "$1"="exec_background $cmd"
}

alias_bg chrome google-chrome
alias_bg libre libreoffice
alias_bg gummi
alias_bg ev evince
alias_bg gimp

# functions & conditionals
gdsu(){
	# Delete a git submodule's files and metadata.
	#
	# use: gdsu SUBMODULE_NAME
	# args:
	#   SUBMODULE_NAME : The name of the submodule to delete.

	submodule=$1

	test -z $submodule && echo "submodule required" 1>&2 && exit 1
	test ! -f .gitmodules && echo ".gitmodules file not found" 1>&2 \
		&& return

	NAME=$(echo $submodule | sed 's/\/$//g')
	test -z $(git config --file=.gitmodules submodule.$NAME.url) \
		&& echo "submodule not found" 1>&2 && return

	git config --remove-section submodule.$NAME
	git config --file=.gitmodules --remove-section submodule.$NAME
	git rm --cached $NAME
	rm -rf $1
}

gbda(){
	# Delete a merged branch, locally and remotely.
	#
	# use: gbda GIT_BRANCH_NAME
	# args:
	#   GIT_BRANCH_NAME : The name of the branch to delete. If it's not
	#       merged, gbda will terminate.

	if [ "$(git branch --merged | grep "$1")" = "" ]; then
		echo "Branch $1 is not merged."
		return
	fi

	git branch -d $1
	if [ "$(git branch -a --no-color | \
		pcregrep -M "remotes/origin/$1\n")" ]; then
		git push origin --delete $1
	fi
}

gcl(){
	# Smart git-clone wrapper, which can auto-insert the GitHub url for
	# https/ssh depending on arguments.
	#
	# use: gcl (PROTOCOL USER/REPO) | URL
	# args:
	#   PROTOCOL: Either `s`(sh) or `h`(ttps). Auto-inserts the correct
	#       GitHub url for each.
	#   USER/REPO: The username of the owner and name of the GitHub
	#       repository to clone.
	#   URL: The fully qualified url of the repository to clone.

	local url=""
	if [ $# -eq 2 ]; then
		case $1 in
			s)
				url="git@github.com:$2"
				;;

			h)
				url="https://github.com/$2"
				;;
		esac
	else
		if ! [[ "$1" =~ ^https: ]]; then
			url="git@github.com:$1"
		else
			url="$1"
		fi
	fi

	git clone "$url"
}

gl(){
	# Heavily formatted `git log` wrapper.
	#
	# use: gl [GIT_LOG_ARGS]
	# Args:
	#   GIT_LOG_ARGS : Any arguments to `git log`.

	git_log_format="%C(1)%h%Creset  %C(3)%<(15,trunc)%an%Creset "
	git_log_format="$git_log_format%C(2)%<(14,trunc)%cr%Creset %C(6)%s%Creset"
	git log --pretty=format:$git_log_format $*
}

memcheck(){
	# Wrapper around the Valgrind `memcheck` tool; sets helpful flags and
	# colorizes output using the `remark` utility.
	#
	# use: memcheck EXECUTABLE
	#   EXECUTABLE (str): Invocation of the executable that valgrind will
	#       run in a sandbox.

	valgrind \
		--leak-check=yes \
		--show-reachable=yes \
		--num-callers=20 \
		--track-fds=yes \
		--track-origins=yes $* 2>&1 |\
		remark $DOT/remark_syntax/memcheck.remark
}

tard(){
	tar cvfz $1.tar.gz $1
}

gpuf(){
	cmd="git push --force-with-lease origin $(git rev-parse --abbrev-ref HEAD)"
	echo "Executing: $cmd"
	read "?Are you sure? [y/n]"
	if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
		echo "aborting"
	fi

	set -x
	$cmd
	set +x
}

list(){
	for file in $*; do
		echo $file
	done
}

if [[ -s "/etc/zsh_command_not_found" ]]; then
	source "/etc/zsh_command_not_found"
fi

# completion
compctl -K _gdsu_compl gdsu
compctl -K _git_branch_compl gbda
compctl -K _git_branch_compl gbd
compctl -K _eject_compl eject
compctl -K _gco_compl gco

_gdsu_compl(){
	# Git submodule name completion for `gdsu()`.

	submodules="$(cat .gitmodules |\
		grep -Po '(?<=submodule \").*(?=\")')"
	reply=("${(f)${submodules}}")
}

_eject_compl(){
	# "/media/$USER" sub-directory name completion for `eject`.

	ejectable_devices="$(ls /media/$USER)"
	reply=("${(f)${ejectable_devices}}")
}

_gco_compl(){
	# Git branch-name and modified file-path completion for `gco`.

	modified_files=(
		"${(f)$(git status --porcelain |\
		sed "/^ M /!d" |\
		sed "s/^ M //g")}"
	)

	# Prune the current directory from each modified file's path.
	git_dir=${PWD##$(git rev-parse --show-toplevel)}
	modified_files=(${${modified_files##$git_dir[2,-1]}##/})

	remote_branches=(
		"${(f)$(git branch --no-color --remote |\
			sed "/^*/d;/HEAD/d;s/^  origin\///g")}"
	)

	_git_branch_compl
	for branch in $remote_branches; do
		if ! [[ ${reply[(r)$branch]} == $branch ]]; then
			reply+=($branch)
		fi
	done
	reply=($reply $modified_files)
}

_git_branch_compl(){
	# Git local branch-name completion.

	reply=(
		"${(f)$(git branch --no-color | sed "/^*/d" | tr -d "^  ")}"
	)
}

c(){
	cd $@
	on_directory_enter
}
compdef _dirs c

on_directory_enter(){
	# Currently just handles (de)activating Python virtual envs.

	venv_directory=venv
	curr_dir=$(pwd)

	# If a venv is currently enabled, check if we're still in its directory
	# tree and disable it if not.
	if ! [ "$VIRTUAL_ENV" = "" ]; then
		if [ "$(echo $curr_dir | grep "$(dirname $VIRTUAL_ENV)")" = "" ]; then
			deactivate
		else
			return
		fi
	fi

	# Search up the directory tree, stopping at the first directory with a
	# virtual env and sourcing it.
	dirs=($(echo ${curr_dir##$HOME} | tr "/" " "))
	for dir in ${(Oa)dirs}; do
		venv_path="${curr_dir%%$dir*}$dir/$venv_directory"
		if [[ -d "$venv_path" ]]; then
			source "$venv_path/bin/activate"
		fi
	done
}
on_directory_enter

bindkey -M vicmd v edit-command-line
bindkey -M menuselect '?' vi-insert
bindkey -v "^r" history-incremental-pattern-search-backward
bindkey -v

source $DOT/plugins/zsh-ctrlp.zsh
