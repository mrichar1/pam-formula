{% from "pam/map.jinja" import pam with context %}

{{ pam.mkhomedir_config }}:
  file.managed:
    - source: salt://pam/files/my_mkhomedir
    - user: root
    - group: root

pam-auth-update:
  cmd.run:
    - name: pam-auth-update --force