## Taint

### 三个选项
* ```shell
  NoSchedule ：表示k8s将不会将Pod调度到具有该污点的Node上
  PreferNoSchedule ：表示k8s将尽量避免将Pod调度到具有该污点的Node上
  NoExecute ：表示k8s将不会将Pod调度到具有该污点的Node上，同时会将Node上已经存在的Pod驱逐出去
  ```
* 设置污点
  * ```shell
    kubectl taint nodes k8s-node2 check=yuanzhang:NoExecute
    ```
* 查到污点
    * ```shell
      kubectl describe nodes k8s-node2
      ```
* 去除污点
    * ```shell
      kubectl taint nodes k8s-node2 check:NoExecute-
      ```