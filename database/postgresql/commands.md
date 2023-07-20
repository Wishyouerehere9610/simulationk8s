## postgresql commands

### 创建用户
* ```postgresql
  CREATE ROLE "role-crawler-rw";
  
  GRANT "role-crawler-rw" TO "conti";
  
  GRANT Connect, Create, Temporary ON DATABASE "crawler" TO "role-crawler-rw";
  
  GRANT Create, Usage ON SCHEMA "public" TO "role-crawler-rw";
  
  GRANT Delete, Insert, References, Select, Trigger, Truncate, Update ON ALL TABLES IN SCHEMA PUBLIC TO "role-crawler-rw";
  
  ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT Delete, Insert, References, Select, Trigger, Truncate, Update ON TABLES TO "role-crawler-rw";
  ```
  
