## 用户账户注册验证操作

* 向管理员提供邮箱地址进行Gitea账户的新建（暂时不对外开放注册功能）。

* 管理员审核通过后，用户提供的邮箱会收到注册通知的邮件，然后点击相关的登录页面链接即可验证
  （账号为邮箱名，默认密码：AAaa1234 ，第一次登录需要修改密码）
  
  * ![image-20211206163530844](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206163530844.png ':size=1600*900')
  
  * ![image-20211206163659258](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206163659258.png ':size=1600*900')
  * ![image-20211206164224233](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206164224233.png ':size=1600*900')

## User add SSH

* SSH的方式需要向Gitea提供自己机器的ssh公钥信息
* 点击头像  --> Settings
  
  1. 点击头像旁下拉菜单栏
  2. 点击`Settings`按钮进行下一步操作
     * ![image-20211207150435206](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211207150435206.png)
  
  3. 点击`SSH/GPG Keys`
  4. 点击`Add Key`
  5. 将自己的公钥信息复制到该窗口，然后点击绿色那个`Add Key`完成添加SSH Keys的操作
     * ![image-20211207150634336](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211207150634336.png)
  6. 这是添加成功的截图
     * ![image-20211206151305302](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206151305302.png)