# README




## Zeppelin的问题(已经下掉了)

* 王智(武夷（王智）)
    ```text
    @杨博Aaron Zeppelin 我们看一下，刚刚发现backend 启动的时候会检查Zeppelin，如果连不上会block 初始化
    ```
* 杨博Aaron(杨博Aaron)
  
      嗯 那是一个定时任务检查
      可以去掉
  
* 王智(武夷（王智）)

      Zeppelin 还承担一些功能吧？

* 杨博Aaron(杨博Aaron)

      没了  就只有 老的自定义算子用

* 王智(武夷（王智）)

      也就是说Zeppelin 已经可以下掉了？

* 罗实(罗实)

      zeppelin按计划下掉 @杨博Aaron @王芷霖  
        
      收到 王芷霖(王芷霖)

* 王智(武夷（王智）)

      @王芷霖  @李炜铭  一起确认下？
      如果可以下掉了就删掉代码吧，这样我们也不用写Zeppelin 的搭建文档了
        
      收到 王芷霖(王芷霖)

* 李炜铭(李炜铭)

      「 [@武夷（王智）](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) ：@王芷霖  @李炜铭  一起确认下？
      如果可以下掉了就删掉代码吧，这样我们也不用写Zeppelin 的搭建文档了 」
      \--------
      下掉吧

* 王智(武夷（王智）)
  
        @王芷霖  @杨博Aaron  下午我们碰一下，Zeppelin 下午就处理掉，下午我好再测一下。整体时间比较紧


* 杨博Aaron(杨博Aaron)

      @王智(武夷（王智）)   我自己本地先屏蔽了 测一下 没问题了给你说
      
      收到 王智(武夷（王智）)



## CDH离线安装(资源放到 resource.static.zjvis.net，已找IT解决内网域名解析问题)



* 张恒

      @罗实(罗实)  CDH现在只能离线安装了，离线安装的话，那些离线安装包怎么提供给用户

* 王智(武夷（王智）)

        @张恒 需要哪些包？我这有一个对外开放的存储服务（nginx）
        能压缩成一个或几个tar.gz 么？

* 罗实(罗实)

        我记得有个对外下载的地址？@武夷（王智）

* 张恒(张恒)
  
        武夷（王智）:
        能压缩成一个或几个tar.gz 么？ 
        \--------
        @王智(武夷（王智）) 可以的，我去整理一下

* 王智(武夷（王智）)

        @罗实 https://resource.static.zjvis.net/ 对，就是这个

* 罗实(罗实)

      那就挂这个静态资源吧 @张恒 @王智(武夷（王智）) 
        
      收到 张恒(张恒)

* 王智(武夷（王智）)

      @罗实  https://resource.static.zjvis.net/ 对，就是这个
      实验室内网访问要加 echo 10.105.20.20 resource.static.zjvis.net >> /etc/hosts 公网访问不用
  
* 罗实(罗实)

      好

* 罗实(罗实)

      这个cdh的安装文档为啥和图片一起放在resource下？@张恒 


* 张恒

      张恒(张恒)
        
      罗实:
        
      这个cdh的安装文档为啥和图片一起放在resource下？@张恒  
      /--------
      @罗实(罗实) 王智放的@王智(武夷（王智）) 

* 王智(武夷（王智）)

      罗实:
      
      这个cdh的安装文档为啥和图片一起放在resource下？@张恒  
      
      @罗实  我放的，再增加一个目录结构么？
      
      收到 罗实(罗实)


## 账号密码的问题(已剥离)

* 罗实(罗实)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCuHAXbHHNBsbNCVCwmAJr5wEvpX0B1SFhdsClAA_2384_1734.png_720x720q90g.jpg?bizType=im)
* 罗实(罗实)
  
      天枢的yaml配置包括了实验室dev环境的ip和一些secret key
  
* 罗实(罗实)

      我们yaml的ip配置也可以暴露dev的地址，没问题的，一些关键的password都改下比如123456。代码中的一些ip尽量提到yaml中



## restful.jobServer.address 配置问题（默认null && 引擎不是spark的时候不用，这里遗留了一个待解决问题，但不影响opensource）

* 王智(武夷（王智）)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCxfmBa2_NBJ7NBP6wXPBjTCfQdG0B1TePTUClAA_1278_1182.png_720x720q90g.jpg?bizType=im)
* 王智(武夷（王智）)

      这个还有用么？@杨博Aaron @王芷霖
      block 启动过程

* 杨博Aaron(杨博Aaron)

      如果引擎是spark 还是要用的
      如果是GP 是不用



## bean循环依赖(已解决)

* 王智(武夷（王智）)
  
  * org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'widgetRenderController': Unsatisfied dependency expressed through field 'taskService'; nested exception is org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'taskService': Unsatisfied dependency expressed through field 'datasetCategoryService'; nested exception is org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'datasetCategoryService': Unsatisfied dependency expressed through field 'projectService'; nested exception is org.springframework.beans.factory.BeanCurrentlyInCreationException: Error creating bean with name 'projectService': Bean with name 'projectService' has been injected into other beans [jlabService] in its raw version as part of a circular reference, but has eventually been wrapped. This means that said other beans do not use the final version of the bean. This is often the result of over-eager type matching - consider using 'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.
  
* 罗实(罗实)

      bean循环依赖

* 杨博Aaron(杨博Aaron)

      jlabService 和 projectService 要改一下
      我看了一下 确实都能用mapper

* 王智(武夷（王智）)

      杨博Aaron:
      我看了一下 确实都能用mapper
      \--------
      @杨博Aaron  改完推到opensource 哈，我合一下代码
      
      收到 杨博Aaron(杨博Aaron...



## apollo的类没删除干净（已解决）

* 王智(武夷（王智）)
  
  * ![img](https://static.dingtalk.com/media/lQLPDhsCy65qWHDNAYzNCk6wt4hrI3lAGHEB1UDpfwAvAA_2638_396.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)

      谁把这个删掉了？

* 罗实(罗实)

      伟明删的，这个是apollo的类

* 王智(武夷（王智）)

      嗯，查到了
      @李炜铭  没删干净，这个config 实例已经没有用了

* 王智(武夷（王智）)

      datascience-algo/src/main/java/org/zjvis/datascience/spark/util/Config.java
      @李炜铭  

* 李炜铭(李炜铭)

      我一会删一下

* 杨博Aaron(杨博Aaron)

      我删了 编译测试一下

* 杨博Aaron(杨博Aaron)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCzLEZfJDNAU3NA26w_20cKdHUTEAB1UKRGACkAA_878_333.png_720x720q90g.jpg?bizType=im)


* 杨博Aaron(杨博Aaron)

      https://git.zjvis.org/bigdata/aiworks/merge_requests/1033 

* 王智(武夷（王智）)

      我merge 了


* 王智(武夷（王智）)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCzXxZ9GnNAUjNCbqwNA-TLKhPo6wB1UPdwcAbAA_2490_328.png_720x720q90g.jpg?bizType=im)

## shiro 配置隐私问题（与天枢一样，不用管）
* 王智(武夷（王智）)

      配置文件中这三个的作用是什么？

* 罗实(罗实)

      spring shiro

* 王智(武夷（王智）)

      如果这个公开后，线上是否有风险？
      inner 环境

* 罗实(罗实)

      天枢一样的
      不用管哈

* 王智(武夷（王智）)

      ok 

* 罗实(罗实)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCzcilNGLNBsbNCVCw3zEw6g7KOocB1URaVsD3AA_2384_1734.png_720x720q90g.jpg?bizType=im)
* 王智(武夷（王智）)

      天枢线上部署的也是这个key么？
      我们是不是给opensource 换一个key？

* 罗实(罗实)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCzfCUmEjNAZbNBXSwj189mn54HgsB1UScW8CeAA_1396_406.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCzfEtLjTNAdTNBuawNhNOoYfgsEMB1USc-8AcAA_1766_468.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)

      这个也是

