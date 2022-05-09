### clean files 3 days ago

```shell
find /root/database/backup/db.sql.*.gz -mtime +3 -exec rm {} \;
```

### ssh without affect $HOME/.ssh/known_hosts

```shell
ssh -o "UserKnownHostsFile /dev/null" root@aliyun.geekcity.tech
```

### rsync file to remote

```shell
rsync -av --delete \
    -e 'ssh -o "UserKnownHostsFile /dev/null" -p 22' \
    --exclude build/ \
    $HOME/git_projects/blog root@aliyun.geekcity.tech:/root/develop/blog
```

### looking for network connections

* all connections
    + ```shell
      lsof -i -P -n
      ```
* specific port
    + ```shell
      lsof -i:8083
      ```

### sync clock

```shell
yum install -y chrony \
    && systemctl enable chronyd \
    && systemctl is-active chronyd \
    && chronyc sources \
    && chronyc tracking \
    && timedatectl set-timezone 'Asia/Shanghai'
```

### settings for screen

```shell
cat > $HOME/.screenrc <<EOF
startup_message off
caption always "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%H %Y/%m/%d "
escape ^Jj #Instead of control-a

shell -$SHELL
EOF
```

### count code lines

```shell
find . -name "*.java" | xargs cat | grep -v ^$ | wc -l
git ls-files | while read f; do git blame --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -n
git log --author="ben.wangz" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }' -
```

### check sha256

```shell
echo "1984c349d5d6b74279402325b6985587d1d32c01695f2946819ce25b638baa0e *ubuntu-20.04.3-preinstalled-server-armhf+raspi.img.xz" | shasum -a 256 --check
```

### check command existence

```shell
if type firewall-cmd > /dev/null 2>&1; then 
    firewall-cmd --permanent --add-port=8080/tcp; 
fi
```

### set hostname

```shell
hostnamectl set-hostname develop
```

### add remote key

```shell
ssh -o "UserKnownHostsFile /dev/null" root@aliyun.geekcity.tech "mkdir -p /root/.ssh && chmod 700 /root/.ssh && echo '$SOME_PUBLIC_KEY' >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys"
```

### check service logs with journalctl

```shell
journalctl -u docker
```

### script path

```shell
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
```

### 修改密码
```shell
#
echo '123456' | passwd --stdin conti

#
echo '123456' | 
```

### 两台节点互信
```shell
echo ${RSA} >> ~/.ssh/authorized_keys
```

### SSH 参数
```shell
# 警告信息
-o "StrictHostKeyChecking no"

# 主机已存在
-o "UserKnownHostsFile /dev/null"
```

# JAVA_HOME配置文件
JAVA_HOME=/opt/jdk1.8.0_301
JRE_HOME=$JAVA_HOME/jre
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME JRE_HOME CLASSPATH PATH

# 镜像库localhost:5000
for IMAGE in "conti2021.icu/sshd:0.1.4"
do
LOCAL_IMAGE="localhost:5000/$IMAGE"
docker image inspect $IMAGE || docker pull $IMAGE
docker image tag $IMAGE $LOCAL_IMAGE
docker push $LOCAL_IMAGE
done


# prepare directories
IMAGE_FILE_DIRECTORY_AT_HOST=docker-images/$TOPIC_DIRECTORY
IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE=/root/docker-images/$TOPIC_DIRECTORY
mkdir -p $IMAGE_FILE_DIRECTORY_AT_HOST
SSH_OPTIONS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ssh $SSH_OPTIONS -p 10022 root@localhost "mkdir -p $IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE"

for IMAGE_FILE in $IMAGE_LIST
do
IMAGE_FILE_AT_HOST=docker-images/$TOPIC_DIRECTORY/$IMAGE_FILE
IMAGE_FILE_AT_QEMU_MACHINE=$IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE/$IMAGE_FILE
if [ ! -f $IMAGE_FILE_AT_HOST ]; then
TMP_FILE=$IMAGE_FILE_AT_HOST.tmp
curl -o $TMP_FILE -L ${BASE_URL}/$TOPIC_DIRECTORY/$IMAGE_FILE
mv $TMP_FILE $IMAGE_FILE_AT_HOST
fi
scp $SSH_OPTIONS -P 10022 $IMAGE_FILE_AT_HOST root@localhost:$IMAGE_FILE_AT_QEMU_MACHINE \
&& ssh $SSH_OPTIONS -p 10022 root@localhost "docker image load -i $IMAGE_FILE_AT_QEMU_MACHINE"
done
}

# while循环文件读取
ls | while read remote;
do
echo ${remote}
done


# docker build
docker build -t conti2021/test:0.1.1 .

# aliyun镜像站
cat > /etc/yum.repos.d/aliyun.repo << EOF
[base]
name=CentOS-8-stream - Base - mirrors.aliyun.com
baseurl=https://mirrors.aliyun.com/centos/8-stream/BaseOS/x86_64/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

[extras]
name=CentOS-8-stream - Extras - mirrors.aliyun.com
baseurl=https://mirrors.aliyun.com/centos/8-stream/extras/x86_64/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

[AppStream]
name=CentOS-8-stream - AppStream - mirrors.aliyun.com
failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/8-stream/AppStream/x86_64/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

[docker-ce-stable]
name=Docker CE Stable - x86_64
baseurl=http://mirrors.aliyun.com/docker-ce/linux/centos/8-stream/x86_64/stable
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
EOF


