### 新建仓库

* 新建仓库入口有两个
  * ![image-20211206144841398](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206144841398.png)

* 新仓库的相关配置，根据自己的需求进行相关配置的设置。（附：新建仓库的配置）
  * ![image-20211206145031123](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145031123.png)

  * ![image-20211206145055400](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145055400.png)

* 创建仓库后，根据相关提示进行仓库的初始化等工作

  * 建议使用 clone 的方式进行repository的初始化工作 （HTTP和SSH方式二选一）

    * ```shell
      git clone http://gitea.conti.net/libokang/test_Repository.git  # HTTP
      ```

    * ```shell
      git clone git@gitea.conti.net:test/test_Repository.git # SSH
      ```

  * 或者使用本地初始化库的方式，通过页面提示信息进行操作（附：新库的提示操作信息image）

    * ![image-20211206145500669](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145500669.png)

* 这样一个新的仓库就创建成功了







* other

  * SSH的方式需要向Gitea提供自己机器的ssh公钥信息
  * 点击头像  Settings --> 

  * ![image-20211206150432130](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206150432130.png)
  * pass
  * 1. 点击`SSH/GPG Keys` 
    2. 点击`Add Key`
    3. 将自己的公钥信息复制到该窗口，然后点击绿色那个`Add Key`

* ![image-20211206150829005](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206150829005.png)

* 这是添加成功的image
  * ![image-20211206151305302](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206151305302.png)