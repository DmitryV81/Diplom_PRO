wordpress
=========

Установка и настройка CMS Wordpress. Установка производится на одну ВМ backend1 в смонтированный в директорию /var/www/html каталог сетевого кластерного хранилища GlusterFS.

С последующим распространением через подключение сетевого хранилища на ВМ backend2 и frontend (для синхронизации файлов)

Важное замечание!
------------

Поскольку wordpress содержит материалы (css, javascript) в формате ссылок к ним по незащищенному протоколу http, то во всех браузерах получаем ошибку загрузки смешанного содержимого (https - основной протокол и http-ссылки для загрузки контента и стилей). В результате разметка страницы "ползет",меню не работает и картинки не отображаются должным образом.

Для избежания этого необходимо внести корректировку в файл wp-config.php:

В конец файла добавить следующее содержимое

```
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
```

Несколько скриншотов
------------
![Deploy Wordpress1](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/w1.png)
![Deploy Wordpress2](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/w2.png)
![Deploy Wordpress3](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/w3.png)
![Deploy Wordpress4](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/w4.png)
![Deploy Wordpress5](https://github.com/DmitryV81/Diplom_PRO/blob/main/pictures/w5.png)


Example Playbook
----------------
```
---
- name: Download and unpack latest WordPress
  unarchive:
    src: https://wordpress.org/latest.tar.gz
    dest: "/var/www/html"
    remote_src: yes
    extra_opts: [--strip-components=1]
    #creates: "/var/www/html/"

- name: chown user "apache"
  shell: "chown -R apache.apache /var/www/html/"
...
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
