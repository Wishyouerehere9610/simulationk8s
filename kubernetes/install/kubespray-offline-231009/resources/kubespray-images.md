### download kubespray images
1. prepare [images.list](images.list.md)
2. download images
    * ```shell
      for IMAGE in `cat images.list`
      do
          FILE_NAME="$(echo $IMAGE | sed s@"/"@"-"@g | sed s/":"/"-"/g)".dim
          docker image inspect $IMAGE > /dev/null || docker pull $IMAGE
          docker save -o $FILE_NAME $IMAGE
      done
      ```
3. prepare [images.sh](images.sh.md)