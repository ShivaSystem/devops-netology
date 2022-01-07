# Решение домашнего задания  к занятию "6.3. MySQL"
## Задача 1
```
docker run --name 6.3MySQL -v ~/6.3MySQL:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:8
```

```
docker exec -i 6.3MySQL sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_db' < /root/6.3MySQL/test_dump.sql
```
### Статус сервера
Server version:         8.0.27 MySQL Community Server - GPL

```
mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		12
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.27 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			20 min 55 sec

Threads: 2  Questions: 58  Slow queries: 0  Opens: 171  Flush tables: 3  Open tables: 89  Queries per second avg: 0.046
--------------
```

### Вывод списка таблиц базы test_db:

```
mysql> show tables from test_db;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

### Вывод price > 300:

```
mysql> use test_db;
Database changed
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```



## Задача 2

### Создание пользователя

```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> FAILED_LOGIN_ATTEMPTS 3
    -> PASSWORD EXPIRE INTERVAL 180 DAY 
    -> ATTRIBUTE '{"name": "James", "lastname": "Pretty"}';
Query OK, 0 rows affected (0.02 sec)
```

### Модификация прав

```
mysql> GRANT SELECT on test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```

### Данные о пользователе test

```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+-----------------------------------------+
| USER | HOST      | ATTRIBUTE                               |
+------+-----------+-----------------------------------------+
| test | localhost | {"name": "James", "lastname": "Pretty"} |
+------+-----------+-----------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

### Установка SET profiling = 1;

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
+----------+------------+----------------+
| Query_ID | Duration   | Query          |
+----------+------------+----------------+
|        1 | 0.00018900 | show profilesl |
+----------+------------+----------------+
1 row in set, 1 warning (0.00 sec)
```

### Запрос чтобы узнать какой движок используется

```
mysql> select TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.01 sec)
```

### Изменение движка у таблицы orders на MyISAM и вывод времени выполнения

```
mysql> alter table orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.07 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00018900 | show profilesl                                                                          |
|        2 | 0.00482900 | select TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
|        3 | 0.07328575 | alter table orders ENGINE = MyISAM                                                      |
|        4 | 0.00015700 | mysql> alter table orders ENGINE = MyISAM                                               |
|        5 | 0.11375900 | alter table orders ENGINE = InnoDB                                                      |
+----------+------------+-----------------------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)

```

## Задача 4

```
root@df15ee488502:/# cat >> /etc/mysql/conf.d/netology.conf 
#Скорость IO важнее сохранности данных
# В данном случае я использовал innodb_flush_log_at_trx_commit, можно использовать значение 2(даст приемлемую производительность и приемлемую безопасность данных) или 0 (Даст максимальную производительность, но сильно увеличит 
# вероятность потери данных 
innodb_flush_log_at_trx_commit = 2
#Нужна компрессия таблиц для экономии места на диске
innodb_file_per_table = 1
#Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1M
#Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size = 1460M #контейнеру с mysql выделено 2G 
#Размер файла логов операций 100 Мб
innodb_log_file_size = 100M
```
