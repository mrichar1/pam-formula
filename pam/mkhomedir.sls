{% from "pam/map.jinja" import pam with context %}

{{ pam.mkhomedir_config }}:
  file.managed:
    - source: salt://pam/files/my_mkhomedir
    - user: root
    - group: root

pam-auth-update:
  cmd.run:
    - name: DEBIAN_FRONTEND=noninteractive pam-auth-update --force

#TODO: pam-config
#TODO: authconfig