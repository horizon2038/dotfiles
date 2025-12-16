export PATH="$HOME/.cargo/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet/sdk:$HOME/bin:$PATH"

if [ -e ~/.zsh/completions ]; then
    fpath=(~/.zsh/completions $fpath)
fi

#vim mode
bindkey -v
# bindkey -M viins 'jj' vi-cmd-mode

# common
KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    # %K{208}%F{black}⮀%k%f
    VIM_NORMAL="%K{208}%F{white} % NORMAL %k%f%K{black}%F{208}%k%f"
    VIM_INSERT="%K{075}%F{white} % INSERT %k%f%K{black}%F{075}%k%f"
    PS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT} %F{14}%~%f > "
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# PROMPT THEME (ORIGINAL)
# PROMPT="%S%F{14}%n%f%s: %F{14}%c%f > "

# command alias
alias ls="ls -laG"
alias clear="printf '\33c\e[3J'"
alias reload="source ~/.zshrc; hash -r"
alias ddesk="open /Applications/Docker.app"
alias clocg="cloc . --vcs=git"
alias clocga='clocg | awk "/^SUM:/ {print \$3 + \$4 + \$5}"'
alias lsearch="find . -type f | xargs grep -r -n"
alias sed='gsed'
alias llvm-objdump='llvm-objdump -Mintel --demangle'
alias cmakex='cmake -B build -DCMAKE_C_COMPILER="clang" -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias cmake-setup='cmake -B build -DCMAKE_C_COMPILER="clang" -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias ninja-setup='cmake -B build -G Ninja -DCMAKE_C_COMPILER="clang" -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'

export PRG="$HOME/Documents/Program"
export A9N="$PRG/A9N"
export KOITO="$PRG/KOITO"

zle -N zle-keymap-select

# color
autoload -Uz colors && colors

# git complete
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

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
source "$HOME/.rye/env"

# export PATH="$PATH:$HOME/opt/bochs/bin"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
alias sel4_container='make -C /<path>/<to>/seL4-CAmkES-L4v-dockerfiles user HOST_DIR=$(pwd)'
alias sel4_container='make -C /<path>/<to>/seL4-CAmkES-L4v-dockerfiles user HOST_DIR=$(pwd)'