* 王智(武夷（王智）)
  * ![img](https://static.dingtalk.com/media/lQLPDhsCz92Cx7vNAczNBa6wNkt0wNjkoEgB1UfEI4CeAA_1454_460.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)

      opensource 分支 jobServer 配置应该去除，sparkJobServer 缺少 @杨博Aaron 饭后看一下哈


* 王智(武夷（王智）)
  * 2021-12-31 12:37:40.774 [main] WARN  o.s.b.w.s.c.AnnotationConfigServletWebServerApplicationContext - Exception encountered during context initialization - cancelling refresh attempt: org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'widgetRenderController': Unsatisfied dependency expressed through field 'taskService'; nested exception is org.springframework.beans.factory.BeanCurrentlyInCreationException: Error creating bean with name 'taskService': Bean with name 'taskService' has been injected into other beans [jlabService] in its raw version as part of a circular reference, but has eventually been wrapped. This means that said other beans do not use the final version of the bean. This is often the result of over-eager type matching - consider using 'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.
* 王智(武夷（王智）)

      @杨博Aaron 辛苦再看一下
        
      收到 杨博Aaron(杨博Aaron...

* 杨博Aaron(杨博Aaron)

      https://git.zjvis.org/bigdata/aiworks/merge_requests

* 王智(武夷（王智）)

      杨博Aaron:
      
      https://git.zjvis.org/bigdata/aiworks/merge_requests
      /--------
      @杨博Aaron  merged



## aiworks-py （已合并）

* 王智(武夷（王智）)

*     aiworks-py 的代码怎么办？我们打包一个放到resource？
      @罗实
  
* 罗实(罗实)

      @武夷（王智）  两个方案一个是放resource，一个是单独在挂一个工程或子模块

* 王智(武夷（王智）)

      不管哪个方案，都要拉一个分支 opensource，去掉密码 @王芷霖  先拉一个，把密码先搞掉？特别是线上环境
      
      收到 王芷霖(王芷霖)


* 王智(武夷（王智）)

      罗实:
        
      @武夷（王智）  两个方案一个是放resource，一个是单独在挂一个工程或子模块
      /-------
      @罗实  我倾向于后者，你看呢？

* 王智(武夷（王智）)

      使用dev 环境的gp、cdh、flask，前后端都已经起来了，文档还在改

* 罗实(罗实)

      武夷（王智）:
      
      @罗实  我倾向于后者，你看呢？
      /-------
      @武夷（王智）  好，没问题
      按你的想法来就可以~



## 去掉snapshot（已处理）

* 罗实(罗实)

      https://git.zjvis.org/bigdata/aiworks/tree/opensource

* 罗实(罗实)

      核心功能模块第一点加上多源异构数据接入（用目前第四点的图），目前第四点海量数据用例外的示例图

* 罗实(罗实)

      opensource这个分支大家今天再check下，没问题就交付给天枢那边了[@所有人 ](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 

* 罗实(罗实)
  
  * ![img](https://static.dingtalk.com/media/lQLPDhsF3rKhtxM0zQI8sG8j4HsW2N9iAdpKW3SAHAA_572_52.png_720x720q90g.jpg?bizType=im)
  
* 罗实(罗实)

      snapshot我去掉了

* 罗实(罗实)
  * ![img](https://static.dingtalk.com/media/lQLPDhsF37G9VinNBjbNCx6wuUb18SzHfaMB2kv9j4C0AA_2846_1590.png_720x720q90g.jpg?bizType=im)
  
* 罗实(罗实)

      功能介绍这块是不是参考了见微官网的，我看前四个截图都是一样的，但是缺少了后面两个@王智(武夷（王智）)

* 王智(武夷（王智）)

      罗实:
        
      功能介绍这块是不是参考了见微官网的，我看前四个截图都是一样的，但是缺少了后面两个@武夷（王智）  
      /-------
      @罗实  抄宣传海报
        
      收到 罗实(罗实)

* 罗实(罗实)

      ok，我补齐下

* 王智(武夷（王智）)

      嗯~  




## GP数据库初始化问题（已解决）

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsF8d1JPLrNAa7NCRSwaRRJveYdGH8B2mnDKcDwAA_2324_430.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)

      今天改了什么么？后端起来卡在这里了

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsF88tomQfM6M0IsrB3-cTjT2L-dgHabOzvwKcA_2226_232.png_720x720q90g.jpg?bizType=im)
  
* 王智(武夷（王智）)

      还有数据库初始化里面的这一行gp……下午我还要改一下

* 王智(武夷（王智）)

      http://10.101.16.86:8080/
      默认用户
      username: test-nebula
      password: nebula@2021
        
      辛苦各位测一下

* 王智(武夷（王智）)

      武夷（王智）:
      
      还有数据库初始化里面的这一行gp……下午我还要改一下
      
      改完了



## 登录系统构建出来的问题（db少字段，已解决）

* 罗实(罗实)

    * ![img](https://static.dingtalk.com/media/lQLPDhsGAFlKgCLNAXjNDWiwxBKw6wj9_rMB2oF-H0AcAA_3432_376.png_720x720q90g.jpg?bizType=im)

* 罗实(罗实)

      登陆进去点系统构建出来的问题

* 王智(武夷（王智）)

      @罗实(罗实) 这是数据库字段少了



* * 



## 拉自定义算子报错（db 问题，已解决）

* 王芷霖(王芷霖)

      上传数据也有点问题

* 王芷霖(王芷霖)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGAGz15nXNBvrNDFCwkIWDjcBLLUQB2oGeEcD3AA_3152_1786.png_720x720q90g.jpg?bizType=im)    

* 李炜铭(李炜铭)

  * ![img](https://static.dingtalk.com/media/lALPDhJzyurjM-XNAszNDnw_3708_716.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      拉自定义算子报错

* 李炜铭(李炜铭)

  * ![img](https://static.dingtalk.com/media/lALPDiQ3RCLQywrNA5rNA9g_984_922.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      sql一直在loading

* 王智(武夷（王智）)

      sql 更新，升级一下，如果没问题，5分钟内恢复访问

* 王智(武夷（王智）)

      武夷（王智）:
      
      sql 更新，升级一下，如果没问题，5分钟内恢复访问
      
      ERROR 1062 (23000) at line 2: Duplicate entry '1' for key 'PRIMARY' 有问题，我先查一下


* 王智(武夷（王智）)

      INSERT INTO `operator_template` VALUES (1, '自定义算子', 0, 4, 7, '自定义算子', NULL, '', NULL, NULL, 'python', NULL,'[https://nebula-inner.lab.zjvis.net/docs/#/model?id=%e8%87%aa%e5%ae%9a%e4%b9%89%e7%ae%97%e5%ad%90](https://nebula-inner.lab.zjvis.net/docs/#/model?id=自定义算子)', 1, NULL, '2021-5-12 09:49:47', '2021-6-28 18:04:02', 0, 0, '', 'spark', NULL, 2);

* 王智(武夷（王智）)

      @王芷霖  @李炜铭  这个什么作用？

* 王芷霖(王芷霖)

      武夷（王智）:
      
      @王芷霖  @李炜铭  这个什么作用？
      /--------
      @武夷（王智）  旧版的自定义算子，开源没有带的话可以拿掉吧@杨博Aaron  


* 杨博Aaron(杨博Aaron)

      旧版的已经没用了


* 王智(武夷（王智）)

      那我直接删掉了，先删掉试试

* 王智(武夷（王智）)

      数据库按照最新的文件初始化完毕 @all 辛苦看看其他问题



## 数据导入问题(gp 和sftp 配置问题，已解决）

* 李炜铭(李炜铭)

      数据导入还是有问题


* 王智(武夷（王智）)

      @李炜铭  日志再发一下？

* 李炜铭(李炜铭)

  * ![img](https://static.dingtalk.com/media/lALPDgtYzaG6QxPNBiDNBKA_1184_1568.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      sql依然在转圈圈
      自定义算子点编辑算子没有反应


* 王智(武夷（王智）)

      李炜铭:
      
      * ![img](https://static.dingtalk.com/media/lALPDgtYzaG6QxPNBiDNBKA_1184_1568.png_720x720q90g.jpg?bizType=im)
      /-------
      @李炜铭  @张恒  这个是因为gp 连不上么？
  
* 王芷霖(王芷霖)

      李炜铭:
      
      自定义算子点编辑算子没有反应
      /-------
      @李炜铭    @武夷（王智）  这块需要改掉


* 王芷霖(王芷霖)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGDENCvQ_NAlLNBM6wjF1mgj0-EMkB2pUC_cCkAA_1230_594.png_720x720q90g.jpg?bizType=im)

* 张恒

      @王智(武夷（王智）) 看起来是，上传不了gp服务器

* 王智(武夷（王智）)

      @张恒  配置单发你了，我测试过连接，好像是可以的

* 张恒

      @王智(武夷（王智）) 怎么看后台日志，这个前端看到的日志不太行

* 王智(武夷（王智）)

      @张恒  ssh -o 'UserKnownHostsFile /dev/null' root@10.101.16.86  给我一个ssh key

* 王智(武夷（王智）)

      10.101.16.86 这台机器上执行
      /root/git_projects/aiworks/deploy/build/runtime/bin/kubectl -n nebula logs -f nebula-ce-backend-597dd9495-l6fp2

* 张恒

      @王智(武夷（王智）) 发你了

* 王智(武夷（王智）)

      @张恒  可以了，你试试

* 张恒

      @王智(武夷（王智）) 可以了

* 王智(武夷（王智）)
  * 2022-01-04 15:10:33.137 [http-nio-8080-exec-6] ERROR org.zjvis.datascience.service.SftpConnectService - 在GP服务器放入文件失败
    com.jcraft.jsch.SftpException: No such file
            at com.jcraft.jsch.ChannelSftp.throwStatusError(ChannelSftp.java:2629)
            at com.jcraft.jsch.ChannelSftp._put(ChannelSftp.java:545)
            at com.jcraft.jsch.ChannelSftp.put(ChannelSftp.java:491)
            at com.jcraft.jsch.ChannelSftp.put(ChannelSftp.java:454)
            at org.zjvis.datascience.service.SftpConnectService.parseErrorCSVFile(SftpConnectService.java:934)
            at org.zjvis.datascience.service.SftpConnectService$$FastClassBySpringCGLIB$$7d3fa6cf.invoke(<generated>)
            at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)
            at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:769)
            at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
            at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:747)
            at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)
            at org.zjvis.datascience.common.aspect.LogAspect.around(LogAspect.java:77)
            at sun.reflect.GeneratedMethodAccessor125.invoke(Unknown Source)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:498)

* 王智(武夷（王智）)

      来看下

* 王智(武夷（王智）)

      @曾洪海  洪海老师也来看看吧，上面那个gp 的exception

* 王智(武夷（王智）)

      @李炜铭  @曾洪海  更新了，再试试~

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGETQSPczNAWjNAs6wSaQXCKX5HdEB2p0bT4C0AA_718_360.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      可以了

* 李炜铭(李炜铭)

      模型训练一直处于训练中，是不是配置没改好

* 王智(武夷（王智）)

      @All  环境重新部署一下，大概10分钟，为了flask 重新部署，增加了一些功能


* 王智(武夷（王智）)

      已部署完成


* 罗实(罗实)

      试用了下这次丝滑多了

    1条回复

* 王智(武夷（王智）)

      罗实:
      
      试用了下这次丝滑多了
      
      @罗实  单独分配了网络 flask 还需要暴露 minio，我改一下代码，约20分钟后，还要重新搭建一次
      
      收到 罗实(罗实)


  - 1月4日 16:49

* 王智(武夷（王智）)

      武夷（王智）:
        
      @All  环境重新部署一下，大概10分钟，为了flask 重新部署，增加了一些功能
        
      @All  环境再重新部署一下，以暴露minio 给flask

* 王智(武夷（王智）)

      部署完毕



## GP连接第二次问题（ssh 加密算法与jscp 库不兼容，jscp 库版本太低，已解决）

* 李炜铭(李炜铭)

  * ![img](https://static.dingtalk.com/media/lALPDhJzyu4LmkzNBF7NB-Q_2020_1118.png_720x720q90g.jpg?bizType=im)
  
* 李炜铭(李炜铭)

      又上传不了了

* 王智(武夷（王智）)
  * 2022-01-04 18:15:45.623 [http-nio-8080-exec-7] WARN  org.zjvis.datascience.service.SftpConnectService - API /dataset/uploadFiles failed, since 连接GP服务器, 合并文件失败
    2022-01-04 18:15:45.624 [http-nio-8080-exec-7] ERROR o.zjvis.datascience.web.controller.SftpController - previewDataset error DataScienceException:
    org.zjvis.datascience.common.exception.DataScienceException: 连接GP服务器, 合并文件失败
            at org.zjvis.datascience.service.SftpConnectService.uploadFiles(SftpConnectService.java:1572)
            at org.zjvis.datascience.service.SftpConnectService.previewDataset(SftpConnectService.java:2382)
            at org.zjvis.datascience.service.SftpConnectService$$FastClassBySpringCGLIB$$7d3fa6cf.invoke(<generated>)
            at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)
            at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.invokeJoinpoint(CglibAopProxy.java:769)
            at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
            at org.springframework.aop.framework.CglibAopProxy$CglibMethodInvocation.proceed(CglibAopProxy.java:747)
            at org.springframework.aop.aspectj.MethodInvocationProceedingJoinPoint.proceed(MethodInvocationProceedingJoinPoint.java:88)
            at org.zjvis.datascience.common.aspect.LogAspect.around(LogAspect.java:77)
            at sun.reflect.GeneratedMethodAccessor125.invoke(Unknown Source)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:498)

