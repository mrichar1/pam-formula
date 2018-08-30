{% from "pam/map.jinja" import pam with context %}
{% set pam_config = salt['pillar.get']('pam:pam_config', pam.pam_config) %}

{% if grains.os_family == 'Debian' %}
pam-auth-update:
  module.run:
    - name: file.remove
    - path: /var/lib/pam/seen

  cmd.run:
    - name: DEBIAN_FRONTEND=noninteractive pam-auth-update --force
{% endif %}

{% for file_name, config in pam_config.items() %}
/usr/share/pam-configs/{{ file_name }}:
  file.managed:
    - source: salt://pam/files/pam-config.jinja
    - template: jinja
    - onchanges_in:
      - cmd: pam-auth-update
    - defaults:
      config: {{ config }}
      file_name: {{ file_name }}
{% endfor %}

#TODO: authconfig
