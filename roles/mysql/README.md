mysql
=========

Установка и настройка двух ВМ mysqlmaster и mysqlslave. Репликация master-slave. Метод GTID репликация. 

Также к ВМ mysqlslave подключается кластерное сетевое хранилище для копирования бекапов.

Бекап производится раз в сутки в 23:00.

Скрипт для бекапа в каталоге files роли, задание к crontab создается с помощью ansible. Код ниже.

Role Variables
--------------
```
path_to_source_server: 192.168.50.13
mysql_root_password: 'Hunter1981!'
mysql_db: wordpress
mysql_user: wordpress
mysql_password: 'PassW0rd1!'
```
Dependencies
------------


Example Playbook
----------------

```
---
- name: Include vars file
  ansible.builtin.include_vars: mysql.yaml

- name: Get GPG key
  command: rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

- name: Install wget utils
  yum:
    name: wget
    state: present
- name: Download rpm package MySQL v. 7-7
  command: wget https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm
  
- name: Install MySQL repo
  yum: 
    name: mysql80-community-release-el7-7.noarch.rpm
    state: present

- name: Install MySQL
  yum: pkg={{ item }}
  loop:
  - mysql-community-server
  - mysql-community-client
  - MySQL-python

- name: Start the MySQL service
  service: name=mysqld state=started enabled=true

- name: Change mysql root password and keep track in
  become: true
  shell: |
    password_match=`awk '/A temporary password is generated for/ {a=$0} END{ print a }' /var/log/mysqld.log | awk '{print $(NF)}'`
    echo $password_match
    mysql -uroot -p$password_match --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Hunter1981!'; flush privileges; "
    echo "[client]"
    user=root
    password=Hunter1981! > /root/.my.cnf
  args:
    creates: /root/.my.cnf
  register: change_temp_pass
  notify: restart mysqld
- meta: flush_handlers
- debug:
    var: change_temp_pass

#Replication block there

- name: Copy Slave MYSQLServer configuration
  template: src=my_slave.j2 dest=/etc/my.cnf
  when: (ansible_hostname == "mysqlslave")

- name: Copy Master WebServer configuration
  template: src=my_master.j2 dest=/etc/my.cnf
  when: (ansible_hostname == "mysqlmaster")

- name: Restart the MySQL service
  service: name=mysqld state=restarted

- name: Create replication user
  shell: |
    mysql -uroot -pHunter1981! -e "CREATE USER 'replication_user'@'%' IDENTIFIED WITH mysql_native_password BY 'Hunter1981!'; GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%'; FLUSH PRIVILEGES; SET @@GLOBAL.read_only = ON;"
  when: (ansible_hostname == "mysqlmaster")


- name: Settings Slave
  shell: |
    mysql -uroot -pHunter1981! -e "SET @@GLOBAL.read_only = ON; CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.50.13', SOURCE_USER='replication_user', SOURCE_PASSWORD='Hunter1981!', SOURCE_AUTO_POSITION=1; start replica;"
  when: (ansible_hostname == "mysqlslave")

- name: unset global read only
  shell: |
    mysql -uroot -pHunter1981! -e "SET @@GLOBAL.read_only = OFF;"
  when: (ansible_hostname == "mysqlmaster")

- name: Remove all anonymous user accounts
  mysql_user:
    name: ''
    host_all: yes
    state: absent
  #login_port: 3306
    login_user: root
    login_password: "{{ mysql_root_password }}"
  when: (ansible_hostname == "mysqlmaster")

- name: Remove the MySQL test database
  mysql_db:
    name: test
    state: absent
    login_user: root
    login_password: "{{ mysql_root_password }}"
  when: (ansible_hostname == "mysqlmaster")

- name: Creates database for WordPress
  mysql_db:
    name: "{{ mysql_db }}"
    state: present
    login_user: root
    login_password: "{{ mysql_root_password }}"
  when: (ansible_hostname == "mysqlmaster")

- name: Create wordpress user
  shell: |
    mysql -uroot -pHunter1981! -e "CREATE USER 'wordpress'@'%' IDENTIFIED WITH mysql_native_password BY 'PassW0rd1!'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%'; FLUSH PRIVILEGES;"
  when: (ansible_hostname == "mysqlmaster")

- name: Install cronie
  yum:
    name: cronie
    state: present
  when: (ansible_hostname == "mysqlslave")

- name: copy script for a backup
  copy:
    src: back.sh
    dest: /home/
  when: (ansible_hostname == "mysqlslave")
    
- name: chmod +x on back.sh
  ansible.builtin.file:
    path: /home/back.sh
    state: touch
    mode: u=rwx,g=x,o=x
  when: (ansible_hostname == "mysqlslave")

- name: Ensure a job that runs at 23-00 exists. Creates an entry like "0 23 * * /home/back.sh"
  ansible.builtin.cron:
    name: "backupDB"
    minute: "0"
    hour: "23"
    job: "/home/back.sh"
  when: (ansible_hostname == "mysqlslave")

# В случае восстановления БД из ранее созданного бекапа, требуется раскомментировать код ниже.
#- name: Copy backup to servers
#  copy:
#    src: backupdb/wordpress
#    dest: /root/backupdb
#  when: (ansible_hostname == "mysqlmaster")

#- name: Restore DB Wordpress
#  shell: |
#    DB=wordpress;
#    USER='root'
#    PASS='Hunter1981!'
#    DIR="/root/backupdb/wordpress"
#    for s in `ls -1 $DIR`;
#    do
#    echo "--> $s restoring... ";
#    zcat $DIR/$s | /usr/bin/mysql --user=$USER --password=$PASS $DB;
#    done
#  when: (ansible_hostname == "mysqlmaster)

...
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