* 王智(武夷（王智）)

      @张恒 @曾洪海  @黄家慧 @黄家慧  

* 曾洪海(曾洪海)

      李炜铭:
      
      又上传不了了
      /-------
      @李炜铭(李炜铭) 之前这个文件可以上传吗？


* 李炜铭(李炜铭)

      曾洪海:
        
      @李炜铭(李炜铭) 之前这个文件可以上传吗？
      /-------
      @* 曾洪海(曾洪海) 可以

* 曾洪海(曾洪海)

      那是不是配置啥的变更了导致的

* 王智(武夷（王智）)

      @曾洪海  改了gp

* 王智(武夷（王智）)

      张恒新搭建了一个gp，把连接换掉了

* 曾洪海(曾洪海)

      新的gp应该有一个目录

* 张恒

      我记得我加上了，@王智(武夷（王智）)  你check一下

* 张恒

      张恒(张恒)
        
      曾洪海:
        
      新的gp应该有一个目录
      /--------
      @* 曾洪海(曾洪海) 是csv_yml这个吗

* 曾洪海(曾洪海)

      gp服务器的目录要和dev环境或者inner环境一致

* 曾洪海(曾洪海)

      估计就是哪个地方配置不同步

* 王智(武夷（王智）)

      张恒:
        
      我记得我加上了，@王智(武夷（王智）) 你check一下
        
      哪个目录？@张恒  

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGKwdrH7_NAUTNBSiwHqIwLODMgJgB2sdrqYD4AA_1320_324.png_720x720q90g.jpg?bizType=im)
  
* 曾洪海(曾洪海)

      @黄家慧(黄家慧)  有空的时候看下需要哪个目录哈

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGKyI9lE3NAz7NAvywRvqD5oMFQEcB2seXtAAFAA_764_830.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGKyI9lE3NAz7NAvywRvqD5oMFQEcB2seXtAAFAA_764_830.png_720x720q90g.jpg?bizType=im)

      password 我隐掉了，其他配置如图

* 曾洪海(曾洪海)

      日志错误栈还有么

* 曾洪海(曾洪海)

      感觉不全

* 王智(武夷（王智）)

      long_text_2022-01-04-18-33-11.txt

* 王智(武夷（王智）)

      这是完整的

* 曾洪海(曾洪海)

      我晚点看一下

* 张恒(张恒)

      这个错误栈里面的真正错误信息被替换掉了吧

* 曾洪海(曾洪海)

      dev和inner环境没这问题

* 曾洪海(曾洪海)

      主要是看下报错那行代码推测下是啥问题哈

* 黄家慧(黄家慧)

      就是合并分块的文件不成功，但是我刚刚看了下这个目录里面都没有文件

* 黄家慧(黄家慧) 黄家慧(黄家慧)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGL5oNvZrMg80CmrC3EjDuLVy9gAHazunHgJAA_666_131.png_720x720q90g.jpg?bizType=im)



* 曾洪海(曾洪海)

      那就是没传过来

* 黄家慧(黄家慧) 黄家慧(黄家慧)

      是的不知道咋回事，需要知道前面的过程。。


* 曾洪海(曾洪海)

      这个环境是不是现在换了gp文件都传不了？


* 曾洪海(曾洪海)

      其他文件呢？

* 张恒

      张恒(张恒)
      
      怀疑sftp的问题，可以从这个方向查一下[@* 曾洪海(曾洪海)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) @黄家慧(黄家慧)  
      
      收到 * 曾洪海(曾洪海)


