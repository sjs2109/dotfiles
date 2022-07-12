LANG="en_US.UTF-8"
# export JAVA_HOME=$(/usr/libexec/java_home)
export GOBIN=$HOME/go/bin
export TERM=xterm-256color
export SDKROOT=$(xcrun --show-sdk-path)

# history setting
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000
export HISTFILESIZE=1000000000
export HISTTIMEFORMAT="%F %T "
shopt -s histappend     # 히스토리 파일 뒤에 추가한다
shopt -s cmdhist        # 여러 줄에 걸쳐 작성된 멍령을 세미콜론으로 연결된 하나의 문장으로 저장

# fzf
export FZF_DEFAULT_COMMAND="find . -path '*/\.*' -type d -prune -o -type f -print -o -type l -print 2> /dev/null | sed s/^..//"
export FZF_DEFAULT_OPTS="--bind ctrl-space:print-query,pgup:preview-up,pgdn:preview-down --cycle"

# less color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;42;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'

# vim, tmux
export EDITOR=$(which nvim)
# export MANPAGER=vimpager

# aliases
if ls --version > /dev/null 2>&1; then
    alias ls='ls --color=auto'; #gnu
    alias l.='ls -d .* --color=auto'
else
    # alias ls='ls -G'; #osx
    # alias ls='gls --color=tty --time-style="+%Y-%m-%d %a %H:%M:%S"'; #osx
    alias ls='exa --icons --time-style="long-iso"'; #osx
    alias l.='ls -dG .*'
fi
alias ll='ls -alh'
# alias ll='exa --icons --time-style="long-iso" -alh'
# alias vi='mvim -v'
alias vi='nvim'
alias vim='nvim'
alias rm='rm -iv'
alias mv='mv -i'
alias cp='cp -i'
alias cd..='cd ..'
alias eclimd='~/Applications/Eclipse_neon.app/Contents/Eclipse/eclimd'
alias ctags='`brew --prefix`/bin/ctags'
alias tmux="TERM=screen-256color tmux"
alias tm="tmux attach || tmux new"
#alias vimr='open -a VimR.app "$@"'
alias ag='ag --path-to-ignore ~/.agignore'
alias agl='ag --pager="less -XFR"'
alias ncd='ncdu --color dark -rr -x'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias bc='bc -l ~/.bcrc -q'
alias weather='curl v2.wttr.in/Seoul'
alias myfortune='fortune ~/Dropbox/my-fortune'
alias randomjava="find . -name '*.java' | sort -R | head -1 | egrep '[^/]+\.java'"
alias brew="arch -x86_64 /usr/local/bin/brew"

# colors
GREEN='\e[0;32m\]'
B_GREEN='\e[1;32m\]'
MAGENTA='\e[0;35m\]'
B_MAGENTA='\e[1;35m\]'
YELLOW='\e[0;33m\]'
B_YELLOW='\e[1;33m\]'
RED='\e[0;31m'
BLUE='\e[0;34m'
B_BLUE='\e[1;34m'
CYAN='\e[0;36m\]'
COLOR_END='\[\033[0m\]'

# PROMPT ----------------------------------------------------------------------
# PS1="\h:\W \u\$ "  # default promopt
function gbr {
    git status --short 2> /dev/null 1> /dev/null
    if [ "$?" -ne "0" ]; then
        return 1
    else
        branch="`git branch | grep '^\*' | cut -c 3-`"
        branch_str="\033[1;031m$branch\033[0m"

        stat=`git s \
            | awk '{print $1}' \
            | sort | uniq -c \
            | tr '\n' ' ' \
            | sed -E 's/([0-9]+) /\1/g; s/  */ /g; s/ *$//'`

        stash_size=`git stash list | wc -l | sed 's/ //g'`
        stash_icon=" \e[0;92m≡\033[0m"
        printf "[$branch_str]$stat$stash_icon$stash_size"
        return 0
    fi
}

export PS1="${MAGENTA}\$(date '+%Y-%m-%d-%a %VW') \
${B_YELLOW}\$(date +%T) \
${GREEN}\u \
${B_MAGENTA}\h \
${B_BLUE}\w \
${COLOR_END}\
\$(gbr)\n\$ "


# PROMPT_COMMAND="share_history; $PROMPT_COMMAND"

[ -f ~/.local/bin/git-completion.bash ] && source ~/.local/bin/git-completion.bash
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -e ~/.phpbrew/bashrc ] && source ~/.phpbrew/bashrc

for f in ~/.local/bin/*.sh; do source $f; done

source $(which fav.sh)

bind '"\ev": "\C-ufav\C-m"'
bind '"\ed": "droller \"`pbpaste`\"\C-m"'

eval $(thefuck --alias)

function bgcolors {
    for((i=16; i<256; i++)); do
        printf "\e[48;5;${i}m%03d" $i;
        printf '\e[0m';
        [ ! $((($i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
    done

    for((i=30; i<112; i++)); do
        printf "\e[0;${i}m\]%03d" $i;
        printf '${i}' $i;
        [ ! $((($i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
    done
}

function todo {
    file1=`stat -f "%N" ~/Dropbox/git/localwiki/_wiki/todo.md`
    # file2=`stat -f "%N" ~/Dropbox/git/localwiki/_wiki/times.md`

    if [ "$1" = "edit" ]; then
        # vim $file1 $file2
        vim $file1
        return 0
    fi

    start=2
    last=`egrep -n '^# In Progress$' $file1 | cut -d: -f1`
    last=$(($last - 1))
    esc=$(printf '\033')

    head -$last $file1 \
        | egrep -v '^\s*$' \
        | egrep -v '^\s*\*\s*\[X\]' \
        | tail -n +$start \
        | sed -E "s,^\*,${esc}[32m&${esc}[0m," \
        | sed -E "s,([0-9]+-){2}[0-9]+,${esc}[33m&${esc}[0m,"
}

function google() {
    open /Applications/Google\ Chrome.app/ "http://www.google.com/search?q= $1";
}


# iTerm2 tab and window title
if [ $ITERM_SESSION_ID ]; then
    # iTerm의 탭 타이틀에 현재 디렉토리 이름을 넣어준다
    export PROMPT_COMMAND='echo -ne "\033]1;${PWD##*/}\007"; '
fi

ls /usr/local/bin | sort -R | head -1 | xargs echo "Do you know about this? -> " && echo ''

myfortune && echo ''
ioreg -r -d 1 -k BatteryPercent | grep BatteryPercent | tr -d ' '
