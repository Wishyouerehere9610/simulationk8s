## mysql command

### 用户及权限
* 增加新用户
    + 增加一个用户conti密码为AAaa1234，让其可以在本机上登录， 并对所有数据库有查询、插入、修改、删除的权限。
    + ```mysql
      GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO conti@localhost Identified BY “AAaa1234”;
      # GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO conti@localhost Identified BY “AAaa1234”;
      ```

### 查看 MySQL 数据的大小
* 查看 mysql 所有数据库的大小
    + ```mysql
      SELECT concat(round(sum(data_length/1024/1024),2),'MB') AS DATA
      FROM information_schema.tables
      WHERE table_schema='aiworks';
      ```
* 查看 mysql 数据库大小
    + ```mysql
      SELECT concat(round(sum(data_length/1024/1024),2),'MB') AS DATA
      FROM information_schema.tables
      WHERE table_schema='aiworks';
      ```
* 查看 mysql 数据库表大小
    + ```mysql
      SELECT concat(round(sum(data_length/1024/1024),2),'MB') AS DATA
      FROM information_schema.tables
      WHERE table_schema='aiworks'
        AND TABLE_NAME='action';
      ```
* 当前数据库实例的所有数据库及其容量大小
    + ```mysql
      SELECT a.SCHEMA_NAME,
             a.DEFAULT_CHARACTER_SET_NAME,
             a.DEFAULT_COLLATION_NAME,
             sum(table_rows) AS '记录数',
             sum(truncate(data_length/1024/1024, 2)) AS '数据容量(MB)',
             sum(truncate(index_length/1024/1024, 2)) AS '索引容量(MB)',
             sum(truncate((data_length+index_length)/1024/1024, 2)) AS '总大小(MB)',
             sum(truncate(max_data_length/1024/1024, 2)) AS '最大值(MB)',
             sum(truncate(data_free/1024/1024, 2)) AS '空闲空间(MB)'
      FROM INFORMATION_SCHEMA.SCHEMATA a
      LEFT OUTER JOIN information_schema.tables b ON a.SCHEMA_NAME=b.TABLE_SCHEMA
      GROUP BY a.SCHEMA_NAME,
               a.DEFAULT_CHARACTER_SET_NAME,
               a.DEFAULT_COLLATION_NAME
      ORDER BY sum(data_length) DESC, sum(index_length) DESC;
      ```
* 占用空间最大的前 10 张表
    + ```mysql
      SELECT a.TABLE_TYPE,
             a.`ENGINE`,
             a.CREATE_TIME,
             a.UPDATE_TIME,
             a.TABLE_COLLATION,
             TABLE_SCHEMA AS '数据库',
             TABLE_NAME AS '表名',
             TABLE_ROWS AS '记录数',
             TRUNCATE (data_length / 1024 / 1024, 2) AS '数据容量(MB)',
             TRUNCATE (index_length / 1024 / 1024, 2) AS '索引容量(MB)',
             TRUNCATE ((data_length + index_length) / 1024 / 1024, 2) AS '总大小(MB)'
      FROM information_schema.TABLES a
      ORDER BY (data_length + index_length) DESC 
      LIMIT 10;
      ```
* 查询数据库对象
    + ```mysql
      SELECT db AS '数据库',
             TYPE AS '对象类型',
             cnt AS '对象数量'
      FROM
        (SELECT 'TABLE' TYPE,
                        table_schema db,
                        count(*) cnt
         FROM information_schema.`TABLES` a
         WHERE table_type='BASE TABLE'
         GROUP BY table_schema
         UNION ALL SELECT 'EVENTS' TYPE,
                                   event_schema db,
                                   count(*) cnt
         FROM information_schema.`EVENTS` b
         GROUP BY event_schema
         UNION ALL SELECT 'TRIGGERS' TYPE,
                                     TRIGGER_SCHEMA db,
                                                    count(*) cnt
         FROM information_schema.`TRIGGERS` c
         GROUP BY TRIGGER_SCHEMA
         UNION ALL SELECT 'PROCEDURE' TYPE,
                                      ROUTINE_SCHEMA db,
                                                     count(*) cnt
         FROM information_schema.ROUTINES d
         WHERE`ROUTINE_TYPE` = 'PROCEDURE'
         GROUP BY db
         UNION ALL SELECT 'FUNCTION' TYPE,
                                     ROUTINE_SCHEMA db,
                                                    count(*) cnt
         FROM information_schema.ROUTINES d
         WHERE`ROUTINE_TYPE` = 'FUNCTION'
         GROUP BY db
         UNION ALL SELECT 'VIEWS' TYPE,
                                  TABLE_SCHEMA db,
                                  count(*) cnt
         FROM information_schema.VIEWS f
         GROUP BY table_schema) t
      ```

### 查看 MySQL 的版本
* ```shell
  mysql -V
  ```
* ```mysql
  SHOW variables LIKE '%version_%';
  ```

### show transaction info

```SQL
select 
    trx_id, 
    trx_started, 
    trx_wait_started, 
    trx_mysql_thread_id, 
    trx_query, 
    trx_operation_state, 
    trx_tables_locked 
from information_schema.INNODB_TRX;
```

### show process

```SQL
show full processlist;
```

### show open tables

```SQL
SHOW OPEN TABLES where `database` = 'my_database';
```

