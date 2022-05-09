# Git

## git config
* ```shell
  git config --global user.name "ben.wangz"                 # 设置名字
  git config --global user.email ben.wangz@foxmail.com      # email
  git config --global pager.branch false                    # flase: git branch 以打印到终端显示   true: 在终端中分页进行显示
  # git config --global pull.ff only
  git --no-pager diff                     
  ```

## commit
* ```shell
  # HEAD~1 撤销一次  HEAD~2  撤销两次
  git reset --soft HEAD^ # 撤销上次的commit
  ```

## 同步远程和本地remote
* ```shell
  git remote prune origin
  ```

## get specific file from remote
* from remote: git@github.com:ben-wangz/blog.git
* from branch: master
* from path: docs/commands
* specific file: git.md
* write as tar gz file: git.md.tar.gz
* ```shell
  git archive --remote=git@github.com:ben-wangz/blog.git master:docs/commands build.gradle -o git.md.tar.gz
  ```

