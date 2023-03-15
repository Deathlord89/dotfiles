# -*- coding: utf-8 -*-
# vim: ft=yaml
---
set_env:
   environ.setenv:
     - name: DOTFILES_MINIMAL
     - value: "{{ salt['pillar.get']('env_override:minimal') }}"
     - update_minion: false
     - false_unsets: true

excecute_chezmoi_install_script:
  cmd.run:
    - name: '/home/vagrant/dotfiles/install.sh'
    - cwd: '/home/vagrant/dotfiles/'
    - runas: vagrant