## Case

1. 首先把服务器上的代码克隆下来

   * ```shell
     git clone git@192.168.200.109:snailå/GitTest.git
     ```

   * ```shell
     # 刚克隆下来的是在master分支，可以通过命令行或者IDE工具查看当前分支
     git branch
     ```
   
   * ![image-20211206172533676](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206172533676.png)
   
2. 将所有有改动的全部添加到要提交的本地库中

   * ```shell
     git add .
     ```

   * ```shell
     # 也可以用git add 文件名进行单独文件的提交
     git add test.md
     ```

3. 将修改提交到本地库

   * ```SHELL
     git commit -am "提交添加的注释信息"
     ```

4. 将本地库的commit推送到远程服务器

   * ```shell
     git push 
     ```

   * ![image-20211206171744082](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211206171744082.png)