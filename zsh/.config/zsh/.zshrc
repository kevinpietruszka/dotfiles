export ZSH="$HOME/.oh-my-zsh"
export HISTFILE=$ZDOTDIR/.zsh_history
compinit -d $ZDOTDIR/.zcompdump

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [ -d "/usr/local/go" ]; then
  export PATH=$PATH:/usr/local/go/bin
fi

if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env"
fi

if [ -d "$HOME/.rbenv" ]; then
  export PATH=$PATH:$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

ZSH_THEME="robbyrussell"

plugins=(git web-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
