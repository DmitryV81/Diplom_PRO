ntpd
=========

Установка и настройка клиента ntpd для синхронизации времени на всех ВМ проекта


Example Playbook
----------------

```
---
- name: start chronyd
  service:
    name: chronyd
    state: started
    enabled: yes

- name: set timezone
  shell: timedatectl set-timezone Europe/Moscow
 
- name: Install NTP
  yum:
    name: ntp
    state: present

- name: Copy NTP conf
  copy:
    src: ntp.conf
    dest: /etc/ntp.conf

- name: stop NTP
  service:
    name: ntpd
    state: stopped
    enabled: yes

- name: Sync time
  shell: ntpdate 0.centos.pool.ntp.org

- name: Start NTP
  service:
    name: ntpd
    state: started
    enabled: yes

- name: Sync hwclock
  shell: hwclock -w

...
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
