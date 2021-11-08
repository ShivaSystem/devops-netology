# Домашнее задание к занятию "6.2. SQL"
## Задача 1 - 2
docker-compose файл:
```
version: '2.0'
services:
    postgres:
      image: postgres:12.8
      container_name: postgres-netology
      environment:
        - POSTGRES_DB=test_db
        - POSTGRES_USER=test-admin-user
        - POSTGRES_PASSWORD=test-admin-user
      volumes:
        - postgres_data:/var/lib/posgresql/data
        - postgres_backup:/backups
volumes:
    postgres_data:
    postgres_backup:
```

Создание таблицы orders:
```
create table orders(id SERIAL PRIMARY KEY, наименование varchar, цена int);
```

Создание таблицы clients
```
create table clients(id SERIAL PRIMARY KEY, фамилия varchar(25), страна проживания varchar(30), заказ int REFERENCES orders);
```

Создание индекса
```
create index indstrprozhdb on clients("страна проживания");
```

Создание пользователя test-simple-user
```
create user test-simple-user with password 'asdqwe123';
```

Выдача прав пользователю test-simple-user:
```
grant SELECT,INSERT,UPDATE,DELETE on ALL TABLES IN SCHEMA public TO "test-simple-user";
```
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT table_catalog, table_name, grantee, privilege_type FROM information_schema.table_privileges where table_schema = 'public';
```

![baselist](/HW_6.2_SQL/baselist.png)

![descorders.png](/HW_6.2_SQL/descorders.png)

![descorders.png](/HW_6.2_SQL/desclients.png)

![alluserspriv.png ](/HW_6.2_SQL/alluserspriv.png )

## Задача 3
Для наполнение таблиц использовал:
```
insert INTO orders("наименование","цена") values ('Шоколад', 10);
```
###Решение
![from_orders](/HW_6.2_SQL/countorders.png)

![from_client](/HW_6.2_SQL/countclients.png)

## Задание 4
*Приведите SQL-запросы для выполнения данных операций.
  *Для заполнения столбца "заказ" использовал следующие запросы:
```
UPDATE clients SET "заказ"= (select id from orders where "наименование"= 'Книга') where "фамилия" = 'Иванов Иван Иванович';
UPDATE clients SET "заказ"= (select id from orders where "наименование"= 'Монитор') where "фамилия" = 'Петроов Петр Петрович';
UPDATE clients SET "заказ"= (select id from orders where "наименование"= 'Гитара') where "фамилия" = 'Иоганн Себастьян Бах';
```
* Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
  * использовал запрос:
```
select фамилия, наименование from clients inner join orders on orders.id = "заказ";
```

## Задача 5

```
test_db=# explain select фамилия, наименование from clients inner join orders on orders.id = "заказ";
                                   QUERY PLAN                                    
---------------------------------------------------------------------------------
 Nested Loop  (cost=0.15..25.73 rows=4 width=100)
   ->  Seq Scan on clients  (cost=0.00..1.04 rows=4 width=72)
   ->  Index Scan using orders_pkey on orders  (cost=0.15..6.17 rows=1 width=36)
         Index Cond: (id = clients."заказ")
(4 rows)

```
Объяснение:
СУБД составило план запроса, в котором решило последовательно сканировать таблицу client. 
0.00 - приблизительная стоимость запроса. Это время проходящее прежде чем начнется этап вывода данных
1.04 - Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. На практике родительский узел может досрочно прекратить чтение строк дочернего (см. приведённый ниже пример с LIMIT).
rows=4 - Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
width=72 - Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).

Далее СУБД планирует сканировать индекс используя orders_pkey с условием id = clients."заказ"

## Задача 6
делаем дамп базы в каталог для бэкапов
pg_dumpall > /backup/dump_netology.sql

# Останавливаем контейнер
docker stop postgre_netology

# Запускаем контейнер
docker run -v postgres_data:/var/lib/postgresql/data -v postgres_backup:/backup -e POSTGRES_PASSWORD=mysecretpassword -d postgres:12

# Восстановление:
root@728f7c0a9365:/backup# psql -U postgres -f dump_netology.sql

