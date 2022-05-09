# VIM

## 文件命令
* ```shell
  :open file 
  :split file
  :bn
  :bp
  ```

## 快捷键
* ```shell
  I   行首插入
  A   行尾插入
  o   下一行行首插入
  O   上一行行首插入
  /text   查找,  n下一个,  N上一个
  ?text   查找,  n下一个,  N上一个
  :set ignorecase   忽略大小写的查找
  :set noignorecase 不忽略大小写的查找
  :set hlsearch     高亮搜索结果
  :set nohlsearch   关闭高亮搜索显示
  :nohlsearch       关闭当前的高亮显示
  :set incsearch    逐步搜索模式，对当前键入的字符进行搜索而不必等待键入完成
  :set wrapscan     重新搜索，在搜索到文件头或尾时，返回继续搜索，默认开启
  ```

## 替换命令
* ```shell
  :s/old/new/
  :s/old/new/g
  :%s/old/new/
  :%s/old/new/g
  :10,20 s/^/ /g   在第10行知第20行每行前面加四个空格，用于缩进
  ```
## 列模式
* ```shell
  
```
### json format

```text
%!python -m json.tool
```
