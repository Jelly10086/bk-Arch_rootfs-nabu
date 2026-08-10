export EDITOR=${EDITOR:-nano}
export VISUAL=${VISUAL:-$EDITOR}

autoload -Uz compinit && compinit

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v fzf >/dev/null && source <(fzf --zsh)

alias ls='eza --group-directories-first'
alias ll='eza -lah --group-directories-first --git'
alias cat='bat --paging=never'

PROMPT='%F{blue}%n@%m%f %F{cyan}%~%f %# '
