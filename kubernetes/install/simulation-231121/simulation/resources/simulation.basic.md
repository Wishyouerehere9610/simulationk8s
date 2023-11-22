* ```dockerfile
  FROM python:3.8.16-bullseye
  
  ENV TZ=Asia/Shanghai
  ENV DEBIAN_FRONTEND=noninteractive
  
  COPY jdk-11.0.13 /opt/jdk-11.0.13
  COPY requirements.txt /tmp/requirements.txt
  
  RUN sed -i -E 's/(deb|security).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
      && apt update && apt install -y gcc && export JAVA_HOME=/opt/jdk-11.0.13 \
      && pip3 install -r /tmp/requirements.txt && pip3 install jep==4.1.1
  
  ENV JAVA_HOME=/opt/jdk-11.0.13
  ENV CLASSPATH=${CLASSPATH}:${JAVA_HOME}/lib
  ENV PYTHON_HOME=/usr/local/lib/python3.8
  ENV JEP_HOME=${PYTHON_HOME}/site-packages/jep
  ENV PATH=${JAVA_HOME}/bin:$PATH
  ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${JEP_HOME}
  ```