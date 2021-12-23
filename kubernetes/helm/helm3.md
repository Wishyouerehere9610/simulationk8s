## 

##  Charts

### 结构



### 内置对象

* Release
  * Release.Name
  
  * Release.Namespace
  
  * Release.IsUpgrade
    如果当前操作是升级或回滚的话，需要将该值设置为`true`
  
  * Release.IsInstall
  
     如果当前操作是安装的话，需要将该值设置为`true`
  
  * Release.Revision
  
  * Release.Service

* Values
  * chart中的values.yaml
  * 子chart中，就是府chart的values.yaml
  * -f --values 指定文件中的values
  * --set 单个传递的参数
* Chart
* Files
* Capabilities
* Template

### 









* ```shell
  helm get manifest rlname
  
  helm install --dry-run  
  
  
  ```
  
  ![image-20211209172012747](http://conti-picture-database.oss-cn-hangzhou.aliyuncs.com/img/image-20211209172012747.png