* 曾洪海(曾洪海)

      连老的gp为啥又可以


* 曾洪海(曾洪海)

      是网络的问题吗

* 张恒

      张恒(张恒)
      
      我说的是服务器，不是我们的代码


* 曾洪海(曾洪海)

      嗯呢

* 张恒

      张恒(张恒)
        
      我记得其它环境有改过ssd_conf文件，@黄家慧(黄家慧)  ，你对比一下新的与我们之前的有什么不一样

* 张恒

      张恒(张恒)
        
      /etc/ssh/sshd_config

* 黄家慧(黄家慧) 黄家慧(黄家慧)

      这配置我打开啥也没。。

* 黄家慧(黄家慧) 黄家慧(黄家慧)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGM1FYAzjNA8TNAtOwQwMBZOiGUpcB2tT_7QCjAA_723_964.png_720x720q90g.jpg?bizType=im)

* 黄家慧(黄家慧) 黄家慧(黄家慧)

      这是啥配置啊，，，明天再看吧

* 黄家慧(黄家慧) 黄家慧(黄家慧)

      如果是sftp问题 ，文件上传过来有问题的话前面upload应该会有报错的

* 张恒

      张恒(张恒)
      
      hao


  - 1月4日 20:18

* 张恒

      张恒(张恒)
        
      问题已解决

* 王智(武夷（王智）)

      啥问题？

* 张恒

      张恒(张恒)
        
      ssh加密算法的问题

* 张恒

      张恒(张恒)
      
      JSchException: Algorithm negotiation fail



## mysql里的GP数据库（upgrade 流程内没有修改db 里面的gp 配置，无法修改，手动解决）

* 张恒

      张恒(张恒)
      
      @王智(武夷（王智）)  mysql里面的gp数据库配置明天也改一下，我刚刚试了，那个配置不对
      
      收到 王智(武夷（王智）)


* 李炜铭(李炜铭)

      gp不能访问了，是不是配置改了[@张恒(张恒)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 

    10条回复

* 杨娟娟(杨娟娟)

      可视化构建这边500了

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGqKEk45jNBQrNCPywKP3t9ZE5eNYB25U0XED3AA_2300_1290.png_720x720q90g.jpg?bizType=im)

* 张恒

      张恒(张恒)
        
      李炜铭:
        
      gp不能访问了，是不是配置改了@张恒(张恒) 
        
      @李炜铭(李炜铭) 应该是王智没改mysql里的gp配置@王智(武夷（王智）) 

* 王智(武夷（王智）)

      张恒:
        
      @李炜铭(李炜铭) 应该是王智没改mysql里的gp配置@王智(武夷（王智）) 
        
      @张恒(张恒) @李炜铭(李炜铭) 你有mysql的连接信息，跟张恒一起改一下吧

* 李炜铭(李炜铭)

      武夷（王智）:
        
      @张恒(张恒) @李炜铭(李炜铭) 你有mysql的连接信息，跟张恒一起改一下吧
        
      @王智(武夷（王智）) 改好了 需要重启吧？

* 王智(武夷（王智）)

      李炜铭:
        
      @王智(武夷（王智）) 改好了 需要重启吧？
        
      @李炜铭(李炜铭) 数据库不需要吧

* 李炜铭(李炜铭)

      武夷（王智）:
        
      @李炜铭(李炜铭) 数据库不需要吧
        
      @王智(武夷（王智）) 那我还是连不了

* 张恒

      张恒(张恒)
        
      武夷（王智）:
        
      @李炜铭(李炜铭) 数据库不需要吧
        
      @王智(武夷（王智）) 需要吧，要不然每次连接都初始化

* 李炜铭(李炜铭)

      李炜铭:
        
      @王智(武夷（王智）) 那我还是连不了
        
      删了重新配现在可以连了

* 王智(武夷（王智）)

      @李炜铭  @张恒 重启了

* 王智(武夷（王智）)

      李炜铭:
        
      删了重新配现在可以连了
        
      @李炜铭  你这个应该发生在我之前

* 李炜铭(李炜铭)

      武夷（王智）:
        
      @李炜铭  你这个应该发生在我之前
        
      @王智(武夷（王智）) 对

* 王智(武夷（王智）)

      后端现在还没初始化完毕

* 王智(武夷（王智）)

      好了

* 张恒

      张恒(张恒)
        
      武夷（王智）:
        
      @李炜铭  你这个应该发生在我之前
        
      @王智(武夷（王智）) 炜铭说的是本地客户端

* 张恒

      张恒(张恒)
        
      现在有了


* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGq_KCoK3NAzbNDTCwARQXBLlp_XsB25qjfYAGAA_3376_822.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      这个错误可以忽略么？

* 李炜铭(李炜铭)

      可以

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGq_3Vy6TNAljNCcyw70bY2C6uLUkB25q1ykCjAA_2508_600.png_720x720q90g.jpg?bizType=im)



* 杨博Aaron(杨博Aaron)

      那不是说 有个表不在么 _country_mapper_啥的


* 杨博Aaron(杨博Aaron)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGrCLKQAE6zQaAsI-pT4RcoC4FAdua8xaApQA_1664_58.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      那是推荐的时候需要的，还没有传到gp上

* 张恒

      张恒(张恒)
      
      你们不要传过大的文件，我们新的单机gp机器配置有点拉
  



* 杨博Aaron(杨博Aaron)

      哈哈哈 好

* 王智(武夷（王智）)

      @All  还有其他问题没？


* 贾琼莹(贾琼莹)
        
  
      这个环境，注册不了新用户？
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGrhzVXiTNBWvNBQOwaZjPfWSz-mAB254v18C0AA_1283_1387.png_720x720q90g.jpg?bizType=im)



* 杨博Aaron(杨博Aaron)

      不能注册  只能用默认账户 


* 杨博Aaron(杨博Aaron)

      没有配 阿里云短信的key


* 杨博Aaron(杨博Aaron)

      发不出去的

* 贾琼莹(贾琼莹)
      
  
      大家都用同一个账户，不会踢出去么？




* 杨博Aaron(杨博Aaron)

      目前是没有的  

* 贾琼莹(贾琼莹)
      
  
      哦~~


  - 1月5日 11:35

## 上传大文件失败的问题（是gp 内存问题，换了物理机解决）

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzKvxbdrNBvTNCuCwoPd1ZunIVrcB29BA6UAGAA_2784_1780.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      上传大文件是不行？230Ｍ
  
* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzRYKEr_NA5rNCqawiL9eXJHXBVgB29DuqMCQAA_2726_922.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzRv_9L3NBsDNCyew-I5ScJnW_j4B29D5BEC0AA_2855_1728.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      其他的文件导入总是报这个
  
* 贾琼莹(贾琼莹)
        
  
      数据导不进去哇～～谁看下
  
* 王智(武夷（王智）)

      @黄家慧  @曾洪海  @张恒 
  



* 曾洪海(曾洪海)

      ？
  



* 曾洪海(曾洪海)

      这个提示说的不明确吗？

* 贾琼莹(贾琼莹)
      
  
      DEV环境上的数据，之前导入都没有问题的




* 曾洪海(曾洪海)

      那可能gp版本不同导致的？
  



* 曾洪海(曾洪海)

      文件麻烦贴一下哈 我这边验证下inner和dev环境的

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzXos1xbNBnDNC8-wMbDaxhU7yZMB29GTA4BCAA_3023_1648.png_720x720q90g.jpg?bizType=im)



* 曾洪海(曾洪海)

      看来是其他的问题

* 贾琼莹(贾琼莹)
        
  
      download_学生年龄统计_Sheet1.csv
  
* 王智(武夷（王智）)

      内存爆了吧？我重启一下看看

* 王智(武夷（王智）)

      @贾琼莹 再试试，看看是不是同样的错误


* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzfH7AW_NBkLNDaywwjeLuXTphfoB29JW_0CQAA_3500_1602.png_720x720q90g.jpg?bizType=im)
    

* 杨娟娟(杨娟娟)

      这个数据库连不上

* 王智(武夷（王智）)

      杨娟娟:

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzfH7AW_NBkLNDaywwjeLuXTphfoB29JW_0CQAA_3500_1602.png_720x720q90g.jpg?bizType=im)

      @杨娟娟  现在还是刚刚？

* 杨娟娟(杨娟娟)

      现在啊

* 曾洪海(曾洪海)

      这个问题是网络不通导致的吗

