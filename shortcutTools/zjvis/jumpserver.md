## jumpserver

### 主要用途及待解决需求
* 堡垒机，即在一个特定的网络环境下，为了保障网络和数据不受来自外部和内部用户的入侵和破坏，而运用各种技术手段监控和记录运维人员对网络内的服务器、网络设备、安全设备、数据库等设备的操作行为，以便集中报警、及时处理及审计定责.
* 堡垒机就是用来后控制哪些人可以登录哪些资产（事先防范和事中控制），以及录像记录登录资产后做了什么事情（事溯源）
* 智哥要求使用审计功能(这部分智哥补充)

### 依赖
* `mariadb`
* `redis`

### 安装过程
* [jumpserver](https://nebula-ops.lab.zjvis.net/#/ops-dev/application/jumpserver)
    + `https://nebula-ops.lab.zjvis.net/#/ops-dev/application/jumpserver`

### 使用过程(管理员角度)
1. 用户管理
    * 新增用户
2. 资源管理
    * 新增资源(linux)
    * 新增资源账号
    * 资源赋权操作
3. 审计操作
    * 会话审计
    * 命令审计
    * 文件传输审计
    
### 使用过程(用户角度)
1. 用户管理
    - []用户登录
    * 用户完善个人信息
    * 用户完善public key 信息 (包含使用ssh登录jumpserver的操作)
2. 资源管理
    * linux资源 (演示使用web终端登录linux资源)
    * mysql资源 (演示使用web终端登录mysql资源)
    * redis资源 (演示使用web终端登录redis资源)
3. web终端
    * 文件上传 (默认/tmp)
    * RDP操作(web终端的复制粘贴功能)


