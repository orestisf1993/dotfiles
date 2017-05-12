export TERM=xterm-256color
# Sane opts from https://github.com/willghatch/zsh-saneopt/
# Load in the start so that they can get overriden later.
bindkey -e # default keymap, first command so that it doesn't override anything.
source ~/.zsh/zsh-saneopt/saneopt.plugin.zsh

# http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/
source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/history.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

# https://github.com/wting/autojump
source /usr/share/autojump/autojump.zsh
# https://github.com/urbainvaes/fzf-marks
source /usr/share/fzf-marks/fzf-marks.zsh

# Desktop notifications for long-running commands in zsh.
# https://github.com/marzocchi/zsh-notify
source /usr/share/zsh/plugins/zsh-notify/notify.plugin.zsh
zstyle ':notify:*' error-icon "$HOME/.zsh/icons/error-icon"
zstyle ':notify:*' success-icon "$HOME/.zsh/icons/success-icon"
zstyle ':notify:*' disable-urgent yes

# command not found from pkgfile
source /usr/share/doc/pkgfile/command-not-found.zsh

# https://github.com/djui/alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="You know you have an alias for that, right? "
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="vi"
source ~/.zsh/alias-tips/alias-tips.plugin.zsh

# https://github.com/zsh-users/zsh-completions
source ~/.zsh/zsh-completions.zsh

# https://github.com/tarruda/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export FZF_COMPLETION_TRIGGER='~~'
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# https://github.com/rimraf/k
source /usr/share/zsh/plugins/zsh-k/k.sh

# https://github.com/zsh-users/zsh-syntax-highlighting
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
# pacaur -S zsh-history-substring-search-git
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Custom bindkeys have higher priority.
source ~/.zsh/bindkeys.zsh

# generated completions should be the last choice
fpath+=~/.zsh/generated-completions
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath
