# Домашнее задание к занятию "5.2. Системы управления виртуализацией"
## Задача 1
Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

* 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований
Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий
  * В данном сценарии можно использовать ProxMox(QEMU/KVM, OpenVZ) или VMWare. Оба продукта обладают всеми необходимыми функциями. Но я бы свой выбор сделал на Proxmox.
* Требуется наиболее производительное бесплатное opensource решение для виртуализации небольшой (20 серверов) инфраструктуры Linux и Windows виртуальных машин
  * Я бы использовал KVM (Например Proxmox). Регулярно использую в работе. Имеется возможность паравиртуализации, автоматизированного резервного копирования, кластеризации и много чего еще. 
* Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры
  * В этом случае однозначно Hyper-V
* Необходимо рабочее окружение для тестирование программного продукта на нескольких дистрибутивах Linux
  * Тут можно использовать что больше нравится (VirtualBox, VMWare Workstation, QEMU/KVM, OpenVZ или Docker если использовтаь контейнеры)

## Задача 2
Опишите сценарий миграции с VMware vSphere на Hyper-V для Linux и Windows виртуальных машин. Детально опишите необходимые шаги для использования всех преимуществ Hyper-V для Windows.

1. Перенести образы дисков виртуальных машин на хост HyperV
2. Конвертировать vmdk в vhd
3. Создание виртуальных машин и добавление им образов дисков
После переноса виртуальных машин, для Windows систем будут доступны функции Host Live migration, Storage Live Migration, горячее добавлеение и изменение RAM, пзу.

## Задача 3

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был бы выбор, то создавали ли вы бы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

### Ответ

По моему мнению  нужно стараться избегать построения гетерогенной среды виртуализации. В первую очередь нам будет необходимо несколько физических серверов, которые будут работать по отдельности. В то время как используя одну систему виртуализации на обоих серверах мы могли бы использовать кластеризацию, живую миграцию и могли бы обеспечить высокую доступность виртаульных машин. Также в случае автоматизации каких либо процессов в системах виртуализации с помощью внешних скриптов, придется писать несколько версий скриптов учитывая специфику каждой системы виртуализации. Также у разных систем виртуализации будут разные форматы дисков. И в целом по моему мнение, управлять гомогенными инфраструктурами легче, за счет полной совместимости продуктов и за счет того что можно сконцентрироваться на изучении и управлении конкретным продуктом.  В случае если бы у меня был выбор, я бы не стал строить гетерогенную среду виртуализации. Но в случае острой необходимости, нужно в первую очередь очень хорошо подумать, стоит ли делать гетерогенную среду. 
