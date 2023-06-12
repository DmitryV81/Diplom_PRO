grafana
=========

Установка и настройка Grafana для работы в качестве фронтенда к prometheus.


Role Variables
--------------

grafana_admin_password: "hunter1981"

Несколько скриншотов:
--------------
![Gragana1](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/p1.png)
![Gragana2](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/p2.png)
![Gragana3](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/p3.png)
![Gragana4](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/p4.png)
![Gragana5](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/p5.png)


Example Playbook
----------------

---
- name: Include vars file
  ansible.builtin.include_vars: grafana_vars.yaml

- name: Add repository
  yum_repository:
    name: Grafana
    description: Grafana YUM repo
    baseurl: https://packages.grafana.com/oss/rpm
    gpgkey: https://packages.grafana.com/gpg.key
    gpgcheck: no
    sslverify: yes
    sslcacert: /etc/pki/tls/certs/ca-bundle.crt

- name: Install Grafana
  yum:
    name: grafana
    state: latest

- name: grafana start
  systemd:
    name: grafana-server
    enabled: yes
    state: started

- name: wait for service up
  uri:
    url: "http://127.0.0.1:3000"
    status_code: 200
  register: __result
  until: __result.status == 200
  retries: 120
  delay: 1
- name: change admin password for grafana gui
  shell : "grafana-cli admin reset-admin-password {{ grafana_admin_password }}"
  register: __command_admin
  changed_when: __command_admin.rc !=0

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
