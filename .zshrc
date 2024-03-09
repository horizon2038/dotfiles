export PATH="$PATH:$HOME/.cargo/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet/sdk:$HOME/bin"

if [ -e ~/.zsh/completions ]; then
    fpath=(~/.zsh/completions $fpath)
fi

#vim mode
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

function zle-line-init zle-keymap-select {
    # %K{208}%F{black}⮀%k%f
    VIM_NORMAL="%K{208}%F{white} % NORMAL %k%f%K{black}%F{208}⮀%k%f"
    VIM_INSERT="%K{075}%F{white} % INSERT %k%f%K{black}%F{075}⮀%k%f"
    PS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT} %F{14}%~%f > "
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# PROMPT THEME (ORIGINAL)
# PROMPT="%S%F{14}%n%f%s: %F{14}%c%f > "

#command alias
alias ls="ls -laG"
alias clear="printf '\33c\e[3J'"
alias reload="source ~/.zshrc"
alias ddesk="open /Applications/Docker.app"
alias clocg="cloc . --vcs=git"
alias clocga='clocg | awk "/^SUM:/ {print \$3 + \$4 + \$5}"'
alias lsearch="find . -type f | xargs grep -r -n"

export PRG="$HOME/Documents/Program"

zle -N zle-keymap-select

# color
autoload -Uz colors && colors

#git complete
source ~/.zsh/completions/git-prompt.sh
fpath=(~/.zsh $fpath)

# autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

setopt hist_ignore_dups
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

[ -f "/Users/horizon/.ghcup/env" ] && source "/Users/horizon/.ghcup/env" # ghcup-env
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
