## mysql command

### 用户及权限
* 创建用户
    + ```sql
      CREATE USER 'user_name'@'host' IDENTIFIED BY 'password';
      -- user_name 用户名
      -- host ["localhost", "0.0.0.0", "%"]
      -- password 密码，不写则为无密码登录
      -- CREATE USER 'conti_mysql'@'%' IDENTIFIED BY 'AAaa1234';
      ```
* 删除用户
    + ```sql
      DROP USER 'user_name'@'host';
      -- user_name 用户名
      -- host ["localhost", "0.0.0.0", "%"]
      -- DROP USER conti_mysql;
      ```
* 设置与更改用户密码
    + ```sql
      ## 设置指定主机指定用户的密码
      SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');
      -- SET PASSWORD FOR 'conti_mysql'@'%' = PASSWORD('CCcc1234');
      ## 设置当前用户的密码
      SET PASSWORD = PASSWORD('newpassword');
      -- SET PASSWORD = PASSWORD('CCcc1234');
      ```
* 授权用户
    + ```sql
      GRANT privileges ON databasename.tablename TO 'username'@'host';
      -- privileges 授予权力 ["select", "insert", "update", "..."] 全部则为 "all"
      -- datbasename 赋权的库 全部则为 "*"
      -- tablename 赋权的表 全部则为 "*"
      -- 'username'@'host' 用户          
      
      -- 给用户conti_mysql授权在test库的person表上执行insert和select的权利
      grant select, insert ON test.person TO 'conti_mysql'@'%';
         
      -- 给用户conti_mysql授权在所有库所有表的所有的权力。       
      grant all on *.* TO 'conti_mysql'@'%'; 
         
      -- 操作MySQL外键权限。
      grant references on testdb.* to 'conti_mysql'@'192.168.0.2';
         
      -- 操作MySQL临时表权限。
      grant create temporary tables on testdb.* to 'conti_mysql'@'192.168.0.2';
         
      -- 操作MySQL索引权限。
      grant index on testdb.* to 'conti_mysql'@'192.168.0.2';
         
      -- 操作 MySQL视图、查看视图源代码权限。
      grant create view on testdb.* to 'conti_mysql'@'192.168.0.2';
      grant show view on testdb.* to 'conti_mysql'@'192.168.0.2';
         
      -- 操作MySQL存储过程、函数 权限。
      grant create routine on testdb.* to 'conti_mysql'@'192.168.0.2'; 
      grant alter routine on testdb.* to 'conti_mysql'@'192.168.0.2'; 
      grant execute on testdb.* to 'conti_mysql'@'192.168.0.2';
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

### 表结构操作
* 新增字段
    + ```sql
      ALTER TABLE `concept_extractor`
        ADD `post_concept_id` varchar(255) DEFAULT NULL,
        ADD `pre_concept_id` varchar(255) DEFAULT NULL;
      ```
* 删除字段
    + ```sql
      ALTER TABLE `algorithm_server` 
          DROP `universal_user_id`;
      ```
* 修改字段
    + ```sql
      ALTER TABLE `attribute_extractor` 
          MODIFY `attribute_extractor_id` bigint(20) NOT NULL;
      ```
