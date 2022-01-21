### user import

#### prepare

* [connect to aiworks-database](connect.to.aiworks.database.md)

#### insert user 

* ```sql
  insert into user(id, name, email, status, role, gmt_create, gmt_modify, gmt_creator, gmt_modifier, password, phone, remark, date_birth, guide_status) values(2, "test-nebula" ,"", 1, 0, "2021-10-26 13:06:28",  "2021-10-26 13:06:28",  00000000000000000000,   00000000000000000000,   "$2a$10$dUOWNTx0EQ91wSNxu3N4F.Y3G80h76nk2yW67j9riEAAclqxfW4b6", 17863117616, " ","2000-01-01", 0);
  ```
* then your username is `test-nebula`, password is `nebula@2021`