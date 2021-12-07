## New repository

* 仓库的新建在默认页（个人主页）拥有两个入口，视个人情况进行选择。
  * ![image-20211206144841398](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206144841398.png)

* New repository 的相关配置，根据自己的需求济宁进行个性化设置。（附：新建仓库的配置）

  * Owner 选择自己（无管理权限者无法创建组织仓库）
  * Repository Name 根据项目名称进行填写

  * ![image-20211206145031123](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145031123.png)

  * ![image-20211206145055400](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145055400.png)

* 创建仓库后，根据相关提示进行仓库的初始化等工作

  * 建议使用 clone 的方式进行repository的初始化工作 （HTTP和SSH方式二选一）
    SSH 需要 [add_ssh_keys](add_ssh_keys.md)

    * ```shell
      # HTTP
      git clone http://gitea.conti.net/libokang/test_Repository.git
      # SSH
      git clone git@gitea.conti.net:test/test_Repository.git # SSH
      ```

  * 或者使用本地初始化库的方式，通过页面提示信息进行操作（附：新库的提示操作信息image）

    * ![image-20211206145500669](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206145500669.png)

* 这是一个创建成功的仓库
  * ![image-20211206165955740](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206165955740.png)

## Setting repository

* 如果repository创建时某些配置项需要修改，那么我们可以在仓库的设置中进行修改
1. 首先找对自己的库，并点击需要修改的库，进入到仓库的页面
  * ![image-20211206152638016](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206152638016.png)
2. 点击右上方区域的`Settings`按钮
  * ![image-20211206152846471](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206152846471.png)
3. 然后寻找想要修改的配置项，根据您实际情况进行相关配置项的修改
  * ![image-20211206170529757](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206170529757.png)

* 仓库的删除操作
  * ![image-20211206170720045](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206170720045.png)
