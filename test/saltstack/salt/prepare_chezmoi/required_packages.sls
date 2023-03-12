# -*- coding: utf-8 -*-
# vim: ft=yaml
---
install_required_packages:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'Debian'%}
      - build-essential
      {% endif %}
      - curl
      - file
      - git
      - gzip
      - procps
      - tar