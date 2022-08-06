# Домашнее задание к занятию "5.3. Контейнеризация на примере Docker"
## Задача 1
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование докера? Или лучше подойдет виртуальная машина, физическая машина? Или возможны разные варианты?"

Сценарии:

* Высоконагруженное монолитное java веб-приложение;
  * В случае высоконагруженного монолитного приложения, думаю лучшим выбором будет baremetal или паравиртуализация.
* Go-микросервис для генерации отчетов;
  * Для Go-микросервиса, отлично подойдет Docker. 
* Nodejs веб-приложение;
  * Docker должен быть не плохим выбором в данном сцерии, если только нет особых требований к производительности.
* Мобильное приложение c версиями для Android и iOS;
  * Docker не подходит для данного сценария. Судя по информации в интернете, в Docker можно запустить приложение с графическим интерфейсом, но я бы лучше использовать виртуальные машины.
* База данных postgresql используемая, как кэш.
  * Думаю что базу данных используеют как кэш для получения наиболее быстрого доступа к часто используемым данным, если это так то лучше использовать железный сервер с высокопроизводительной дисковой подсистемой. Даже в случае если нет таких жестких требований к производительности, по моему мнению Docker мало подходит для этой цели.
* Шина данных на базе Apache Kafka;
  * C Apache Kafka не знаком. По найденной информации в интернете, в этом сценарии успешно используют Docker.
* Очередь для Logstash на базе Redis;
  * В этом сценарии Docker отлично подойдет. Так как даже есть официальный Docker Image
* Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana 
  * Докер должен отлично подойти в данном сценарии.
* Мониторинг-стек на базе prometheus и grafana;
  * Docker также отлично подойдет
* Mongodb, как основное хранилище данных для java-приложения;
  * В данном сценарии думаю лучше использовать виртуальные машины.
* Jenkins-сервер. 
  * Docker будет хорошим решением. Также есть официальный Docker Image


## Задача 2
* Для установки Docker использовал следующие команды:

```console
$ sudo apt-get remove docker docker-engine docker.io containerd runc
$ sudo apt-get update
$ sudo apt-get install     apt-transport-https     ca-certificates     curl     gnupg     lsb-release
$ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```console
$ sudo docker pull httpd
$ sudo docker run -dit --name apache -p 80:80 httpd
$ sudo docker exec -it apache /bin/bash
```

Затем создал и отредактировал файл htdocs/index.html 

```console
# docker commit -m "httpd image for Netology" -a "Vladimir Sakhnov" 0a94c845e9b8 httpd:latestnew
# docker tag 0a94c845e9b8 shiva2913/httpd:latestnew
# docker login
# docker push shiva2913/nginx:latestnew
```

### Ссылка на DockerHub
https://hub.docker.com/r/shiva2913/httpd


## Задача 3

* Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /share/info контейнера;

```console	
# docker pull centos
# docker run -dit --name CentOS1 -v /home/user/info:/share/info centos:latest 
```

* Запустите второй контейнер из образа debian:latest в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /info контейнера;

![Вывод "docker container ps"](/HW_5.3_Docker/docker_ps.png)

* Подключитесь к первому контейнеру с помощью exec и создайте текстовый файл любого содержания в /share/info ;

```console
root@doker5:~## docker exec -it 9b5edca124dd /bin/bash
[root@9b5edca124dd /]# echo "First file for home work" > /share/info/first_file
```

* Добавьте еще один файл в папку info на хостовой машине;

```console
root@doker5:~# echo "Second file for netology" > /home/user/info/second_file
```

* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /info контейнера.

```console
root@doker5:~# docker exec -it b6b14f1ffff9 /bin/bash
```
	
![ls](/HW_5.3_Docker/ls_info_deb.png)
