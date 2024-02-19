# /etc/bashrc: DO NOT EDIT -- this file has been generated automatically.

# Only execute this file once per shell.
if [ -n "$__ETC_BASHRC_SOURCED" ] || [ -n "$NOSYSBASHRC" ]; then return; fi
__ETC_BASHRC_SOURCED=1

# If the profile was not loaded in a parent process, source
# it.  But otherwise don't do it because we don't want to
# clobber overridden values of $PATH, etc.
if [ -z "$__ETC_PROFILE_DONE" ]; then
    . /etc/profile
fi

# We are not always an interactive shell.
if [ -n "$PS1" ]; then


# Check the window size after every command.
shopt -s checkwinsize

# Disable hashing (i.e. caching) of command lookups.
set +h

# Provide a nice prompt if the terminal supports it.
if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
  PROMPT_COLOR="1;31m"
  ((UID)) && PROMPT_COLOR="1;32m"
  if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
    # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
    PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
  else
    PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
  fi
  if test "$TERM" = "xterm"; then
    PS1="\[\033]2;\h:\u:\w\007\]$PS1"
  fi
fi

eval "$(/nix/store/j4fwy5gi1rdlrlbk2c0vnbs7fmlm60a7-coreutils-9.1/bin/dircolors -b)"

# Check whether we're running a version of Bash that has support for
# programmable completion. If we do, enable all modules installed in
# the system and user profile in obsolete /etc/bash_completion.d/
# directories. Bash loads completions in all
# $XDG_DATA_DIRS/bash-completion/completions/
# on demand, so they do not need to be sourced here.
if shopt -q progcomp &>/dev/null; then
  . "/nix/store/fpvfl5apywhqq441slqbpy349x3fgg4g-bash-completion-2.11/etc/profile.d/bash_completion.sh"
  nullglobStatus=$(shopt -p nullglob)
  shopt -s nullglob
  for p in $NIX_PROFILES; do
    for m in "$p/etc/bash_completion.d/"*; do
      . "$m"
    done
  done
  eval "$nullglobStatus"
  unset nullglobStatus p m
fi

alias -- l='ls -alh'
alias -- ll='ls -l'
alias -- ls='ls --color=tty'

# Bind gpg-agent to this TTY if gpg commands are used.
export GPG_TTY=$(tty)


fi

# Read system-wide modifications.
if test -f /etc/bashrc.local; then
    . /etc/bashrc.local
fi

case $- in
    *i*) ;;
      *) return;;
esac
export HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=1000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%d/%m/%y %T "
PROMPT_COMMAND='echo -en "\e]0;$(dirs)\a"'
PROMPT_COMMAND="history -a;history -n;$PROMPT_COMMAND"
export TERM=screen-256color

export DISPLAY=192.168.1.2:1.0

shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

PS1="\[\e[38;2;224;108;117m\]\h \[\e[38;2;97;175;239m\]\w \[\e[m\]\$ "

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source ~/.onedark_prompt.sh

test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
