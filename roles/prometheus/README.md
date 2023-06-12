prometheus
=========

Установка и настройка Prometheus. Служит для аггрегации сведений о состоянии ВМ проекта. Можно использовать отдельно от Grafana (Графическая оболочка). Слушает порт 9090

Role Variables
--------------
```
prometheus_dir_configuration: "/etc/prometheus"
prometheus_retention_time: "365d"
prometheus_scrape_interval: "30s"
prometheus_node_exporter: true
prometheus_node_exporter_group: "nginx-server"
prometheus_env: "production"
prometheus_var_config:
  global:
    scrape_interval: "{{ prometheus_scrape_interval }}"
    evaluation_interval: 5s
  scrape_configs:
    - job_name: prometheus
      scrape_interval: 5m
      static_configs:
        - targets: ['localhost:9090']
```

Example Playbook
----------------

```
---
- name: Include vars file
  ansible.builtin.include_vars: prometheus_vars.yaml

- name: Create user prometheus
  user:
    name: prometheus
    create_home: no
    shell: /bin/false

- name: Create directories for prometheus
  file:
    path: "{{ item  }}"
    state: directory
    owner: prometheus
    group: prometheus
  loop:
    - '/tmp/prometheus'
    - '/etc/prometheus'
    - '/var/lib/prometheus'

- name: Download and Unzipped Prometheus
  unarchive:
    src: https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz
    dest: "/tmp/prometheus"
    remote_src: yes
    extra_opts: [--strip-components=1]

- name: Copy files
  copy:
    src: /tmp/prometheus/{{ item  }}
    dest: /usr/local/bin/
    remote_src: yes
    mode: preserve
    owner: prometheus
    group: prometheus
  loop: [ 'prometheus', 'promtool' ]

- name: Prometheus systemd file
  template:
    src: prometheus.j2
    dest: /etc/systemd/system/prometheus.service
  notify: systemd_reload

- name: prometheus configuration file
  template:
    src: prometheus.yml.j2
    dest: "{{ prometheus_dir_configuration }}/prometheus.yml"
    mode: 0755
    owner: prometheus
    group: prometheus
  notify: reload_prometheus

- name: start prometheus
  systemd:
    name: prometheus
    state: started
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
