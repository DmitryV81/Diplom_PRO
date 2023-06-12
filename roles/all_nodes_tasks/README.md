all_nodes_tasks
=========

С помощью этой роли отключается на всех хостах SeLinux и копируется файл hosts

Example Playbook
----------------

---
- name: Copy hosts to all nodes
  copy:
    src: hosts
    dest: /etc/

- name: Disable SeLinux
  shell: |
    setenforce 0

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
