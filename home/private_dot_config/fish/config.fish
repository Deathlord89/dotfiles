if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
end

## Source custom configs
for file in $__fish_config_dir/custom.d/*.fish
  source $file
end