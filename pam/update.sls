{% from "pam/map.jinja" import pam with context %}

{% if grains.os_family == 'Debian' %}

{% for file_name, config in pam['pam_config'].items() %}
/usr/share/pam-configs/{{ file_name }}:
  file.managed:
    - source: salt://pam/files/pam-config.jinja
    - template: jinja
    - defaults:
      config: {{ config }}
      file_name: {{ file_name }}

pam-auth-update_{{ file_name }}:
  cmd.run:
    - onchanges:
      - /usr/share/pam-configs/{{ file_name }}
    - name: DEBIAN_FRONTEND=noninteractive pam-auth-update --enable {{ file_name }}
{% endfor %}
{% endif %}

#TODO: authconfig
