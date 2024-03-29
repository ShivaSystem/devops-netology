# Домашнее задание к занятию ""5.4. Практические навыки работы с Docker
## Задача 1

Измените базовый образ предложенного Dockerfile на Arch Linux c сохранением его функциональности.

```
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:vincent-c/ponysay && \
    apt-get update
 
RUN apt-get install -y ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```

## Решение
* Написанный вами Dockerfile (https://github.com/ShivaSystem/devops-netology/blob/79084db7de66899b6154fcca06992740984553e3/HW_5.4_Docker/Dockerfile)
```
FROM archlinux:latest
RUN pacman -Syu --noconfirm ponysay
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey. netology!"]
```

* Скриншот вывода командной строки после запуска контейнера из вашего базового образа
  * ![Вывод после запуска контейнера](/HW_5.4_Docker/ponysay.png)

* Ссылку на образ в вашем хранилише DockerHub
  * https://hub.docker.com/r/shiva2913/archnetology

## Задача 2
* Amazoncorretto jenkins
  * Наполнение Dockerfile (https://github.com/ShivaSystem/devops-netology/blob/79084db7de66899b6154fcca06992740984553e3/HW_5.4_Docker/Dockerfile_corretto)

```
FROM amazoncorretto 

ADD https://pkg.jenkins.io/redhat-stable/jenkins.repo /etc/yum.repos.d/
RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

ADD https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm /home
WORKDIR /home
RUN rpm -Uvh epel-release*rpm 1>/dev/null 2>/dev/null
RUN yum install -y daemonize jenkins 1>/dev/null 2>/dev/null

CMD ["java","-jar","/usr/lib/jenkins/jenkins.war"]
```
  * Скриншот лога запущенного контейнера
![Screenshot](/HW_5.4_Docker/corretto-jenkins_log.png)

  * Скриншот запущенного web-интерфейса
![Screenshot web](/HW_5.4_Docker/corretto-jenkins_webpage.png)

  * Ссылка на DockerHub (https://hub.docker.com/r/shiva2913/corretto-jenkins)


* ubuntu jenkins
  * Наполнение Dockerfile (https://github.com/ShivaSystem/devops-netology/blob/ef730ce7be94c6f2ce7a850df3c609337525e243/HW_5.4_Docker/Dockerfile_ubuntu)

```
FROM ubuntu:latest
ADD https://pkg.jenkins.io/debian-stable/jenkins.io.key ./
RUN apt-get update 2>/dev/null 1>/dev/null
RUN apt-get install -y gpg gpg-agent ca-certificates && \
    cat jenkins.io.key | apt-key add - && \
    echo "deb https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update 2>/dev/null 1>/dev/null
RUN apt-get install -y openjdk-11-jdk openjdk-11-jre jenkins

CMD ["java","-jar","/usr/share/jenkins/jenkins.war"]
```
  * Скриншот лога запущенного контейнера
![Screenshot](/HW_5.4_Docker/ubuntu_jenkins_log.png)

  * Скриншот запущенного web-интерфейса
![Screenshot web](/HW_5.4_Docker/ubuntu_jenkins_webpage.png)

  * Ссылка на DockerHub (https://hub.docker.com/r/shiva2913/ubuntu_jenkins)

## Задание 3

* Наполнение Dokerfile с npm приложением
```
FROM node
RUN apt-get update
RUN git clone https://github.com/simplicitesoftware/nodejs-demo.git
WORKDIR /nodejs-demo/
RUN npm install -g nodemon
RUN npm install -g npm@7.5.1
RUN npm install
RUN sed -i "s/localhost/0.0.0.0/g" app.js
CMD ["npm","start"]
```

* Скриншот вывода вызова команды списка docker сетей (docker network cli)
![Скриншот docker сетей](/HW_5.4_Docker/docker_networkspng.png)
![Скриншот](/HW_5.4_Docker/docker_network.png)

* Скриншот вывода curl
![Скриншот вывода curl](/HW_5.4_Docker/curl.png)