* 杨娟娟(杨娟娟)

      我刚连接的

* 杨娟娟(杨娟娟)

      ![[尴尬]](http://loc.dingtalk.com/9be848f75838b3994797dbda7b5d1fbb6f2ed8ab6319d8e4a0c87b1281387e07QzpcVXNlcnNcQ29udGlcQXBwRGF0YVxSb2FtaW5nXERpbmdUYWxrXGRlZkVtb3Rpb25cZW1vdGlvbl8wMTEucG5n)

* 杨娟娟(杨娟娟)

      好了

* 王智(武夷（王智）)

      网络是通的

* 杨娟娟(杨娟娟)

      刚试了下，又可以了

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzi2Vy7XNARzNA0qw5JY2Z_gzXBgB29K5A0BCAA_842_284.png_720x720q90g.jpg?bizType=im)



* 曾洪海(曾洪海)

  * ![img](https://static.dingtalk.com/media/lQLPDhsGzjtLUYjM6c0DarBVOHGsI8scCAHb0s-aALQB_874_233.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      我加一下内存，重启后立即满了
  



* 曾洪海(曾洪海)

      搜嘎 

* 王智(武夷（王智）)

      上传百兆级别的数据，竟然要占用好几个G的内存……

* 曾洪海(曾洪海)

      按理说应该不会这样

* 王智(武夷（王智）)

      改好了，再试试，看看还超不超

* 曾洪海(曾洪海)

      之前还特意把jvm调小测试过 没有爆过溢出问题

* 曾洪海(曾洪海)

      这个问题后续再排查下

* 王智(武夷（王智）)

      嗯，opensource 的分支不用排查这个问题，如果调内存能解决的话
        
      收到 * 曾洪海(曾洪海)

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG0P7NJg3NAkrNCwyw0ISlFR4e6TIB29dXJMBAAA_2828_586.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
      武夷（王智）:
        
      @贾琼莹  再试试，看看是不是同样的错误
        
      @王智(武夷（王智）) 是同样的错误

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG0T_FOTbNAUDNClawboqKPQgsjTIB29fBD0CaAA_2646_320.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
      又用完了》！
  
    1条回复

* 王智(武夷（王智）)

      内存上线已经调上去了

* 杨娟娟(杨娟娟)

      我这边上传143M的CSV也上传不上去啊

* 曾洪海(曾洪海)

      不是


* 曾洪海(曾洪海)

      感觉是gp报的错

* 王智(武夷（王智）)

      贾琼莹:
      
      又用完了》！
      
      @贾琼莹  不是，没用完，我怀疑这不是后端的 out of memory


* 曾洪海(曾洪海)

      这个错是SQLException

* 曾洪海(曾洪海)

      我们的进程不会报这个错的哈

* 王智(武夷（王智）)

      @张恒 看下gp 是不是内存不够了？

* 贾琼莹(贾琼莹)
        
  
      查下GC情况？
  
* 王智(武夷（王智）)

      贾琼莹:
        
      查下GC情况？
        
      @贾琼莹  没有gc

* 王智(武夷（王智）)

      4G 都没到呢

* 王智(武夷（王智）)

      纠正一下，没有 full gc

* 贾琼莹(贾琼莹)
      
  
      那，OOM怎么排查


* 曾洪海(曾洪海)

      嗯嗯 因为在本地启动这个 2个G的jvm 传2个g的文件都没问题

* 曾洪海(曾洪海)

      这个不是oom问题哈

* 曾洪海(曾洪海)

      不是java进程内存溢出噢

* 贾琼莹(贾琼莹)
        
  
      哦哦~~~
  
* 曾洪海(曾洪海)

      gp现在重启下看看哈

* 王智(武夷（王智）)

      gp 总内存只有4G，应该是gp 还自己限制了内存大小，机器上还有大量空余内存

* 张恒

      张恒(张恒)
      
      chong qi hao le

* 曾洪海(曾洪海)

      但建表应该和文件大小无关

* 贾琼莹(贾琼莹)
      
  
      我再试下
  
* 曾洪海(曾洪海)

      是不是新的gp配置和之前的不一样

* 贾琼莹(贾琼莹)
        
  
      小文件
  
* 张恒

      张恒(张恒)
        
      关键字那个没问题了

* 张恒

      张恒(张恒)
        
      [@贾琼莹(贾琼莹)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 

* 贾琼莹(贾琼莹)
        
  
      传是传上去了
  
* 贾琼莹(贾琼莹)
        
  
      queryDataById接口一直pending
  
* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG0lWHLfvNAVTNCQywozMmaVFxo5oB29mH_gC8AA_2316_340.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lALO3QWeL8y2zMM_195_182.png?bizType=im)



* 曾洪海(曾洪海)

      是的

* 贾琼莹(贾琼莹)
        
  
      queryAllUserDataSetDTO也是一直pending
  
* 贾琼莹(贾琼莹)
        
  
      完了，有返回了
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG0_KWly7NASvNBuqwIii9DNmUQrsB29wtIkCaAA_1770_299.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG0_MvLr3NA2rNCDiw0fNvUUy9l8IB29wucwAJAA_2104_874.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1AKudl_NAt7NCjywJgOqflYUbxUB29xHQQAHAA_2620_734.png_720x720q90g.jpg?bizType=im)
 - 1月5日 14:42

* 王智(武夷（王智）)

      @曾洪海  重启好了
      
      收到 * 曾洪海(曾洪海)
  



* 曾洪海(曾洪海)

      现在预览数据正常了
  



* 曾洪海(曾洪海)

      @贾琼莹(贾琼莹)你那边ok了么


* 杨娟娟(杨娟娟)

      502什么鬼

* 贾琼莹(贾琼莹)

      曾洪海:
        
      @贾琼莹(贾琼莹) 你那边ok了么
        
      @* 曾洪海(曾洪海) 好了

* 杨娟娟(杨娟娟)

      遇见2回了

* 罗实(罗实)

      @杨娟娟(杨娟娟) 把错误信息贴出来

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1HNVlBXNBBTNB3awvzU7arucM4MB290AUUAJAA_1910_1044.png_720x720q90g.jpg?bizType=im)

* 罗实(罗实)

      研发同学好排查下

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1HxGZW_NAsTNDhawoLRnZiywUsgB290O6kBmAA_3606_708.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      @张恒 这是目录不对？

    1条回复

* 张恒

      张恒(张恒)
      
      武夷（王智）:
      
      @张恒  这是目录不对？
      
      @王智(武夷（王智）) @* 曾洪海(曾洪海) 看看
  
* 曾洪海(曾洪海)

      这个错误可以忽略

* 曾洪海(曾洪海)

      但是gpload仍然执行不了

* 曾洪海(曾洪海)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1J2nUCPNAtnNAzSwx_TKXknhh_YB291FEsCcAA_820_729.png_720x720q90g.jpg?bizType=im)

* 杨娟娟(杨娟娟)

      罗实:
        
      @杨娟娟(杨娟娟)  把错误信息贴出来
        
      @罗实  502网关错误，接口没得返回

* 王智(武夷（王智）)

      又有创建表失败了

* 罗实(罗实)

      杨娟娟:
        
      @罗实  502网关错误，接口没得返回
        
      @杨娟娟  王智你看下这个问题，是不是k8s服务暴露相关@武夷（王智）  

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1MDSAKXNBw7NDCawdzTH04gYwlcB291_EUC0AA_3110_1806.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
      我刚上传的的

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1MM0WnDNAgrNCtKw8tKnLKMvUHEB292C7YCcAA_2770_522.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      罗实:
      
      @杨娟娟  王智你看下这个问题，是不是k8s服务暴露相关@武夷（王智）  
      
      @罗实  不是，502，肯定是后端服务给的
  
* 曾洪海(曾洪海)

      新的gp 内存有点小 create table会直接失败

* 曾洪海(曾洪海)

      还没到gpload就失败了

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG1RV1e4HNBCjNCaCw1F1EMjShsKwB294JhQC2AA_2464_1064.png_720x720q90g.jpg?bizType=im)

* 杨娟娟(杨娟娟)

      GP又连不上了么？

* 曾洪海(曾洪海)

      嗯嗯 gp性能有点跟不上哈

* 曾洪海(曾洪海)

      连接被占满了

* 王智(武夷（王智）)

      嗯，应该是gp 性能问题

