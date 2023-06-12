Дипломный проект по курсу "Администратор Linux"

Тема: "Веб-проект с развертыванием нескольких виртуальных машин"

Структура проекта представлена на рисунке:

![Схема проекта](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/scheme.png)

Описание виртуальных машин:

1. frontend. ОС CenOS7. Установлен и настроен на работу по ssl (порт 443) nginx. В конфигурацию nginx включена балансировка траффика между двумя бэкендами

2. backend1. ОС CenOS7. Установлен сервис httpd, php72, php-fpm. Установлен и настроен клиент Glusterfs. Каталог /var/www/html общий, кластерный. Установлена CMS Wordpress.

3. backend2. ОС CenOS7. Установлен сервис httpd, php72, php-fpm. Установлен и настроен клиент Glusterfs. Каталог /var/www/html общий, кластерный. Установлена CMS Wordpress.

4. mysqlmaster. ОС CenOS7. Установлена БД MySQL. Роль master. Репликация GTID.

5. mysqlslave. ОС CenOS7. Установлена БД MySQL. Роль slave. Репликация GTID.

6. storage1, storage2, storage3. ОС CenOS7. Установлен сервер Glusterfs. ВМ storage1 в роли мастера. На ВМ storage2 и storage3 реплицируются данные каталога /share с ВМ storage1. Смонтирован диск объемом 2 Gb, на котором хранятся реплицируемые данные.

7. prometheus. ОС CenOS7. Установлены: Prometheus, Grafana. Служит для осуществления мониторинга за виртуальными машинами в проекте.

Структура ВМ описана в Vagrantfile. К ВМ storage1, storage2, storage3 подключены диски объемом 2Gb.

Стенд проекта поднимается командой vagrant up. После чего происходит первичная настройка виртуальных машин средствами vagrant.

После запуска ВМ дальнейшая настройка производится с помощью ansible.

Запуск плейбука ansible производится командой ansible-playbook -i hosts site.yaml

В плейбуке описаны роли (набор задач), каждая из которых распространяется на определенную ВМ или группу ВМ

Структура каталога проекта представлена в выводе tree:

```
.
├── hosts
├── README.md
├── roles
│   ├── all_nodes_tasks
│   │   ├── files
│   │   │   └── hosts
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   └── templates
│   ├── cluster_storage
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── glusterfs.txt
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── howto.txt
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   ├── templates
│   │   │   └── data.res
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── elk
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── filebeat
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── grafana
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── grafana_vars.yaml
│   ├── httpd
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── howto.txt
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   ├── httpd.j2
│   │   │   ├── wordpress.j2
│   │   │   └── www.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── httpd.yaml
│   ├── mysql
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   ├── conf.d.master
│   │   │   │   ├── 01-base.cnf
│   │   │   │   ├── 02-max-connections.cnf
│   │   │   │   ├── 03-performance.cnf
│   │   │   │   ├── 04-slow-query.cnf
│   │   │   │   └── 05-binlog.cnf
│   │   │   └── conf.d.slave
│   │   │       ├── 01-base.cnf
│   │   │       ├── 02-max-connections.cnf
│   │   │       ├── 03-performance.cnf
│   │   │       ├── 04-slow-query.cnf
│   │   │       └── 05-binlog.cnf
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   ├── my_master.j2
│   │   │   └── my_slave.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── mysql.yaml
│   ├── nginx
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── ssl
│   │   │       ├── certs
│   │   │       │   ├── ca-bundle.crt
│   │   │       │   ├── ca-bundle.trust.crt
│   │   │       │   ├── dhparam.pem
│   │   │       │   ├── make-dummy-cert
│   │   │       │   ├── Makefile
│   │   │       │   ├── nginx-selfsigned.crt
│   │   │       │   └── renew-dummy-cert
│   │   │       └── private
│   │   │           └── nginx-selfsigned.key
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   ├── templates
│   │   │   ├── nginx.j2
│   │   │   └── ssl.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── nginx.yaml
│   ├── node_exporter
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yaml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   ├── templates
│   │   │   └── node_exporter.service.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── node_exporter_vars.yaml
│   ├── ntpd
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── ntp.conf
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── php_fpm
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── www.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── phpfpm.yaml
│   ├── prometheus
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yaml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   ├── prometheus.j2
│   │   │   └── prometheus.yml.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── prometheus_vars.yaml
│   ├── ssl
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   └── wordpress
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── howto.txt
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   └── main.yml
│       ├── templates
│       │   ├── wordpress.j2
│       │   └── wp-config.php.j2
│       ├── tests
│       │   ├── inventory
│       │   └── test.yml
│       └── vars
│           └── httpd.yaml
├── site.yaml
├── ssl_commands
├── storage
│   ├── cluster2.vdi
│   ├── cluster3.vdi
│   └── cluster.vdi
└── Vagrantfile

```
Ниже приводится описание ролей в плейбуке:

1.  [all_nodes_tasks](https://github.com/DmitryV81/Diplom_PRO/tree/main/roles/all_nodes_tasks)
