# shell-commands

### clean files 3 days ago
* ```shell
  find /root/database/backup/db.sql.*.gz -mtime +3 -exec rm {} \;
  ```

### ssh without affect $HOME/.ssh/known_hosts
* ```shell
  ssh -o "UserKnownHostsFile /dev/null" root@aliyun.geekcity.tech
  ```

### rsync file to remote
* ```shell
  rsync -av --delete \
      -e 'ssh -o "UserKnownHostsFile /dev/null" -p 22' \
      --exclude build/ \
      $HOME/git_projects/blog root@aliyun.geekcity.tech:/root/develop/blog
  ```

### looking for network connections
* ```shell
  ## all connections
  lsof -i -P -n
  ## specific port
  lsof -i:8083
  ```

### sync clock
* ```shell
  yum install -y chrony \
      && systemctl enable chronyd \
      && systemctl is-active chronyd \
      && chronyc sources \
      && chronyc tracking \
      && timedatectl set-timezone 'Asia/Shanghai'
  ```

### settings for screen
* ```shell
  cat > $HOME/.screenrc <<EOF
  startup_message off
  caption always "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%H %Y/%m/%d "
  escape ^Jj #Instead of control-a
  shell -$SHELL
  EOF
  ```

### count code lines
* ```shell
  find . -name "*.java" | xargs cat | grep -v ^$ | wc -l
  git ls-files | while read f; do git blame --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -n
  git log --author="ben.wangz" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }' -
  ```

### check sha256
* ```shell
  echo "1984c349d5d6b74279402325b6985587d1d32c01695f2946819ce25b638baa0e *ubuntu-20.04.3-preinstalled-server-armhf+raspi.img.xz" | shasum -a 256 --check
  ```

### check command existence
* ```shell
  if type firewall-cmd > /dev/null 2>&1; then 
      firewall-cmd --permanent --add-port=8080/tcp; 
  fi
  ```

### set hostname
* ```shell
  hostnamectl set-hostname develop
  ```

### add remote key
* ```shell
  ssh -o "UserKnownHostsFile /dev/null" root@aliyun.geekcity.tech "mkdir -p /root/.ssh && chmod 700 /root/.ssh && echo '$SOME_PUBLIC_KEY' >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys"
  ```

### check service logs with journalctl
* ```shell
  journalctl -u docker
  ```

### script path
* ```shell
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  ```

### 修改密码
* ```shell
  echo '123456' | passwd --stdin conti
  ```

### 两台节点互信
* ```shell
  echo ${RSA} >> ~/.ssh/authorized_keys
  ```

### SSH 参数
* ```shell
  # 警告信息
  -o "StrictHostKeyChecking no"
  
  # 主机已存在
  -o "UserKnownHostsFile /dev/null"
  ```

### JAVA_HOME配置文件
* ```shell
  JAVA_HOME=/opt/jdk1.8.0_301
  JRE_HOME=$JAVA_HOME/jre
  CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar
  PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
  export JAVA_HOME JRE_HOME CLASSPATH PATH
  ```

### while循环文件读取
* ```shell
  ls | while read remote;
  do
  echo ${remote}
  done
  ```