* 张恒

      张恒(张恒)
        
      这台单机gp性能太差

* 王智(武夷（王智）)

      gp 重新搭到物理机上再测了 @杨娟娟 @贾琼莹 测试先暂停吧，再测没意义了
        
      收到 杨娟娟(杨娟娟)，贾琼莹(贾琼莹)

* 王智(武夷（王智）)

      10.105.20.43
      @王芷霖  @李炜铭  这是新的gp，其他都不变
        
      收到 李炜铭(李炜铭)

* 王智(武夷（王智）)

      后端重启完了，你们重启完了同步一下哈

* 张恒

      张恒(张恒)
        
      如果用到host name 请换成gp-03
        
      收到 王智(武夷（王智）)

* 张恒

      张恒(张恒)
        
      数据库别忘了换一下

* 张恒

      张恒(张恒)
        
      @王智(武夷（王智）)  

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG39OeAbrNAhjNCdiwNpp4PuQBi40B2--jOEC8AA_2520_536.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      改了，也重启了

* 李炜铭(李炜铭)

      flask起来了

    1条回复

* 张恒

      张恒(张恒)
        
      可以用了

* 张恒

      张恒(张恒)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG4CN8yefNAy_NCyGwIkzmsP1ONJoB2_AmrAAJAA_2849_815.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      李炜铭:
      
      flask起来了
      
      @李炜铭  芷霖这一部分是不是跟flask 一起的？

* 曾洪海(曾洪海)

      刚试了一些大文件 上传很6

* 曾洪海(曾洪海)

      之前无法建表的问题没有出现了

* 张璠璠(张璠璠)

      @王智(武夷（王智）) 前端依赖更新了，重新部署下吧
        
      收到 王智(武夷（王智）)

* 贾琼莹(贾琼莹)
        
  
      就等你们了
  
* 王智(武夷（王智）)

      我重新编译一下前端，稍等

* 王智(武夷（王智）)

      @张璠璠  .npmrc 这个文件可能还得存在，公网太慢了，加一个阿里云吧

* 王智(武夷（王智）)

      前端更新ing，理论上无影响

* 王智(武夷（王智）)

      更新完毕

    2条回复

* 张璠璠(张璠璠)

      武夷（王智）:
        
      更新完毕
        
      @武夷（王智）  现在访问环境还是公告里的环境么？

* 王智(武夷（王智）)

      张璠璠:
        
      @武夷（王智）  现在访问环境还是公告里的环境么？
        
      @张璠璠  嗯

* 王智(武夷（王智）)

      @All  换了gp 以后都没发现问题了么？
        
      收到 
        
      收到
        
      回复

* 贾琼莹(贾琼莹)
        
  
      暂时木有
  
* 王智(武夷（王智）)

  ​    

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lALO3QWeL8y2zMM_195_182.png?bizType=im)

* 王智(武夷（王智）)

      感动

* 贾琼莹(贾琼莹)
        
  
      [@李炜铭(李炜铭)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG5x3WslbNBEXNCJKwutG0VDJ5OUEB2_uVQsC0AA_2194_1093.png_720x720q90g.jpg?bizType=im)
 - 1月5日 16:58

* 贾琼莹(贾琼莹)
        
  
      通用插补
  
* 贾琼莹(贾琼莹)
        
  
      可能数据量太大了
  
* 李炜铭(李炜铭)

      对，内存不足

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG6A_VYRPNBOnNCGiwXyEat0Q0c9QB2_0hpsC-AA_2152_1257.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      udf没有注册

* 贾琼莹(贾琼莹)
        
      是不是又挂了
  
    1条回复

* 王智(武夷（王智）)

      贾琼莹:
        
      是不是又挂了
        
      @贾琼莹  哪个组件挂了？

* 贾琼莹(贾琼莹)
        
  
      卡死了页面，没反应
  
* 王智(武夷（王智）)

      前后端服务都正常

* 曾洪海(曾洪海)

      是不是你那边浏览器没反应了

* 贾琼莹(贾琼莹)
        
  
      是的
  
* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG6YDJSQ3NBrLNCb6wUd1NBFX2lgcB2_9-S4C0AA_2494_1714.png_720x720q90g.jpg?bizType=im)

    2条回复

* 王智(武夷（王智）)

      图的部分？

* 贾琼莹(贾琼莹)
      
  
      新开一个页面就好了


  - [王智(武夷（王智）)](dingtalk://dingtalkclient/page/profile?profile=%40kgDOABVXdQ&cid=43857777041)邀请[钱超逸(钱超逸)](dingtalk://dingtalkclient/page/profile?profile=%40kgDOGTscEQ&cid=43857777041)加入群聊

* 贾琼莹(贾琼莹)
        
      不是图，没看图。。。
  
    1条回复

## cassadnra闲置后会报的那个（不影响opensource流程，不解决）

* 王智(武夷（王智）)

      武夷（王智）:

  * ![img](https://static.dingtalk.com/media/lQLPDhsG6YDJSQ3NBrLNCb6wUd1NBFX2lgcB2_9-S4C0AA_2494_1714.png_720x720q90g.jpg?bizType=im)

      @钱超逸  这个异常看下

* 王智(武夷（王智）)

      贾琼莹:
        
      不是图，没看图。。。
        
      @贾琼莹  日志只发现这一个exception

* 超逸

      钱超逸(钱超逸)
        
      武夷（王智）:
        
      @钱超逸  这个异常看下
        
      这个是cassadnra闲置后会报的那个，再次激活查询就会正常了，还没有解决怎么不显示这个expcetion，目前不影响功能@王智(武夷（王智）) 
        
      收到 王智(武夷（王智）)

## 算子有问题的 UDF没装（已解决）

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsG67JDE_nNBLjNCH6wiZvBRsVXlQQB3AMWFQA4AA_2174_1208.png_720x720q90g.jpg?bizType=im)

    1条回复

* 杨娟娟(杨娟娟)

      @李炜铭  算子有问题

* 贾琼莹(贾琼莹)
        
      杨娟娟:

  * ![img](https://static.dingtalk.com/media/lQLPDhsG67JDE_nNBLjNCH6wiZvBRsVXlQQB3AMWFQA4AA_2174_1208.png_720x720q90g.jpg?bizType=im)

      @杨娟娟(杨娟娟) 已经反馈过了，UDF没装

* 杨娟娟(杨娟娟)

      哦哦

* 王智(武夷（王智）)

      稍等，我来搞一下

* 贾琼莹(贾琼莹)
        
  
      嗯嗯，先弄好，明天再来看下~
  
* 王智(武夷（王智）)

      @李炜铭  验证完，群里说一声哈

## 算子能执行但是结果没有显示（已解决）
* 李炜铭(李炜铭)

  * ![img](https://static.dingtalk.com/media/lALPDiQ3RDGMthXNBD7NC1I_2898_1086.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)

      现在能执行但是结果没有显示 @杨博Aaron(杨博Aaron) 你知道有可能是什么原因吗


  - 1月5日 18:14

* 杨博Aaron(杨博Aaron)

      把target  去掉？


* 杨博Aaron(杨博Aaron)

      [@李炜铭(李炜铭)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 

* 李炜铭(李炜铭)

      可以了，上次就出现过我忘了。。。

* 李炜铭(李炜铭)

      通用算子都没问题了

## 频繁挖掘算子的报错（flask 经常挂的问题，已解决）

* 杨娟娟(杨娟娟)

      @李炜铭  看下这个频繁挖掘算子的报错

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHcnAQ5JTNA6jNB9awePICItJ7vHUB3N_YkcA0AA_2006_936.png_720x720q90g.jpg?bizType=im)

* 李炜铭(李炜铭)
        
  
      @杨娟娟(杨娟娟) 试一下同样数据dev有没有问题
  
* 杨娟娟(杨娟娟)
        
  
      @李炜铭  Dev没有问题哦，用的同一份数据


* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHdH3HaifNBXTNDFmwOLkFR2crNkoB3OM2HABCAA_3161_1396.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)

      看下这个HTTP数据导入到页面，
  
* 张璠璠(张璠璠)
        
  
      @贾琼莹  上传不成功？
  
* 贾琼莹(贾琼莹)
        
  
      页面不对
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHdN5WpijNBJLNBhGwYP7ZnrEsyecB3OPTvABAAA_1553_1170.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      应该是这样的
  
* 张璠璠(张璠璠)

      正在看

* 杨娟娟(杨娟娟)

      @王智(武夷（王智）) 看下这个问题，好像服务间没有联通

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHdbHvW0fNAobNCgKwkz9rdcbqa5cB3OUvQwAvAA_2562_646.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      @王芷霖  是不是flask 服务挂了

* 贾琼莹(贾琼莹)
        
  
      是
  
* 贾琼莹(贾琼莹)
        
  
      已经好了
  
* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHdsqsQHLNAy7NCsKwBTkjL5YeCpwB3Ob7CEAGAA_2754_814.png_720x720q90g.jpg?bizType=im)

* 杨娟娟(杨娟娟)

      我这还报错呢

* 李炜铭(李炜铭)

      模拟推演都不要管

* 杨娟娟(杨娟娟)

      👌

* 张璠璠(张璠璠)

      贾琼莹:
        
      看下这个HTTP数据导入到页面，
        
      @贾琼莹  已经可以了
        
      收到* 贾琼莹(贾琼莹)

## 自定义算子获取不到数据（中文乱码问题，不解决）

* 杨娟娟(杨娟娟)

      @王芷霖  @李炜铭  自定义算子获取不到数据

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHd8Fvol7NBEbNCDywKBrq-23Rf5AB3OiO2YC0AA_2108_1094.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHeAcsa37NBJXNCU-w545W4NrynNMB3OkBgwBAAA_2383_1173.png_720x720q90g.jpg?bizType=im)


