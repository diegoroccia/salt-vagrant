install_zsh:
  local.state.single:
    - tgt: {{ data['id'] }}
    - args:
      - fun: pkg.installed
      - name: zsh

{% set num = range(0,1000) %}

create_file:
  local.state.single:
    - tgt: {{ data['id'] }}
    - args:
      - fun: file.append
      - name: /tmp/test
      - text: 'LastRun: {{ None | strftime("%Y.%M.%d %H:%M:%S") }}'
