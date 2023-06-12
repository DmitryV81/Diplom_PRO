nginx
=========

Установка и настройка веб сервера nginx. Служит в качестве фронтенда в проекте. Балансирует траффик между двумя ВМ с установленным httpd.

Работает на порту 443. SSL сертификаты предустановлены. Установлен клиент GlusterFS для синхронизации каталогов с бекендами.

FastCGI настроен на ВМ backend1


Requirements
------------

Ниже процесс создания ssl-сертификатов для веб-сервера:

```
mkdir /etc/ssl/private
chmod 700 /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

Generating a 2048 bit RSA private key
............+++
..............................................................+++
writing new private key to '/etc/ssl/private/nginx-selfsigned.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:RU
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:OTUS
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:frontend
Email Address []:hunter1981@yandex.ru
[root@frontend ~]# openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
Generating DH parameters, 2048 bit long safe prime, generator 2
This is going to take a long time
............................................................................................................+...................................................................................................................................................................................................................................+........+..................................................+...................................................................................................+..........+..................+.......+.................................................................................................................................................+.....................+.................................+.....................................................+................................+...................................+.......................................................................................................+...+................................................................................................++*++*

```

Role Variables
--------------
```
servername: FinalProject
listen_port: 443
backend1: 192.168.50.11
backend2: 192.168.50.12
backend_port: 8080
fastcgi: 192.168.50.11
fastcgi_port: 9000
```


Example Playbook
----------------

```
---
- name: Include vars file
  ansible.builtin.include_vars: nginx.yaml
  
- name: Install epel-release
  yum:
    name: epel-release
    state: latest

- name: Install nginx
  yum:
    name: nginx
    state: present

- name: Disable firewalld
  systemd:
    name: firewalld
    state: stopped
    enabled: no
  ignore_errors: yes

- name: Copy nginx configuration
  template: src=nginx.j2 dest=/etc/nginx/nginx.conf

- name: Copy nginx ssl configuration
  template: src=ssl.j2 dest=/etc/nginx/conf.d/ssl.conf

- name: copy ssl directory
  copy:
    src: ssl
    dest: /etc/
    directory_mode:
  tags:
    - parentdir

- name: Create folder for synchronize
  command: mkdir /var/www
  become: true
  become_user: root

- name: Create folder for synchronize
  command: mkdir /var/www/html
  become: true
  become_user: root

- name: nginx service state
  service:
    name: nginx
    state: started
    enabled: yes

...
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