* 杨娟娟(杨娟娟)

      @王芷霖  自定义算子返回的csv文件还有中文乱码的问题

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHeAvxHmzNBgjNBMywSLUMyGO-Y3sB3OkIqsC5AA_1228_1544.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      这俩连线连起来，报错
  
* 贾琼莹(贾琼莹)
        
  
      好像DEV上也有这个问题。。。


* 王智(武夷（王智）)

      贾琼莹:
        
      好像DEV上也有这个问题。。。
        
      @贾琼莹  转bug吧，dev 上修复，opensource 这次就不管了
        
      收到* 贾琼莹(贾琼莹)

* 王芷霖(王芷霖)

      杨娟娟:

  * ![img](https://static.dingtalk.com/media/lQLPDhsHd8Fvol7NBEbNCDywKBrq-23Rf5AB3OiO2YC0AA_2108_1094.png_720x720q90g.jpg?bizType=im)

      @杨娟娟  这个是jupyterlab的问题，在平台节点中可以加载csv数据到节点的

* 杨娟娟(杨娟娟)

      王芷霖:
        
      @杨娟娟  这个是jupyterlab的问题，在平台节点中可以加载csv数据到节点的
        
      @王芷霖  那现在这个环境有问题能解决么？

* 王智(武夷（王智）)

      王芷霖:
        
      @杨娟娟  这个是jupyterlab的问题，在平台节点中可以加载csv数据到节点的
        
      @王芷霖  dev 正常么？

* 王智(武夷（王智）)

      或者，inner 正常么？

* 杨娟娟(杨娟娟)

      Dev正常的

* 贾琼莹(贾琼莹)
        
  
      HTTP数据导入，这个是不是网络不通


* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHeVm6VynNA8rNBaGw_8K6HvPgRskB3OssBAALAA_1441_970.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      贾琼莹:
        
      HTTP数据导入，这个是不是网络不通
        
      @贾琼莹  导出成curl 给我一下

* 王智(武夷（王智）)

      端口号没有

* 王智(武夷（王智）)

      端口号8080 @贾琼莹

* 贾琼莹(贾琼莹)
        
  
      HTTP导入没用过端口号
  
* 王智(武夷（王智）)

      不带端口号，等于默认端口80，这个环境的服务在8080

* 王芷霖(王芷霖)

      杨娟娟:

  * ![img](https://static.dingtalk.com/media/lQLPDhsHeAvxHmzNBgjNBMywSLUMyGO-Y3sB3OkIqsC5AA_1228_1544.png_720x720q90g.jpg?bizType=im)

      @杨娟娟  中文编码的问题dev解决过，opensource与dev用的代码也一样  我还得再想想为啥

* 王芷霖(王芷霖)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHej4DgTPNAd7NBi6w7c3AyBhJGBcB3OyiREA4AA_1582_478.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      @杨娟娟 编码问题影响整体使用不？

* 王智(武夷（王智）)

      如果不影响，先不修了……没时间了……再看看其他的吧

* 杨娟娟(杨娟娟)

      武夷（王智）:
        
      @杨娟娟  编码问题影响整体使用不？
        
      @武夷（王智）  现在不是中午编码影响使用，是juperlab读取不到数据源的数据这个问题影响使用

* 王智(武夷（王智）)

      杨娟娟:
        
      @武夷（王智）  现在不是中午编码影响使用，是juperlab读取不到数据源的数据这个问题影响使用
        
      @杨娟娟  @王芷霖  看这个吧

* 张恒

      张恒(张恒)
        
      贾琼莹:

  * ![img](https://static.dingtalk.com/media/lQLPDhsHeAcsa37NBJXNCU-w545W4NrynNMB3OkBgwBAAA_2383_1173.png_720x720q90g.jpg?bizType=im)

      @贾琼莹(贾琼莹) dev修复了你看一下

      收到* 贾琼莹(贾琼莹)
  
* 杨博Aaron(杨博Aaron)

      dev也有 先转BUG了

* 贾琼莹(贾琼莹)
        
  
      @张璠璠(张璠璠)
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHfOkVOinNB0zNDCSwK5jpYOTYJ1wB3PEBbMBmAA_3108_1868.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      这个可视化构建的页面，刷新很慢
  
* 贾琼莹(贾琼莹)
        
  
      能看下咋回事么
  
* 贾琼莹(贾琼莹)
        
  
      @张璠璠(张璠璠)
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHfZe5ebLNB4PNCLCwwzIGQ1VDDX8B3PIfDkCdAA_2224_1923.png_720x720q90g.jpg?bizType=im)

* 贾琼莹(贾琼莹)
        
  
      这个搜索查不出来
  
* 张璠璠(张璠璠)

      贾琼莹:
        
      这个搜索查不出来
        
      @贾琼莹  这里貌似只对系统组件做了过滤，dev环境也是的，先不管了
        
      收到* 贾琼莹(贾琼莹)

* 张璠璠(张璠璠)

      贾琼莹:
        
      这个可视化构建的页面，刷新很慢
        
      @贾琼莹  貌似资源加载都有点慢，禁用缓存的情况下，我看dev和inner也是的

* 杨娟娟(杨娟娟)

      @王芷霖  模型训练出来的算子，添加到pipeline上就报错

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHf1WROFPNBbbNDaCwIDpwl3I49GIB3PT5pEBCAA_3488_1462.png_720x720q90g.jpg?bizType=im)

* 杨娟娟(杨娟娟)

      "I/O error on POST request for \"[http://10.101.16.50:5001/ml_model\](http://10.101.16.50:5001/ml_model/)": Connect to 10.101.16.50:5001 [/10.101.16.50]

    1条回复

* 贾琼莹(贾琼莹)
        
  
      感觉是什么又挂了，我昨天测没有问题的
  
* 王智(武夷（王智）)

      connection refused，应该是又挂了

* 张璠璠(张璠璠)

      不过今天加载资源确实有点慢，dev和inner环境![[思考]](http://loc.dingtalk.com/564cda28c274981f783975a4e9a2210fae557e61aaea302815a17b84e4fbaea2QzpcVXNlcnNcQ29udGlcQXBwRGF0YVxSb2FtaW5nXERpbmdUYWxrXGRlZkVtb3Rpb25cZW1vdGlvbl8wNDAucG5n)

* 贾琼莹(贾琼莹)
        
  
      [@张璠璠(张璠璠)](app://desktop.dingtalk.com/web_content/chatbox.html?isFourColumnMode=false#) 
  
* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHf7AqlQvNBlzNC8SwcXLy--IBexwB3PWOnUCdAA_3012_1628.png_720x720q90g.jpg?bizType=im)






* 王智(武夷（王智）)

      杨娟娟:
        
      "I/O error on POST request for \"[http://10.101.16.50:5001/ml_model\](http://10.101.16.50:5001/ml_model/)": Connect to 10.101.16.50:5001 [/10.101.16.50]
        
      @杨娟娟  @王芷霖  再启动一下？

* 贾琼莹(贾琼莹)
        
  
      比较多的问题，1，就是中间件各种挂，2、漏刷脚本。3、遗留问题；4，服务器资源配置比较低
  
* 贾琼莹(贾琼莹)
        
  
      都是环境问题~
  
* 罗实(罗实)

      ![[发呆]](http://loc.dingtalk.com/776b8cee841b4bb958c516eb316025063a5e8b9f32e9b5208a3400be1f0140efQzpcVXNlcnNcQ29udGlcQXBwRGF0YVxSb2FtaW5nXERpbmdUYWxrXGRlZkVtb3Rpb25cZW1vdGlvbl8wMDQucG5n)

* 王智(武夷（王智）)

      还有什么问题提出来了没解决的？跟dev一样的转bug 的不算

* 罗实(罗实)

      中间件各种挂是？@贾琼莹 

    6条回复

* 王智(武夷（王智）)

      flask 吧

* 罗实(罗实)

      有具体的场景嚒，是什么中间件挂的原因有哪些

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHgDukJjXNBKTNDWiwm3SqDjGKu_QB3PZzAsAJAA_3432_1188.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      k8s 内的服务、gp 没挂过

    1条回复

* 王智(武夷（王智）)

      武夷（王智）:
        
      k8s 内的服务、gp 没挂过
        
      gp 迁移到物理机后没挂过

* 杨娟娟(杨娟娟)

      可视化构建发布出去也会提示连接不上

* 贾琼莹(贾琼莹)
        
      罗实:
        
      中间件各种挂是？@贾琼莹  
        
      @罗实(罗实) 1、刚开始的时候，GP资源配置比较低，会挂，后来换了物理机好了；2、FLASK会各种挂，影响一些算子运行和智能推荐的数理统计功能

* 贾琼莹(贾琼莹)
        
  
      Flask挂的原因，暂时还不清楚。。。。
  
* 罗实(罗实)

      贾琼莹:
        
      @罗实(罗实) 1、刚开始的时候，GP资源配置比较低，会挂，后来换了物理机好了；2、FLASK会各种挂，影响一些算子运行和智能推荐的数理统计功能
        
      @贾琼莹  明白，flask的问题@王芷霖  重点关注下

* 贾琼莹(贾琼莹)
        
  
      都是重启解决的
  
* 王芷霖(王芷霖)

      没有后台起，ssh连线掉了，就掉了

* 杨娟娟(杨娟娟)

      罗实:
        
      中间件各种挂是？@贾琼莹  
        
      @罗实  还有JupyterLab这个插件获取不到源数据

* 罗实(罗实)

      我去，python脚本启动都加上后台执行命令“&”，很早就说过了

* 罗实(罗实)

      杨娟娟:
        
      @罗实  还有JupyterLab这个插件获取不到源数据
        
      @杨娟娟  我找芷霖也看下
        
      收到 杨娟娟(杨娟娟)

* 王芷霖(王芷霖)

      杨娟娟:
        
      @罗实  还有JupyterLab这个插件获取不到源数据
        
      @杨娟娟  这个问题不影响平台流程，之前看不到是JupyterLab的原因，不知道为什么现在JupyterLab又可以正常显示了

* 杨娟娟(杨娟娟)

      王芷霖:
        
      @杨娟娟  这个问题不影响平台流程，之前看不到是JupyterLab的原因，不知道为什么现在JupyterLab又可以正常显示了
        
      @王芷霖  这么诡异，那就暂时先这样吧

* 王智(武夷（王智）)

      @贾琼莹 @杨娟娟@罗实  都在了，碰一下？
      
      收到 罗实(罗实)

## 端口8080的问题
* 贾琼莹(贾琼莹)
        
      武夷（王智）:
        
      端口号8080 @贾琼莹  
        
      @王智(武夷（王智）) 这个HTTP数据导入的问题啊，端口号加8080是对的，但是我们系统上的URL是是没有端口号的哈

* 贾琼莹(贾琼莹)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHmmE-KD3NBH_NCwmwRzgT3Yg-80gB3SFJoIC2AQ_2825_1151.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      贾琼莹:
        
      @王智(武夷（王智）) 这个HTTP数据导入的问题啊，端口号加8080是对的，但是我们系统上的URL是是没有端口号的哈
        
      @贾琼莹  @曾洪海  @黄家慧  这个链接是如何生成的？

* 王智(武夷（王智）)

      贾琼莹:
        
      @王智(武夷（王智）) 这个HTTP数据导入的问题啊，端口号加8080是对的，但是我们系统上的URL是是没有端口号的哈
        
      @贾琼莹  这应该是我们以前没考虑到的一个问题
        
      收到* 贾琼莹(贾琼莹)

* 贾琼莹(贾琼莹)
        
      武夷（王智）:
        
      @贾琼莹  这应该是我们以前没考虑到的一个问题
        
      @王智(武夷（王智）) 写死的８０可能。。。。

* 王智(武夷（王智）)

      嗯，我猜是的


* 黄家慧(黄家慧) 黄家慧(黄家慧)

      这个地方问下于淼

* 黄家慧(黄家慧) 黄家慧(黄家慧)

      http导入

* 王智(武夷（王智）)

      武夷（王智）:
        
      @贾琼莹  @曾洪海  @黄家慧  这个链接是如何生成的？
        
      @于淼  

* 于淼

  * ![img](https://static.dingtalk.com/media/lQLPDhsHoAtsfZXNAqjNCXuw_tj4J8zrjLMB3SqP5S60AA_2427_680.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      getServerPort() @于淼 试试能不能获取
        
      收到 于淼(于淼)

* 王智(武夷（王智）)

      把port 也拼上

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHoVM_1UbNBlTNDHqwF4m-uHhbFVIB3SyqZQBCAA_3194_1620.png_720x720q90g.jpg?bizType=im)

* 杨娟娟(杨娟娟)

      开源的问题都记录到TB上了



* 曾洪海(曾洪海)

      如果是正式环境咱们这个url会带上80端口 看上去会不会难看?

* 曾洪海(曾洪海)

      可以试试如果是80则省略哈

* 曾洪海(曾洪海)

      @于淼(于淼)
        
      收到 于淼(于淼)

* 王智(武夷（王智）)

      曾洪海:
        
      可以试试如果是80则省略哈
        
      @曾洪海  加一下规则   如果是http + 80 则省略80；如果是 https + 443 则省略443
        
      收到 * 曾洪海(曾洪海)

* 王智(武夷（王智）)

      @于淼 
        
      收到 于淼(于淼)

* 贾琼莹(贾琼莹)
        
  
      改完了看是不是各个分支都需要改哇～～
  
* 王智(武夷（王智）)

      贾琼莹:
        
      改完了看是不是各个分支都需要改哇～～
      /-------
      @贾琼莹  我去找于淼，会把opensource, production/inner-cluster 和 dev 都修改
        
      收到 贾琼莹(贾琼莹)

* 杨娟娟(杨娟娟)

      @张璠璠  graph+折线图，自动布局之后有问题

* 杨娟娟(杨娟娟)

  * ![img](https://static.dingtalk.com/media/lQLPDhsHpv6fWeXNBsDNC1CwwzTf7uhhKKMB3TX0uYC0AA_2896_1728.png_720x720q90g.jpg?bizType=im)

* 张璠璠(张璠璠)

      杨娟娟:
        
      @张璠璠  graph+折线图，自动布局之后有问题
      /-------
      @杨娟娟  dev上估计也有这个问题吧

* 杨娟娟(杨娟娟)

      张璠璠:
        
      @杨娟娟  dev上估计也有这个问题吧
      /-------
      @张璠璠  我试试，之前没遇到过

* 杨娟娟(杨娟娟)

      张璠璠:
        
      @杨娟娟  dev上估计也有这个问题吧
      /-------
      @张璠璠  Dev也有这个问题

* 张璠璠(张璠璠)

      杨娟娟:
      
      @张璠璠  Dev也有这个问题
      /-------
      @杨娟娟  那先作为bug记录下来吧
      
      收到 杨娟娟(杨娟娟)

* 王智(武夷（王智）)

  * ![img](https://static.dingtalk.com/media/lQLPDhsH3QCEDizNAsjNDEqwcYil2pHN8x8B3Y5w9ABAAA_3146_712.png_720x720q90g.jpg?bizType=im)

* 王智(武夷（王智）)

      http+80, https+443 的省略规则没生效，opensource 先这样吧

  