# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$PATH:/home/linuxbrew/.linuxbrew/bin:$HOME/.local/bin:$HOME/.gem/bin
#export PATH="/home/ubuntu/.gem/gems/taskjuggler-3.7.1/bin":$PATH
# Path to your oh-my-zsh installation.
export ZSH="/home/ubuntu/.oh-my-zsh"
export EDITOR='vim'
export HOMEBREW_NO_AUTO_UPDATE=0
export NNN_COLORS='123456789'
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#for ddgr
# export BROWSER="/usr/bin/w3m"
# export BROWSER="www-browser"
export BROWSER="lynx"
export FZF_BASE=/home/ubuntu/.fzf/shell
#export TERM="xterm-256color"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="candy-kingdom"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="candy"
 ZSH_THEME="fino-time"
 #ZSH_THEME="powerlevel9k/powerlevel9k"
 #source ~/.powerlevel9k.sh
 #POWERLEVEL9K_MODE="nerdfont-complete"
# source $ZSH/.theme_config
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
 DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
 DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(command-not-found fzf debian autojump cp alias-finder tmux vi-mode  branch git zsh-autosuggestions zsh-syntax-highlighting zsh-completions extract)
#
#antigen plugin manager like bundle to vim
#source $ZSH/antigen.zsh
# Load the oh-my-zsh's library.
#antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle git
#antigen bundle heroku
#antigen bundle pip
#antigen bundle lein
#antigen bundle dnf
#antigen bundle command-not-found
#antigen use oh-my-zsh
#antigen bundle StackExchange/blackbox
#antigen bundle brew
#antigen bundle common-aliases
#antigen bundle docker
#antigen bundle docker-compose
#antigen bundle git
#antigen bundle golang
#antigen bundle npm
#antigen bundle nvm
#antigen bundle python
#antigen bundle tmux
#antigen theme bhilburn/powerlevel9k powerlevel9k

# Syntax highlighting bundle.
#antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
#antigen theme robbyrussell
#antigen theme powerlevel9k
# Tell Antigen that you're done.
#antigen apply

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#if command -v tmux &> /dev/null && [ -n "$PS1"  ] && [[ ! "$TERM" =~ screen  ]] && [[ ! "$TERM" =~ tmux  ]] && [ -z "$TMUX"  ]; then
	  #exec tmux
#fi
## tmux config
if [[ -z "$TMUX" ]]; then
	if tmux has-session 2>/dev/null; then
		exec tmux attach
	else
		exec tmux
	fi
fi
### nnn config
NNN_PLUG_PERSONAL='g:personal/convert2zoom;p:personal/echo'
NNN_PLUG_WORK='j:work/prettyjson;d:work/foobar'
NNN_PLUG_INLINE='e:_go run $nnn*'
NNN_PLUG_DEFAULT='1:bookmarks;2:ipinfo;p:preview-tui;o:fzz;b:nbak'
NNN_PLUG="$NNN_PLUG_PERSONAL;$NNN_PLUG_WORK;$NNN_PLUG_DEFAULT;$NNN_PLUG_INLINE"
export NNN_PLUG

alias v="vim"
alias ag="alias | grep"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias p="~/pclint "
alias lc="leetcode"
alias lct="leetcode test "
alias lcs="leetcode submit "
lcsh() { leetcode show $1 --solution }
alias lcst="leetcode stat"
alias lce="lc show -q e -gxeD"
alias lcm="lc show -q m -gxeD"
alias lcH="lc show -q H -gxeD"
alias tlc="g++ -fsanitize=address -fno-omit-frame-pointer -g header.h "
alias vpn="expressvpn"
source /home/ubuntu/.lc-completion.bash
alias python="python3"
alias weather="curl -4 wttr.in"
trash_path="$HOME/.trash"
if [ ! -d $trash_path  ]; then
	mkdir $trash_path
fi
alias rm="echo Use 'dl' insead, or the full path i.e. '/bin/rm'"
#dl() { mv "$@" $trash_path && find $trash_path -mtime +30 -delete}
dl() { sudo mv "$@" $trash_path }
alias c="cht.sh --shell"
alias d="ddgr"
eval $(thefuck --alias)
###-begin-leetcode-completions-###
#
# yargs command completion script
#
# Installation: leetcode completion >> ~/.bashrc
#    or leetcode completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(leetcode --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions leetcode
###-end-leetcode-completions-###

bindkey '^F'   forward-word        


source $(dirname $(gem which colorls))/tab_complete.sh
alias ll='colorls -lA --sd'
alias cl='colorls'

