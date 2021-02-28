# If not running interactively, don't do anything
 [[ $- != *i* ]] && return

 #PS1='[\u@\h \W]\$ '

 # Settings
 source ~/.bash/settings.bash

 # Aliases
 source ~/.shell/aliases.sh

 # Custom prompt
source ~/.bash/prompt.bash
