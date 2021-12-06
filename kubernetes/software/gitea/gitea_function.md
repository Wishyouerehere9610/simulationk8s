# gitea function

* [gitea.config.values](https://docs.gitea.io/en-us/config-cheat-sheet/#overall-default)


## 管理角度
## 基本功能
* Easy upgrade process
* Markdown support
* Integrated Git-powered wiki
* Deploy Tokens
* Repository Tokens with write rights
* External git mirroring

## 优点
* Low resource usage
* Multiple database support
* Multiple OS support
* Orgmode support
* CSV support
* Third-party render tool support

## 缺点
* Static Git-powered pages
* Built-in Container Registry
* Built-in CI/CD
* Subgroups: groups within groups



## 基本功能点
* 仓库管理
  * 仓库描述
* 特性:
  * 支持markwodn
  * 支持Orgmode
  * 外部Git镜像(迁移相关,已禁用)
* 仓库管理:
  * 仓库描述
  * 仓库内代码搜索
  * 全局代码搜索
  * 拒绝未用通过验证的提交
  * 在线代码编辑
  * 分支管理
* issue:
  * issue跟踪
  * issue模板
  * 标签
  * 跟踪时间
  * issuse可有多个负责人
  * 评论反馈
  * issue批量处理
* pull/merge requests:
  * pull/merge requests
  * squash requests
  * 指定pull/merge requests审批人功能
  * 限制某些用户的 push 和 merge 权限
* 第三方工具:
  * 支持 Webhook
  * 自定义 Git 钩子
  * 支持 OpenId 连接
    
  
## 优点:
* 特性
  * 支持多种数据库
  * 支持CSV
  * 支持第三方渲染工具
* 代码管理:
  * 细粒度的用户角色
* Issue:
  * issue依赖
* pull/merge requests
  * squash requests

## 缺点:
* 特性:
  * 无内置CI/CD
  * 无子组织
* 代码管理:
  * 组织里程碑
* issue管理
  * 无关联issues
  * 无私密issues
  * 无锁定评论功能
  * 无issue看板功能
  * issue无法新建分支
  * issue无法全局搜索
  * email无法创建issue
* pull/merge requests
  * 解决merge冲突
  * 回退某些 commits 或 merge request