{% from "pam/map.jinja" import pam with context %}
{% set pam_config = salt['pillar.get']('pam:pam_config', pam.pam_config) %}

{% if grains.os_family == 'Debian' %}
{% for file_name, config in pam_config.items() %}
pam-auth-update_{{ file_name }}:
  module.run:
    - name: file.remove
    - path: /var/lib/pam/seen

  cmd.run:
    - onchanges:
      - /usr/share/pam-configs/{{ file_name }}
    - name: DEBIAN_FRONTEND=noninteractive pam-auth-update --enable {{ file_name }}

/usr/share/pam-configs/{{ file_name }}:
  file.managed:
    - source: salt://pam/files/pam-config.jinja
    - template: jinja
    - defaults:
      config: {{ config }}
      file_name: {{ file_name }}
{% endfor %}
{% endif %}

#TODO: authconfig
