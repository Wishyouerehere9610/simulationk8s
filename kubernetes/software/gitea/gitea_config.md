## 总体 ( `DEFAULT`)

- `APP_NAME`: **Gitea: Git with a cup of tea** : 应用名称，在页面标题中使用。
- `RUN_USER`: **git** : Gitea 将作为用户运行。这应该是一个专用的系统（非用户）帐户。设置不正确会导致Gitea无法启动。
- `RUN_MODE`: **prod** : 应用程序运行模式，影响性能和调试。“开发”、“生产”或“测试”。

## 存储库 ( `repository`)

- `ROOT`: **data/gitea-repositories/** : 存放所有仓库数据的根路径。它必须是绝对路径。默认情况下，它存储在`APP_DATA_PATH`.
- `SCRIPT_TYPE`: **bash** : 此服务器支持的脚本类型。通常这是`bash`，但一些用户报告仅`sh`可用。
- `DETECTED_CHARSETS_ORDER`: **UTF-8, UTF-16BE, UTF-16LE, UTF-32BE, UTF-32LE, ISO-8859, windows-1252, ISO-8859, windows-1250, ISO-8859, ISO-8859, ISO-8859, windows -1253, ISO-8859, windows-1255, ISO-8859, windows-1251, windows-1256, KOI8-R, ISO-8859, windows-1254, Shift_JIS, GB18030, EUC-JP, EUC-KR, Big5, ISO -2022、ISO-2022、ISO-2022、IBM424_rtl、IBM424_ltr、IBM420_rtl、IBM420_ltr**：检测到的字符集的**决胜局**顺序 - 如果检测到的字符集具有相同的置信度，将优先选择列表中较早的字符集。添加`defaults`将在该点放置未命名的字符集。
- `ANSI_CHARSET`: **<empty>** : 默认 ANSI 字符集覆盖非 UTF-8 字符集。
- `FORCE_PRIVATE`: **false** : 强制每个新存储库都是私有的。
- `DEFAULT_PRIVATE`: **last** : 创建新存储库时的默认私有。[最后，私人，公共]
- `DEFAULT_PUSH_CREATE_PRIVATE`: **true** : 使用 push-to-create 创建新存储库时的默认私有。
- `MAX_CREATION_LIMIT`: **-1** : 每个用户的存储库的全局最大创建限制， `-1`意味着没有限制。
- `PULL_REQUEST_QUEUE_LENGTH`: **1000** : 拉取请求补丁测试队列的长度，让它。**弃用**使用`LENGTH`在`[queue.pr_patch_checker]`。尽可能大。编辑此值时要小心。
- `MIRROR_QUEUE_LENGTH`: **1000** : 补丁测试队列长度，如果拉取请求补丁测试开始挂起，则增加。**弃用**使用`LENGTH`在`[queue.mirror]`。
- `PREFERRED_LICENSES`: **Apache 许可证 2.0,MIT 许可证**: 放在列表顶部的首选许可证。名称必须与 options/license 或 custom/options/license 中的文件名匹配。
- `DISABLE_HTTP_GIT`: **false** : 禁用通过 HTTP 协议与存储库交互的能力。
- `USE_COMPAT_SSH_URI`: **false** : 当使用默认 SSH 端口时，强制使用 ssh:// 克隆 url 而不是 scp 样式的 uri。
- `ACCESS_CONTROL_ALLOW_ORIGIN`: **<empty>** : Access-Control-Allow-Origin 标头的值，默认不存在。**警告**：如果您没有给它一个正确的值，这可能对您的网站有害。
- `DEFAULT_CLOSE_ISSUES_VIA_COMMITS_IN_ANY_BRANCH`: **false** : 如果非默认分支上的提交将其标记为已关闭，则关闭问题。
- `ENABLE_PUSH_CREATE_USER`: **false** : 允许用户将本地存储库推送到 Gitea 并自动为用户创建它们。
- `ENABLE_PUSH_CREATE_ORG`: **false** : 允许用户将本地存储库推送到 Gitea 并自动为组织创建它们。
- `DISABLED_REPO_UNITS`: ***empty\*** : 逗号分隔的全局禁用 repo 单元列表。允许值：[repo.issues、repo.ext_issues、repo.pulls、repo.wiki、repo.ext_wiki、repo.projects]
- `DEFAULT_REPO_UNITS`: **repo.code,repo.releases,repo.issues,repo.pulls,repo.wiki,repo.projects** : 默认回购单位的逗号分隔列表。允许值：[repo.code、repo.releases、repo.issues、repo.pulls、repo.wiki、repo.projects]。注意：目前无法停用代码和版本。如果您指定默认回购单位，您仍应列出它们以备将来兼容。默认情况下无法启用外部 wiki 和问题跟踪器，因为它需要其他设置。禁用的存储库单元不会添加到新存储库中，无论它是否在默认列表中。
- `PREFIX_ARCHIVE_FILES`: **true** : 通过将存档文件放在以存储库命名的目录中来为存档文件添加前缀。
- `DISABLE_MIGRATIONS`: **false** : 禁用迁移功能。
- `DISABLE_STARS`: **false** : 禁用星星功能。
- `DEFAULT_BRANCH`: **master** : 所有存储库的默认分支名称。
- `ALLOW_ADOPTION_OF_UNADOPTED_REPOSITORIES`: **false** : 允许非管理员用户采用未采用的存储库
- `ALLOW_DELETION_OF_UNADOPTED_REPOSITORIES`: **false** : 允许非管理员用户删除未采用的存储库

### 存储库 - 编辑器 ( `repository.editor`)

- `LINE_WRAP_EXTENSIONS`: **.txt,.md,.markdown,.mdown,.mkd,** : 在摩纳哥编辑器中应该换行的文件扩展名列表。用逗号分隔扩展名。要在没有扩展名的情况下换行文件，只需输入一个逗号
- `PREVIEWABLE_FILE_MODES`: **markdown** : 具有与其关联的预览 API 的有效文件模式，例如`api/v1/markdown`. 用逗号分隔值。如果文件扩展名不匹配，将不会显示编辑模式下的预览选项卡。

### 存储库 - 拉取请求 ( `repository.pull-request`)

- `WORK_IN_PROGRESS_PREFIXES`: **WIP:,[WIP]** : 拉取请求标题中使用的前缀列表，将它们标记为正在进行中
- `CLOSE_KEYWORDS`：**close**, **closes**, **closed**, **fix**, **fixes**, **fixed**, **resolve**, **resolves**, **resolved** ：拉取请求注释中使用的关键字列表以自动关闭相关问题
- `REOPEN_KEYWORDS`：**reopen**, **reopens**, **reopened**：在拉取请求注释中使用的关键字列表以自动重新打开相关问题
- `DEFAULT_MERGE_MESSAGE_COMMITS_LIMIT`: **50** : 在壁球提交的默认合并消息中，最多包括这么多次提交。设置`-1`为包括所有提交
- `DEFAULT_MERGE_MESSAGE_SIZE`：**5120**：在壁球提交的默认合并消息中限制提交消息的大小。设置为`-1`没有限制。仅当`POPULATE_SQUASH_COMMENT_WITH_COMMIT_MESSAGES`是时使用`true`。
- `DEFAULT_MERGE_MESSAGE_ALL_AUTHORS`: **false** : 在壁球提交的默认合并消息中，将所有提交包含在共同作者中的所有作者，否则只使用有限列表中的那些
- `DEFAULT_MERGE_MESSAGE_MAX_APPROVERS`：**10**：在默认合并消息中，限制列为 的批准者数量`Reviewed-by:`。设置`-1`为包括所有。
- `DEFAULT_MERGE_MESSAGE_OFFICIAL_APPROVERS_ONLY`: **true** : 在默认合并消息中，仅包含正式允许审核的批准者。
- `POPULATE_SQUASH_COMMENT_WITH_COMMIT_MESSAGES`: **false** : 在默认情况下，压缩合并消息包括构成拉取请求的所有提交的提交消息。
- `ADD_CO_COMMITTER_TRAILERS`: **true** : 如果提交者与作者不匹配，则添加共同创作者和共同提交者预告片以合并提交消息。

### 存储库 - 问题 ( `repository.issue`)

- `LOCK_REASONS`：**Too heated,Off-topic,Resolved,Spam** ：可以锁定拉取请求或问题的原因列表

### 存储库 - 上传 ( `repository.upload`)

- `ENABLED`: **true** : 是否启用存储库文件上传
- `TEMP_PATH`: **data/tmp/uploads** :**上传**路径（tmp 在 Gitea 重启时被删除）
- `ALLOWED_TYPES`: **<empty>** : 允许的文件扩展名 ( `.zip`)、mime 类型 ( `text/plain`) 或通配符类型 ( `image/*`, `audio/*`, `video/*`) 的逗号分隔列表。空值或`*/*`允许所有类型。
- `FILE_MAX_SIZE`: **3** : 每个文件的最大大小 (MB)。
- `MAX_FILES`: **5** : 每次上传的最大文件数

### 存储库 - 发布 ( `repository.release`)

- `ALLOWED_TYPES`: **<empty>** : 允许的文件扩展名 ( `.zip`)、mime 类型 ( `text/plain`) 或通配符类型 ( `image/*`, `audio/*`, `video/*`) 的逗号分隔列表。空值或`*/*`允许所有类型。
- `DEFAULT_PAGING_NUM`: **10** : 发布用户界面的默认分页数
- 有关版本上文件附件的相关设置，请参阅`attachment`部分。

### 存储库 - 签名 ( `repository.signing`)

- `SIGNING_KEY`: **default** : [none, KEYID, default ]: 用于签名的密钥。

- `SIGNING_NAME`& `SIGNING_EMAIL`：如果提供 KEYID 作为 ，请将`SIGNING_KEY`它们用作签名者的姓名和电子邮件地址。这些应该与密钥的公开名称和电子邮件地址相匹配。

- `INITIAL_COMMIT`:  always  : [never, pubkey, twofa, always]: 签署初始提交。

  - `never`: 从不签字
  - `pubkey`: 只有当用户有公钥时才签名
  - `twofa`: 仅当用户使用 twofa 登录时才签名
  - `always`: 总是签名
  - `never`和以外的选项`always`可以组合为逗号分隔的列表。

- `DEFAULT_TRUST_MODEL`: collaborator  : [collaborator, committer,collaboratorcommitter]：用于验证提交的默认信任模型。

  - `collaborator`：信任由合作者的密钥签名的签名。
  - `committer`: 信任与提交者匹配的签名（这匹配 GitHub 并将强制 Gitea 签名的提交让 Gitea 作为提交者）。
  - `collaboratorcommitter`：信任由与提交者匹配的协作者的密钥签名的签名。

- `WIKI`: **never** : [never, pubkey, twofa, always, parentsigned]: 签署对 wiki 的承诺。

- `CRUD_ACTIONS` : pubkey, twofa, parentsigned : [never, pubkey, twofa, parentsigned, always]: 签署 CRUD 操作。

  - 选项如上，另外还有：
  - `parentsigned`：仅在父提交已签名时才签名。

- `MERGES`: pubkey, twofa, basesigned, commitssigned : [never, pubkey, twofa, Approved, basesigned, commitssigned, always]: 签名合并。
  - `approved`：仅将批准的合并签署到受保护的分支。
  - `basesigned`：仅当基础仓库中的父提交被签名时才签名。
  - `headsigned`: 只有在 head 分支中的 head commit 被签名时才签名。
  - `commitssigned`: 只有在 head 分支中到合并点的所有提交都已签名时才签名。

## 存储库 - 本地 ( `repository.local`)

- `LOCAL_COPY_PATH`: **tmp/local-repo** : 临时本地存储库副本的路径。默认为`tmp/local-repo`

## 存储库 - MIME 类型映射 ( `repository.mimetype_mapping`)

用于根据可下载文件的文件扩展名设置预期 MIME 类型的配置。配置以键值对的形式出现，文件扩展名以`.`.

`Content-Type: application/vnd.android.package-archive`下载带有`.apk`文件扩展名的文件时，以下配置设置标题。

* ```ini
  .apk=application/vnd.android.package-archive
  ```

## CORS ( `cors`)

- `ENABLED`: **false** : 启用 cors 标头（默认禁用）
- `SCHEME`: **http** : 允许请求的方案
- `ALLOW_DOMAIN`: ***** : 允许的请求域列表
- `ALLOW_SUBDOMAIN`: **false** : 允许上面列出的标头的子域请求
- `METHODS`: **GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS** : 允许请求的方法列表
- `MAX_AGE`: **10m** : 缓存响应的最长时间
- `ALLOW_CREDENTIALS`: **false** : 允许带有凭据的请求
- `X_FRAME_OPTIONS`: **SAMEORIGIN** : 设置`X-Frame-Options`标题值。

## 用户界面 ( `ui`)

- `EXPLORE_PAGING_NUM`: **20** : 一个探索页面中显示的存储库数量。
- `ISSUE_PAGING_NUM`: **10** : 一页中显示的问题数（对于列出问题的所有页面）。
- `MEMBERS_PAGING_NUM`: **20** : 组织成员中显示的成员数。
- `FEED_MAX_COMMIT_NUM`: **5** : 一个活动提要中显示的最大提交数。
- `FEED_PAGING_NUM`: **20** : 在主页显示的项目数。
- `GRAPH_MAX_COMMIT_NUM`: **100** : 提交图中显示的最大提交数。
- `CODE_COMMENT_LINES`: **4** : 代码注释显示的代码行数。
- `DEFAULT_THEME`: **auto** : [auto, gitea, arc-green]: 设置 Gitea 安装的默认主题。
- `SHOW_USER_EMAIL`: **true** : 用户的电子邮件是否应显示在“探索用户”页面中。
- `THEMES`: **auto,gitea,arc-green** : 所有可用的主题。允许用户选择个性化主题。不管 的值`DEFAULT_THEME`。
- `THEME_COLOR_META_TAG`: **#6cc644** :`theme-color`元标记的值，由 Android >= 5.0 使用。“无”或“禁用”等无效颜色将具有默认样式。更多信息：[https](https://developers.google.com/web/updates/2014/11/Support-for-theme-color-in-Chrome-39-for-Android) : [//developers.google.com/web/updates/2014/11/Support-for-theme-color-in-Chrome-39-for-Android](https://developers.google.com/web/updates/2014/11/Support-for-theme-color-in-Chrome-39-for-Android)
- `MAX_DISPLAY_FILE_SIZE`: **8388608** : 要显示的最大文件大小（默认为 8MiB）
- `REACTIONS`：用户可以在问题/prs 和评论上选择所有可用的反应值可以是表情符号别名（😄）或 unicode 表情符号。对于自定义反应，添加一个紧密裁剪的方形图像到 public/img/emoji/reaction_name.png
- `CUSTOM_EMOJIS`：**gitea、codeberg、gitlab、git、github、gogs**：utf8 标准中未定义的其他表情符号。默认情况下我们支持 Gitea (:gitea:)，要添加更多，请将它们复制到 public/img/emoji/emoji_name.png 并将其添加到此配置中。
- `DEFAULT_SHOW_FULL_NAME`: **false** : 是否应尽可能显示用户的全名。如果未设置全名，则将使用用户名。
- `SEARCH_REPO_DESCRIPTION`: **true** : 是否在探索页面上的存储库搜索的描述中搜索。
- `USE_SERVICE_WORKER`: **true** : 是否启用 Service Worker 缓存前端资产。

### 用户界面 - 管理员 ( `ui.admin`)

- `USER_PAGING_NUM`: **50** : 一页显示的用户数。
- `REPO_PAGING_NUM`: **50** : 一页中显示的回购数量。
- `NOTICE_PAGING_NUM`: **25** : 一页中显示的通知数。
- `ORG_PAGING_NUM`: **50** : 一页中显示的组织数量。

### 用户界面 - 元数据 ( `ui.meta`)

- `AUTHOR`：**Gitea - Git with a cup of tea**：主页的作者元标记。
- `DESCRIPTION`：**Gitea (Git with a cup of tea) is a painless self-hosted Git service written in Go**：主页的描述元标记。
- `KEYWORDS`: **go,git,self-hosted,gitea** : 主页的关键词元标签。

### 用户界面 - 通知 ( `ui.notification`)

- `MIN_TIMEOUT`: **10s** : 这些选项控制轮询通知端点以更新通知计数的频率。在页面加载后，将检查通知计数`MIN_TIMEOUT`。超时将增加至`MAX_TIMEOUT`由`TIMEOUT_STEP`如果通知数是不变的。将 MIN_TIMEOUT 设置为 0 以关闭。
- `MAX_TIMEOUT`: **60s**。
- `TIMEOUT_STEP`: **10s**。
- `EVENT_SOURCE_UPDATE_TIME`: **10s** : 此设置确定查询数据库以更新通知计数的频率。如果浏览器客户端支持`EventSource`and `SharedWorker`， a`SharedWorker`将优先用于轮询通知端点。设置为**-1**以禁用`EventSource`.

### 用户界面 - SVG 图像 ( `ui.svg`)

- `ENABLE_RENDER`: **true** : 是否将 SVG 文件渲染为图像。如果禁用 SVG 渲染，则 SVG 文件显示为文本，不能作为图像嵌入 Markdown 文件中。

### 用户界面 - CSV 文件 ( `ui.csv`)

- `MAX_FILE_SIZE`: **524288** (512kb): 将 CSV 文件呈现为表格的最大允许文件大小（以字节为单位）。（设置为 0 表示没有限制）。

## 降价 ( `markdown`)

- `ENABLE_HARD_LINE_BREAK_IN_COMMENTS`: **true** : 在注释中将软换行符呈现为硬换行符，这意味着段落之间的单个换行符将导致换行，并且不需要在段落中添加尾随空格来强制换行。
- `ENABLE_HARD_LINE_BREAK_IN_DOCUMENTS`: **false** : 在文档中将软换行符呈现为硬换行符，这意味着段落之间的单个换行符将导致换行，并且不需要在段落中添加尾随空格来强制换行。
- `CUSTOM_URL_SCHEMES`: 使用逗号分隔列表 (ftp,git,svn) 指示要在 Markdown 中呈现的其他 URL 超链接。始终显示以 http 和 https 开头的 URL

## 服务器 ( `server`)

- `PROTOCOL`: **http** : [http, https, fcgi, http+unix, fcgi+unix]
- `DOMAIN`: **localhost** : 该服务器的域名。
- `ROOT_URL`: **%(PROTOCOL)s://%(DOMAIN)s:%(HTTP_PORT)s/** : 覆盖自动生成的公共 URL。如果内部和外部 URL 不匹配（例如在 Docker 中），这很有用。
- `STATIC_URL_PREFIX`: **<empty>** : 覆盖此选项以从不同的 URL 请求静态资源。这包括 CSS 文件、图像、JS 文件和 Web 字体。头像是动态资源，仍然由 Gitea 提供服务。该选项可以只是不同的路径，如`/static`，或另一个域，如`https://cdn.example.com`。然后请求被制成`%(ROOT_URL)s/static/css/index.css`和`https://cdn.example.com/css/index.css`相应。静态文件位于`public/`Gitea 源代码库的目录中。
- `HTTP_ADDR`: **0.0.0.0** : HTTP 监听地址。
  - 如果`PROTOCOL`设置为`fcgi`，Gitea 将在由`HTTP_ADDR`和`HTTP_PORT`配置设置定义的 TCP 套接字上侦听 FastCGI 请求。
  - 如果`PROTOCOL`设置为`http+unix`or `fcgi+unix`，这应该是要使用的 Unix 套接字文件的名称。相对路径将针对 AppWorkPath 设置为绝对路径。
- `HTTP_PORT`: **3000** : HTTP 监听端口。
  - 如果`PROTOCOL`设置为`fcgi`，Gitea 将在由`HTTP_ADDR`和`HTTP_PORT`配置设置定义的 TCP 套接字上侦听 FastCGI 请求。
- `UNIX_SOCKET_PERMISSION`: **666** : Unix 套接字的权限。
- `LOCAL_ROOT_URL`: **%(PROTOCOL)s://%(HTTP_ADDR)s:%(HTTP_PORT)s/** : 用于访问 Web 服务的 Gitea 工作人员（例如 SSH 更新）的本地 (DMZ) URL。在大多数情况下，您不需要更改默认值。仅当您的 SSH 服务器节点与 HTTP 节点不同时才更改它。如果`PROTOCOL`设置为 ，则不要设置此变量`http+unix`。
- `PER_WRITE_TIMEOUT`: **30s** : 任何写入连接的超时。（设置为 0 以禁用所有超时。）
- `PER_WRITE_PER_KB_TIMEOUT`: **10s** : 每 Kb 写入连接的超时时间。
- `DISABLE_SSH`: **false** : 当 SSH 功能不可用时禁用它。
- `START_SSH_SERVER`: **false** : 启用后，使用内置的 SSH 服务器。
- `BUILTIN_SSH_SERVER_USER`: **%(RUN_USER)s** : 用于内置 SSH 服务器的用户名。
- `SSH_DOMAIN`: **%(DOMAIN)s** : 此服务器的域名，用于显示克隆 URL。
- `SSH_PORT`: **22** : SSH 端口显示在克隆 URL 中。
- `SSH_LISTEN_HOST`: **0.0.0.0** : 内置SSH服务器的监听地址。
- `SSH_LISTEN_PORT`: **%(SSH_PORT)s** : 内置 SSH 服务器的端口。
- `SSH_ROOT_PATH`: **~/.ssh** : SSH 目录的根路径。
- `SSH_CREATE_AUTHORIZED_KEYS_FILE`: **true** : Gitea 在不使用内部 ssh 服务器时默认会创建一个 authorized_keys 文件。如果您打算使用 AuthorizedKeysCommand 功能，那么您应该关闭它。
- `SSH_AUTHORIZED_KEYS_BACKUP`: **true** : 重写所有密钥时启用 SSH 授权密钥备份，默认为 true。
- `SSH_TRUSTED_USER_CA_KEYS`: **<empty>** : 指定受信任的证书颁发机构的公钥来签署用户证书以进行身份验证。多个键应以逗号分隔。例如`ssh-<algorithm> <key>`或`ssh-<algorithm> <key1>, ssh-<algorithm> <key2>`。有关更多信息，请参见`TrustedUserCAKeys`sshd 配置手册页。为空时不会创建文件，`SSH_AUTHORIZED_PRINCIPALS_ALLOW`默认为`off`.
- `SSH_TRUSTED_USER_CA_KEYS_FILENAME`: **`RUN_USER`/.ssh/gitea-trusted-user-ca-keys.pem** : **Gitea**`TrustedUserCaKeys`将管理的文件的绝对路径。如果您正在运行自己的 ssh 服务器并且想要使用 Gitea 托管文件，则还需要修改 sshd_config 以指向该文件。官方 docker 镜像将自动运行，无需进一步配置。
- `SSH_AUTHORIZED_PRINCIPALS_ALLOW`：**off**或**username**，**电子邮件**：[off，usernmae，email，任何东西]：指定允许用户用作主体的主体值。当设置为`anything`不检查主体字符串时。设置为`off`授权委托人时不允许设置。
- `SSH_CREATE_AUTHORIZED_PRINCIPALS_FILE`: **false/true** :Gitea 将默认创建一个authorized_principals 文件，当它不使用内部ssh 服务器并且`SSH_AUTHORIZED_PRINCIPALS_ALLOW`不是`off`。
- `SSH_AUTHORIZED_PRINCIPALS_BACKUP`: **false/true** : 重写所有密钥时启用 SSH 授权主体备份，如果`SSH_AUTHORIZED_PRINCIPALS_ALLOW`不是，则默认为 true `off`。
- `SSH_AUTHORIZED_KEYS_COMMAND_TEMPLATE`: **{{.AppPath}} –config={{.CustomConf}} serv key-{{.Key.ID}}** : 设置传递授权密钥的命令模板。可能的键有：AppPath、AppWorkPath、CustomConf、CustomPath、Key - 其中 Key 是 a `models.PublicKey`，其他是 shellquoted 的字符串。
- `SSH_SERVER_CIPHERS`: **aes128-ctr, aes192-ctr, aes256-ctr, [aes128-gcm@openssh.com](mailto:aes128-gcm@openssh.com) , arcfour256, arcfour128** : 对于内置SSH服务器，选择支持SSH连接的密码，对于系统SSH此设置无效.
- `SSH_SERVER_KEY_EXCHANGES`: **diffie-hellman-group1-sha1, diffie-hellman-group14-sha1, ecdh-sha2-nistp256, ecdh-sha2-nistp384, ecdh-sha2-nistp521, [curve25519-sha256@libssh.org](mailto:curve25519-sha256@libssh.org)** : SSH服务器端, 选择支持SSH连接的密钥交换算法，对于系统SSH此设置无效。
- `SSH_SERVER_MACS`: **[hmac-sha2-256-etm@openssh.com](mailto:hmac-sha2-256-etm@openssh.com) , hmac-sha2-256, hmac-sha1, hmac-sha1-96** : 对于内置 SSH 服务器，选择支持 SSH 连接的 MAC，对于系统 SSH 这个设置无效
- `SSH_SERVER_HOST_KEYS`: **ssh/gitea.rsa, ssh/gogs.rsa** : 对于内置 SSH 服务器，选择要提供的密钥对作为主机密钥。私钥应该是 at`SSH_SERVER_HOST_KEY`和 public `SSH_SERVER_HOST_KEY.pub`。相对路径相对于`APP_DATA_PATH`. 如果不存在密钥，将为您创建 4096 位 RSA 密钥。
- `SSH_KEY_TEST_PATH`: **/tmp** : 使用 ssh-keygen 测试公钥时创建临时文件的目录，默认为系统临时目录。
- `SSH_KEYGEN_PATH`: **ssh-keygen** : **ssh-keygen 的**路径，默认是 'ssh-keygen' 这意味着 shell 负责找出要调用的那个。
- `SSH_EXPOSE_ANONYMOUS`: **false** : 允许向匿名访问者公开 SSH 克隆 URL，默认为 false。
- `SSH_PER_WRITE_TIMEOUT`: **30s** : 任何写入 SSH 连接的超时。（设置为 0 以禁用所有超时。）
- `SSH_PER_WRITE_PER_KB_TIMEOUT`: **10s** : 写入 SSH 连接的每 Kb 超时。
- `MINIMUM_KEY_SIZE_CHECK`: **true** : 指示是否检查对应类型的最小密钥大小。
- `OFFLINE_MODE`: **false** : 禁用静态文件的 CDN 和个人资料图片的 Gravatar。
- `DISABLE_ROUTER_LOG`: **false** : 静音打印路由器日志。
- `CERT_FILE`: **https/cert.pem** : 用于 HTTPS 的证书文件路径。链接时，服务器证书必须先出现，然后是中间 CA 证书（如果有）。从 1.11 开始，路径是相对于`CUSTOM_PATH`.
- `KEY_FILE`: **https/key.pem** : 用于 HTTPS 的密钥文件路径。从 1.11 开始，路径是相对于`CUSTOM_PATH`.
- `STATIC_ROOT_PATH`: **./** : 上一级模板和静态文件路径。
- `APP_DATA_PATH`：**data**（**docker**上的**/data/gitea**）：应用程序数据的默认路径。
- `STATIC_CACHE_TIME`：**6H**：Web浏览器缓存时间上静态的资源`custom/`，`public/`并且所有上传的头像。请注意，此缓存在`RUN_MODE`“dev”时被禁用。
- `ENABLE_GZIP`: **false** : 为运行时生成的内容启用 gzip 压缩，排除静态资源。
- `ENABLE_PPROF`: **false** : 应用程序分析（内存和 CPU）。对于“web”命令，它监听 localhost:6060。将“serv”命令将其转储到磁盘上的`PPROF_DATA_PATH`作为`(cpuprofile|memprofile)_<username>_<temporary id>`
- `PPROF_DATA_PATH`: **data/tmp/pprof** : `PPROF_DATA_PATH`, 以服务方式启动**Gitea**时使用绝对路径
- `LANDING_PAGE`: **home** : 未认证用户的登陆页面 [主页、探索、组织、登录]。
- `LFS_START_SERVER`: **false** : 启用 git-lfs 支持。
- `LFS_CONTENT_PATH`: **%(APP_DATA_PATH)/lfs** : 默认 LFS 内容路径。（如果是在本地存储。）**不推荐使用**在使用中设置`[lfs]`。
- `LFS_JWT_SECRET`: **<empty>** : LFS 身份验证密钥，将其更改为唯一字符串。
- `LFS_HTTP_AUTH_EXPIRY`: **20m** : LFS 认证有效期的时间。持续时间，超过这个时间的推送可能会失败。
- `LFS_MAX_FILE_SIZE`: **0** : 允许的最大 LFS 文件大小（以字节为单位）（设置为 0 表示没有限制）。
- `LFS_LOCKS_PAGING_NUM`: **50** : 每页返回的最大 LFS 锁数。
- `REDIRECT_OTHER_PORT`: **false** : 如果为 true 并且`PROTOCOL`是 https，则允许将 http 请求重定向`PORT_TO_REDIRECT`到 Gitea 侦听的 https 端口。
- `PORT_TO_REDIRECT`: **80** : http 重定向服务监听的端口。当`REDIRECT_OTHER_PORT`为真时使用。
- `SSL_MIN_VERSION`: **TLSv1.2** : 设置ssl支持的最低版本。
- `SSL_MAX_VERSION`: **<empty>** : 设置 ssl 支持的最大版本。
- `SSL_CURVE_PREFERENCES`: **X25519,P256** : 设置首选曲线，
- `SSL_CIPHER_SUITES`：**ecdhe_ecdsa_with_aes_256_gcm_sha384，ecdhe_rsa_with_aes_256_gcm_sha384，ecdhe_ecdsa_with_aes_128_gcm_sha256，ecdhe_rsa_with_aes_128_gcm_sha256，ecdhe_ecdsa_with_chacha20_poly1305，ecdhe_rsa_with_chacha20_poly1305**：设置的优选的密码套件。
  - 如果默认情况下没有对 AES 套件的硬件支持，cha cha 套件将优先于 AES 套件
  - 从 go 1.17 开始支持的套件是：
    - TLS 1.0 - 1.2 密码套件
      - “rsa_with_rc4_128_sha”
      - “rsa_with_3des_ede_cbc_sha”
      - “rsa_with_aes_128_cbc_sha”
      - “rsa_with_aes_256_cbc_sha”
      - “rsa_with_aes_128_cbc_sha256”
      - “rsa_with_aes_128_gcm_sha256”
      - “rsa_with_aes_256_gcm_sha384”
      - “ecdhe_ecdsa_with_rc4_128_sha”
      - “ecdhe_ecdsa_with_aes_128_cbc_sha”
      - “ecdhe_ecdsa_with_aes_256_cbc_sha”
      - “ecdhe_rsa_with_rc4_128_sha”
      - “ecdhe_rsa_with_3des_ede_cbc_sha”
      - “ecdhe_rsa_with_aes_128_cbc_sha”
      - “ecdhe_rsa_with_aes_256_cbc_sha”
      - “ecdhe_ecdsa_with_aes_128_cbc_sha256”
      - “ecdhe_rsa_with_aes_128_cbc_sha256”
      - “ecdhe_rsa_with_aes_128_gcm_sha256”
      - “ecdhe_ecdsa_with_aes_128_gcm_sha256”
      - “ecdhe_rsa_with_aes_256_gcm_sha384”
      - “ecdhe_ecdsa_with_aes_256_gcm_sha384”
      - “ecdhe_rsa_with_chacha20_poly1305_sha256”
      - “ecdhe_ecdsa_with_chacha20_poly1305_sha256”
    - TLS 1.3 密码套件
      - “aes_128_gcm_sha256”
      - “aes_256_gcm_sha384”
      - “chacha20_poly1305_sha256”
    - 别名
      - “ecdhe_rsa_with_chacha20_poly1305”是“ecdhe_rsa_with_chacha20_poly1305_sha256”的别名
      - “ecdhe_ecdsa_with_chacha20_poly1305”是“ecdhe_ecdsa_with_chacha20_poly1305_sha256”的别名
- `ENABLE_LETSENCRYPT`: **false** : 如果启用，您必须设置`DOMAIN`为有效的面向 Internet 的域（确保设置了 DNS 并且 letencrypt 验证服务器可以访问端口 80）。使用 Lets Encrypt**您必须同意**他们[的服务条款](https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf)。
- `LETSENCRYPT_ACCEPTTOS`: **false** : 这是一项明确的检查，表明您接受 Let's Encrypt 的服务条款。
- `LETSENCRYPT_DIRECTORY`: **https** : Letsencrypt 将用来缓存证书和私钥等信息的目录。
- `LETSENCRYPT_EMAIL`：**[email@example.com](mailto:email@example.com)**：Letsencrypt 用于通知已颁发证书问题的电子邮件。（无默认）
- `ALLOW_GRACEFUL_RESTARTS`: **true** : 在 SIGHUP 上执行正常重启
- `GRACEFUL_HAMMER_TIME`: **60s** : 重新启动后，父进程将停止接受新连接，并允许请求在停止之前完成。如果超过这个时间，将强制关机。
- `STARTUP_TIMEOUT`: **0** : 如果启动时间超过提供的时间，则关闭服务器。在 Windows 设置中，这会向 SVC 主机发送一个等待提示，告诉 SVC 主机启动可能需要一些时间。请注意，启动取决于侦听器的打开情况 - HTTP/HTTPS/SSH。索引器可能需要更长的时间才能启动，并且可以有自己的超时。

## 数据库 ( `database`)

- `DB_TYPE`: **mysql** : 使用的数据库类型 [mysql, postgres, mssql, sqlite3]。
- `HOST`: **127.0.0.1:3306** : unix socket [mysql, postgres] 的数据库主机地址和端口或绝对路径（例如：/var/run/mysqld/mysqld.sock）。
- `NAME`: **gitea** : 数据库名称。
- `USER`: **root** : 数据库用户名。
- `PASSWD`: **<empty>** : 数据库用户密码。如果您在密码中使用特殊字符，请使用“您的密码”或““您的密码””来引用。
- `SCHEMA`: **<empty>** : 仅适用于 PostgreSQL，如果与“public”不同，则使用模式。模式必须事先存在，用户必须对其具有创建权限，并且必须将用户搜索路径设置为首先查看模式（例如`ALTER USER user SET SEARCH_PATH = schema_name,"$user",public;`）。
- `SSL_MODE` :  disable  : 用于连接数据库的 SSL/TLS 加密模式。此选项仅适用于 PostgreSQL 和 MySQL。

  - MySQL 的有效值：
    - `true`：启用 TLS，并根据其根证书验证数据库服务器证书。选择此选项时，请确保验证数据库服务器证书（例如 CA 证书）所需的根证书位于数据库和 Gitea 服务器的系统证书存储中。有关如何将 CA 证书添加到证书库的说明，请参阅您的系统文档。
    - `false`: 禁用 TLS。
    - `disable`: 别名`false`，用于与 PostgreSQL 兼容。
    - `skip-verify`: 在没有数据库服务器证书验证的情况下启用 TLS。如果数据库服务器上有自签名证书或无效证书，请使用此选项。
    - `prefer`：启用 TLS 并回退到非 TLS 连接。
  - PostgreSQL 的有效值：
    - `disable`: 禁用 TLS。
    - `require`：无需任何验证即可启用 TLS。
    - `verify-ca`：启用 TLS，并根据其根证书验证数据库服务器证书。
    - `verify-full`：启用 TLS 并验证数据库服务器名称与`Common Name`或`Subject Alternative Name`字段中的给定证书匹配。
- `SQLITE_TIMEOUT`: **500** : 仅对 sqlite3 的查询超时。
- `ITERATE_BUFFER_SIZE`: **50** : 用于迭代的内部缓冲区大小。
- `CHARSET`: **utf8mb4** : 仅适用于 MySQL，“utf8”或“utf8mb4”。注意：对于“utf8mb4”，您必须使用 MySQL InnoDB > 5.6。Gitea 无法检查这一点。
- `PATH`: **data/gitea.db** : 仅适用于 SQLite3，数据库文件路径。
- `LOG_SQL`: **true** : 记录执行的 SQL。
- `DB_RETRIES`: **10** : 允许多少次 ORM init / DB 连接尝试。
- `DB_RETRY_BACKOFF`: **3s** : time.Duration 在尝试另一个 ORM init / DB 连接尝试之前等待，如果失败。
- `MAX_OPEN_CONNS` **0**：数据库最大打开连接数 - 默认为 0，表示没有限制。
- `MAX_IDLE_CONNS` **2** : 连接池上的最大空闲数据库连接数，默认为 2 - 这将被限制为`MAX_OPEN_CONNS`.
- `CONN_MAX_LIFETIME` **0 or 3s**：设置可以重用数据库连接的最长时间 - 默认为 0，这意味着没有限制（MySQL 除外，它是 3s - 参见 #6804 和 #7071）。

请参阅 #8540 & #8273 以进一步讨论`MAX_OPEN_CONNS`, `MAX_IDLE_CONNS`&的适当值`CONN_MAX_LIFETIME`及其与端口耗尽的关系。

## 索引器 ( `indexer`)

- `ISSUE_INDEXER_TYPE`: **bleve** : 问题索引器类型，当前支持：`bleve`,`db`或`elasticsearch`.
- `ISSUE_INDEXER_CONN_STR`: ****: 发出索引器连接字符串，当ISSUE_INDEXER_TYPE为elasticsearch时可用。即 http://elastic:changeme@localhost:9200
- `ISSUE_INDEXER_NAME`: **gitea_issues** : 问题索引器名称，当 ISSUE_INDEXER_TYPE 为 elasticsearch 时可用
- `ISSUE_INDEXER_PATH`: **indexers/issues.bleve** : 用于问题搜索的索引文件；当 ISSUE_INDEXER_TYPE 为 bleve 和 elasticsearch 时可用。
- 接下来的 4 个配置值已弃用，应设置，`queue.issue_indexer`但为了向后兼容而保留：
- `ISSUE_INDEXER_QUEUE_TYPE`: **levelqueue** : 问题索引器队列，目前支持：`channel`, `levelqueue`, `redis`. **中已弃用的**使用设置`[queue.issue_indexer]`。
- `ISSUE_INDEXER_QUEUE_DIR`: **queues/common** : 当`ISSUE_INDEXER_QUEUE_TYPE`是时`levelqueue`，这将是队列保存的路径。**中已弃用的**使用设置`[queue.issue_indexer]`。
- `ISSUE_INDEXER_QUEUE_CONN_STR`: **addrs=127.0.0.1:6379 db=0** : 当`ISSUE_INDEXER_QUEUE_TYPE`是时`redis`，这将存储redis连接字符串。当`ISSUE_INDEXER_QUEUE_TYPE`是时`levelqueue`，这是一个目录或表单的附加选项`leveldb://path/to/db?option=value&....`，并覆盖`ISSUE_INDEXER_QUEUE_DIR`。**中已弃用的**使用设置`[queue.issue_indexer]`。
- `ISSUE_INDEXER_QUEUE_BATCH_NUMBER`: **20** : 批次队列号。**中已弃用的**使用设置`[queue.issue_indexer]`。
- `REPO_INDEXER_ENABLED`: **false** : 启用代码搜索（使用大量磁盘空间，大约是存储库大小的 6 倍）。
- `REPO_INDEXER_TYPE`: **bleve** : 代码搜索引擎类型，可以是`bleve`或`elasticsearch`。
- `REPO_INDEXER_PATH`: **indexers/repos.bleve** : 用于代码搜索的索引文件。
- `REPO_INDEXER_CONN_STR`: ****: 代码索引器连接字符串，在`REPO_INDEXER_TYPE`elasticsearch时可用。即 http://elastic:changeme@localhost:9200
- `REPO_INDEXER_NAME`：**gitea_codes**：代码索引的名字，当可`REPO_INDEXER_TYPE`为elasticsearch
- `REPO_INDEXER_INCLUDE`: **empty** :**包含**在索引中的逗号分隔的 glob 模式列表（参见https://github.com/gobwas/glob）。使用与.txt扩展名匹配的任何文件。空列表意味着包含所有文件。`**.txt`
- `REPO_INDEXER_EXCLUDE`: **empty** : 一个逗号分隔的 glob 模式列表（见https://github.com/gobwas/glob）从索引中**排除**。与此列表匹配的文件不会被编入索引，即使它们在`REPO_INDEXER_INCLUDE`.
- `REPO_INDEXER_EXCLUDE_VENDORED`: **true** : 从索引中排除供应商文件。
- `UPDATE_BUFFER_LEN`: **20** : 索引请求的缓冲区长度。**中已弃用的**使用设置`[queue.issue_indexer]`。
- `MAX_FILE_SIZE`：**1048576**：要编制索引的文件的最大字节数。
- `STARTUP_TIMEOUT`: **30s** : 如果索引器启动时间超过此超时时间 - 失败。（这个超时将被添加到上面的子进程的锤子时间 - 因为直到前一个父进程关闭之前 bleve 才会启动。）设置为零以永不超时。

## 管理员 ( `admin`)

- `DEFAULT_EMAIL_NOTIFICATIONS`：**启用**：用户电子邮件通知的默认配置（用户可配置）。选项：enabled, onmention, disabled
- `DISABLE_REGULAR_ORG_CREATION`: **false** : 禁止普通（非管理员）用户创建组织。

## 安全 ( `security`)

- `INSTALL_LOCK`: **false** : 禁止访问安装页面。

- `SECRET_KEY`: **<random at every install>** : 全局密钥。这应该改变。

- `LOGIN_REMEMBER_DAYS`: **7** : Cookie 的生命周期，以天为单位。

- `COOKIE_USERNAME`: **gitea_awesome** : 用于存储当前用户名的 cookie 的名称。

- `COOKIE_REMEMBER_NAME`: **gitea_incredible** : 用于存储认证信息的 cookie 名称。

- `REVERSE_PROXY_AUTHENTICATION_USER`: **X-WEBAUTH-USER** : 反向代理身份验证的标头名称。

- `REVERSE_PROXY_AUTHENTICATION_EMAIL`: **X-WEBAUTH-EMAIL** : 反向代理身份验证提供的电子邮件的标题名称。

- `REVERSE_PROXY_LIMIT`: **1** : 解释 X-Forwarded-For 标头或 X-Real-IP 标头，并将其设置为请求的远程 IP。受信任的代理计数。设置为零以不使用这些标头。

- `REVERSE_PROXY_TRUSTED_PROXIES`: **127.0.0.0/8,::1/128** : 以逗号分隔的受信任代理服务器的 IP 地址和网络列表。使用`*`信任所有。

- `DISABLE_GIT_HOOKS`: **true** : 设置为`false`允许具有 git hook 权限的用户创建自定义 git hooks。警告：自定义 git 钩子可用于在主机操作系统上执行任意代码。这使用户能够访问和修改此配置文件和 Gitea 数据库并中断 Gitea 服务。通过修改Gitea 数据库，用户可以获得Gitea 管理员权限。它还使他们能够访问运行 Gitea 实例的操作系统上用户可用的其他资源，并以 Gitea OS 用户的名义执行任意操作。这可能对您的网站或操作系统有害。

- `DISABLE_WEBHOOKS`: **false** : 设置`true`为禁用 webhooks 功能。

- `ONLY_ALLOW_PUSH_IF_GITEA_ENVIRONMENT_SET`: **true** : 设置为`false`允许本地用户在不设置 Gitea 环境的情况下推送到 gitea-repositories。不推荐这样做，如果您希望本地用户推送到 Gitea 存储库，您应该适当地设置环境。

- `IMPORT_LOCAL_PATHS`: **false** : 设置为`false`阻止所有用户（包括管理员）在服务器上导入本地路径。

- `INTERNAL_TOKEN`: **<random at every install if no uri set>** : Secret 用于验证 Gitea 二进制文件中的通信。

- `INTERNAL_TOKEN_URI`：：代替在配置中定义的内部令牌的，这样的配置选项可用于给Gitea到包含内部令牌的文件的路径（例如值：`file:/etc/gitea/internal_token`）

- `PASSWORD_HASH_ALGO`: **pbkdf2** : 使用[argon2, pbkdf2, scrypt, bcrypt]的hash算法，argon2会比其他算法消耗更多的内存。

- `CSRF_COOKIE_HTTP_ONLY`: **true** : 设置 false 以允许 JavaScript 读取 CSRF cookie。

- `MIN_PASSWORD_LENGTH`: **6** : 新用户的最小密码长度。

- `PASSWORD_COMPLEXITY` :  off  : 通过最低复杂性所需的逗号分隔的字符类列表。如果留空或未指定有效值，则禁用（关闭）检查：
  - 较低 - 使用一个或多个较低的拉丁字符
  - upper - 使用一个或多个大写拉丁字符
  - digit - 使用一位或多位数字
  - spec - 使用一个或多个特殊字符作为 `!"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~`
  - off - 不检查密码复杂性
  
- `PASSWORD_CHECK_PWN`: **false** : 检查[HaveIBeenPwned](https://haveibeenpwned.com/Passwords)以查看密码是否已泄露。

- `SUCCESSFUL_TOKENS_CACHE_SIZE`: **20** : 缓存成功的令牌哈希。API 令牌作为 pbkdf2 散列存储在数据库中，但这意味着当有多个 API 操作时，可能会出现显着的散列负载。该缓存将成功散列的令牌存储在 LRU 缓存中，作为性能和安全性之间的平衡。

## 开放 ID ( `openid`)

- `ENABLE_OPENID_SIGNIN`: **false** : 允许通过 OpenID 进行身份验证。
- `ENABLE_OPENID_SIGNUP`：**！DISABLE_REGISTRATION**：允许通过 OpenID 注册。
- `WHITELISTED_URIS`: **<empty>** : 如果非空，则匹配 OpenID URI 的 POSIX 正则表达式模式列表允许。
- `BLACKLISTED_URIS`: **<empty>** : 如果非空，则匹配要阻止的 OpenID URI 的 POSIX 正则表达式模式列表。

## OAuth2 客户端 ( `oauth2_client`)

- `REGISTER_EMAIL_CONFIRM`: *[service]* **REGISTER_EMAIL_CONFIRM** : 设置此项以启用或禁用 OAuth2 自动注册的电子邮件确认。（覆盖该`[service]`部分的 REGISTER_EMAIL_CONFIRM 设置）

- `OPENID_CONNECT_SCOPES`: **<empty>** : 附加 openid 连接范围的列表。(`openid`是隐式添加的)

- `ENABLE_AUTO_REGISTRATION`: **false** : 自动为新的 oauth2 用户创建用户帐户。

- `USERNAME ` : nickname : 新 oauth2 账户的用户名来源：

  - userid - 使用 userid / sub 属性
  - 昵称 - 使用昵称属性
  - 电子邮件 - 使用电子邮件属性的用户名部分

- `UPDATE_AVATAR`: **false** : 如果 oauth2 提供者可用，则更新头像。每次登录都会执行更新。

- `ACCOUNT_LINKING`: login : 如果帐户/电子邮件已经存在，如何处理：
  - 禁用 - 显示错误
  - 登录 - 显示链接登录的帐户
  - 自动 - 自动与帐户关联（请注意，这将授予对现有帐户的访问权限，因为提供了相同的用户名或电子邮件。您必须确保这不会导致您的身份验证提供商出现问题。）

## 服务 ( `service`)

- `ACTIVE_CODE_LIVE_MINUTES`: **180** : 确认帐户/电子邮件注册的时间限制（分钟）。
- `RESET_PASSWD_CODE_LIVE_MINUTES`: **180** : 确认忘记密码重置过程的时间限制（分钟）。
- `REGISTER_EMAIL_CONFIRM`: **false** : 启用此项以要求邮件确认注册。需要`Mailer`启用。
- `REGISTER_MANUAL_CONFIRM`: **false** : 启用此项以手动确认新注册。需要`REGISTER_EMAIL_CONFIRM`禁用。
- `DISABLE_REGISTRATION`: **false** : 禁用注册，之后只有管理员才能为用户创建帐户。
- `REQUIRE_EXTERNAL_REGISTRATION_PASSWORD`: **false**：启用此选项可强制外部创建的帐户（通过 GitHub、OpenID Connect 等）创建密码。警告：启用此功能会降低安全性，因此只有在您知道自己在做什么时才应启用它。
- `REQUIRE_SIGNIN_VIEW`: **false** : 启用此选项可强制用户登录以查看任何页面或使用 API。
- `ENABLE_NOTIFY_MAIL`: **false** : 启用此选项可在发生某些事情（例如创建问题）时向存储库的观察者发送电子邮件。需要`Mailer`启用。
- `ENABLE_BASIC_AUTHENTICATION`: **true** : 禁用此项以禁止使用 HTTP BASIC 和用户密码进行身份验证。请注意，如果您禁用此功能，您将无法使用密码访问令牌 API 端点。此外，这只会禁用使用密码的 BASIC 身份验证 - 而不是令牌或 OAuth Basic。
- `ENABLE_REVERSE_PROXY_AUTHENTICATION`: **false** : 启用此选项以允许反向代理身份验证。
- `ENABLE_REVERSE_PROXY_AUTO_REGISTRATION`: **false** : 启用此选项以允许自动注册以进行反向身份验证。
- `ENABLE_REVERSE_PROXY_EMAIL`: **false** : 启用此选项以允许使用提供的电子邮件而不是生成的电子邮件自动注册。
- `ENABLE_CAPTCHA`: **false** : 启用此项以使用验证码验证进行注册。
- `REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA`: **false** : 启用此选项以强制验证码，即使对于外部帐户（即 GitHub、OpenID Connect 等）也是如此。你`ENABLE_CAPTCHA`也必须。
- `CAPTCHA_TYPE`：**iamge**：[图像，recaptcha，hcaptcha]
- `RECAPTCHA_SECRET`: **""** : 转到https://www.google.com/recaptcha/admin获取 recaptcha 的秘密。
- `RECAPTCHA_SITEKEY`: **""** : 转到https://www.google.com/recaptcha/admin获取 recaptcha 的站点密钥。
- `RECAPTCHA_URL`: **https://www.google.com/recaptcha/** : 设置recaptcha url - 允许使用recaptcha net。
- `HCAPTCHA_SECRET`: **""** : 在https://www.hcaptcha.com/注册以获取 hcaptcha 的秘密。
- `HCAPTCHA_SITEKEY`: **""** : 在https://www.hcaptcha.com/注册以获得 hcaptcha 的站点密钥。
- `DEFAULT_KEEP_EMAIL_PRIVATE`: **false** : 默认情况下设置用户将他们的电子邮件地址保密。
- `DEFAULT_ALLOW_CREATE_ORGANIZATION`: **true** : 默认允许新用户创建组织。
- `DEFAULT_USER_IS_RESTRICTED`: **false** : 默认给新用户限制权限
- `DEFAULT_ENABLE_DEPENDENCIES`: **true** : 启用此选项以默认启用依赖项。
- `ALLOW_CROSS_REPOSITORY_DEPENDENCIES`: **true**启用此选项以允许对来自授予用户访问权限的任何存储库的问题的依赖。
- `ENABLE_USER_HEATMAP`: **true** : 启用此选项以在用户个人资料上显示热图。
- `ENABLE_TIMETRACKING`: **true** : 启用时间跟踪功能。
- `DEFAULT_ENABLE_TIMETRACKING`: **true** : 默认情况下允许存储库使用时间跟踪。
- `DEFAULT_ALLOW_ONLY_CONTRIBUTORS_TO_TRACK_TIME`: **true** : 只允许有写权限的用户跟踪时间。
- `EMAIL_DOMAIN_WHITELIST`: **<empty>** : 如果非空，则只能用于在此实例上注册的域名列表。
- `EMAIL_DOMAIN_BLOCKLIST`: **<empty>** : 如果非空，则不能用于在此实例上注册的域名列表
- `SHOW_REGISTRATION_BUTTON`：**！DISABLE_REGISTRATION** : 显示注册按钮
- `SHOW_MILESTONES_DASHBOARD_PAGE`: **true**启用它以显示里程碑仪表板页面 - 所有用户里程碑的视图
- `AUTO_WATCH_NEW_REPOS`: **true** : 启用此选项可让所有组织用户在创建新存储库时观看它们
- `AUTO_WATCH_ON_CHANGES`: **false** : 启用此选项可使用户在首次提交后观看存储库
- `DEFAULT_USER_VISIBILITY`: **public** : 设置用户的默认可见性模式，“public”、“limited”或“private”。
- `ALLOWED_USER_VISIBILITY_MODES`: **public,limited,private** : 设置用户可以拥有的可见性模式
- `DEFAULT_ORG_VISIBILITY`: **public** : 设置组织的默认可见性模式，“public”、“limited”或“private”。
- `DEFAULT_ORG_MEMBER_VISIBLE`: **false** True 将使添加到组织的用户的成员资格可见。
- `ALLOW_ONLY_INTERNAL_REGISTRATION`: **false**设置为 true 以强制仅通过 Gitea 注册。
- `ALLOW_ONLY_EXTERNAL_REGISTRATION`: **false**设置为 true 以强制仅使用第三方服务注册。
- `NO_REPLY_ADDRESS`: **noreply.DOMAIN**如果用户已将 KeepEmailPrivate 设置为 true，则 git 日志中用户电子邮件地址的域部分的值。DOMAIN 解析为 server.DOMAIN 中的值。用户的电子邮件将替换为小写的用户名“@”和 NO_REPLY_ADDRESS 的串联。
- `USER_DELETE_WITH_COMMENTS_MAX_TIME`: **0**在删除用户时保留评论之前用户必须存在的最短时间。
- `VALID_SITE_URL_SCHEMES`: **http, https** : 用户配置文件的有效站点 url 方案

### 服务 - 探索 ( `service.explore`)

- `REQUIRE_SIGNIN_VIEW`: **false** : 只允许登录的用户查看探索页面。
- `DISABLE_USERS_PAGE`: **false** : 禁用用户探索页面。

## SSH 最小密钥大小 ( `ssh.minimum_key_sizes`)

定义允许的算法及其最小密钥长度（使用 -1 禁用类型）：

- `ED25519`: **256**
- `ECDSA`: **256**
- `RSA`: **2048**
- `DSA`: **-1** : DSA 现在默认禁用。设置为**1024**以重新启用但确保您可能需要重新配置您的 SSHD 提供商

## 网络钩子 ( `webhook`)

- `QUEUE_LENGTH`: **1000** : 挂钩任务队列长度。编辑此值时要小心。

- `DELIVER_TIMEOUT`: **5** : 用于拍摄 webhooks 的传送超时（秒）。

- ```
  ALLOWED_HOST_LIST：external ：自 1.15.7 起。默认为external
  ```

  - 内置网络：
    - `loopback`: IPv4 为 127.0.0.0/8，IPv6 为 ::1/128，包括本地主机。
    - `private`: RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) 和 RFC 4193 (FC00::/7)。也称为 LAN/Intranet。
    - `external`: 一个有效的非私有单播IP，您可以访问公共互联网上的所有主机。
    - `*`: 允许所有主机。
  - CIDR 列表：`1.2.3.0/8`用于 IPv4 和`2001:db8::/32`用于 IPv6
  - 通配符主机：`*.mydomain.com`,`192.168.100.*`
  
- `SKIP_TLS_VERIFY`: **false** : 允许不安全的认证。

- `PAGING_NUM`: **10** : 一页中显示的 webhook 历史事件的数量。

- `PROXY_URL`: **<empty>** : 代理服务器地址，支持http://、https//、socks://，空白会跟随环境http_proxy/https_proxy。如果没有给出，将使用全局代理设置。

- `PROXY_HOSTS`: **<empty>`** : 需要代理的主机名的逗号分隔列表。接受全局模式 (*)；使用 ** 匹配所有主机。如果没有给出，将使用全局代理设置。

## 梅勒 ( `mailer`)

- `ENABLED`: **false** : 启用以使用邮件服务。

- `DISABLE_HELO`: **<empty>** : 禁用 HELO 操作。

- `HELO_HOSTNAME`: **<empty>** : HELO 操作的自定义主机名。

- ```
  HOST: <empty> : SMTP 邮件主机地址和端口（例如：smtp.gitea.io:587）。
  ```

  - 根据 RFC 8314，如果支持，建议在端口 465 上使用隐式 TLS/SMTPS，否则应使用通过端口 587 上的 STARTTLS 的机会性 TLS。

- ```
  IS_TLS_ENABLED: false : 即使不在默认的 SMTPS 端口上，也强制使用 TLS 进行连接。
  ```

  - 请注意，如果端口以`465`隐式 TLS/SMTPS/SMTP over TLS结尾，则尽管有此设置，但仍将使用。
  - 否则，如果`IS_TLS_ENABLED=false`服务器支持，`STARTTLS`则将使用它。因此，如果`STARTTLS`是首选，您应该设置`IS_TLS_ENABLED=false`.
  
- `FROM`: **<empty>** : Mail from address, RFC 5322。这可以只是一个电子邮件地址，或“名称”<email@example.com> 格式。

- `ENVELOPE_FROM`: **<empty>** : 地址设置为 SMTP 邮件信封上的发件人地址。设置为`<>`发送空地址。

- `USER`: **<empty>** : 邮寄用户的用户名（通常是发件人的电子邮件地址）。

- ```
  PASSWD: <empty> : 邮寄用户的密码。如果您在密码中使用特殊字符，请使用“您的密码”进行引用。
  ```

  - 请注意：仅当使用 TLS（可以通过`STARTTLS`）或对 SMTP 服务器通信进行加密时才支持身份验证`HOST=localhost`。有关详细信息，请参阅[电子邮件设置](https://docs.gitea.io/en-us/email-setup/)。

- `SEND_AS_PLAIN_TEXT`: **false** : 以纯文本形式发送邮件。

- ```
  SKIP_VERIFY: false : 是否跳过证书验证；true禁用验证。
  ```

  - **警告：**此选项不安全。请考虑将证书添加到系统信任库。
  - **注意：** Gitea 只支持带 STARTTLS 的 SMTP。
  
- `USE_CERTIFICATE`: **false** : 使用客户端证书。

- `CERT_FILE`：**自定义/邮件/cert.pem**

- `KEY_FILE`:**自定义/邮件程序/key.pem**

- `SUBJECT_PREFIX`: **<empty>** : 要放在电子邮件主题行之前的前缀。

- ```
  MAILER_TYPE: smtp : [smtp, sendmail, dummy]
  ```

  - **smtp**使用 SMTP 发送邮件
  - **sendmail**使用操作系统的`sendmail`命令而不是 SMTP。这在 linux 系统上很常见。
  - **dummy**将电子邮件消息发送到日志作为测试阶段。
  - 请注意，启用的sendmail会忽略所有其他`mailer`除设置`ENABLED`， `FROM`，`SUBJECT_PREFIX`和`SENDMAIL_PATH`。
  - 启用 dummy 将忽略除`ENABLED`,`SUBJECT_PREFIX`和之外的所有设置`FROM`。

- `SENDMAIL_PATH`: **sendmail** : sendmail 在操作系统上的位置（可以是命令或完整路径）。

- `SENDMAIL_ARGS`: ***empty\*** : 指定任何额外的 sendmail 参数。

- `SENDMAIL_TIMEOUT`: **5m** : 通过 sendmail 发送电子邮件的默认超时时间

- `SEND_BUFFER_LEN`: **100** : 邮件队列的缓冲区长度。**DEPRECATED**使用`LENGTH`在`[queue.mailer]`

## 缓存 ( `cache`)

- `ENABLED`: **true** : 启用缓存。

- `ADAPTER`：**内存**：缓存引擎适配器，要么`memory`，`redis`，`twoqueue`或`memcache`。（`twoqueue`表示大小受限的 LRU 缓存。）

- `INTERVAL`: **60** : 垃圾收集间隔（秒），仅适用于内存和双队列缓存。

- ```
  HOST：<empty>：用于连接字符串redis和memcache用于twoqueue设置队列的配置。
  ```

  - Redis: `redis://:macaron@127.0.0.1:6379/0?pool_size=100&idle_timeout=180s`
  - 内存缓存： `127.0.0.1:9090;127.0.0.1:9091`
  - TwoQueue LRU 缓存：`{"size":50000,"recent_ratio":0.25,"ghost_ratio":0.5}`或`50000`表示缓存中存储的最大对象数。

- `ITEM_TTL`: **16h** : 不使用时将项目保留在缓存中的时间，将其设置为 0 将禁用缓存。

## 缓存 - LastCommitCache 设置 ( `cache.last_commit`)

- `ENABLED`: **true** : 启用缓存。
- `ITEM_TTL`: **8760h** : 不使用时将项目保留在缓存中的时间，将其设置为 0 将禁用缓存。
- `COMMITS_COUNT`: **1000** : 仅当存储库的提交计数大于时才启用缓存。

## 会话 ( `session`)

- `PROVIDER`: **memory** : 会话引擎提供者 [内存、文件、redis、db、mysql、couchbase、memcache、postgres]。
- `PROVIDER_CONFIG`: **data/sessions** : 对于文件，根路径；对于 db，为空（将使用数据库配置）；对于其他人，连接字符串。
- `COOKIE_SECURE`: **false** : 启用此选项可强制对所有会话访问使用 HTTPS。
- `COOKIE_NAME`: **i_like_gitea** : 用于会话 ID 的 cookie 的名称。
- `GC_INTERVAL_TIME`: **86400** : GC 间隔（以秒为单位）。
- `SESSION_LIFE_TIME`: **86400** : 会话生存时间（以秒为单位），默认为 86400（1 天）
- `DOMAIN`: **<empty>** : 设置cookie域
- `SAME_SITE`: **lax** [strict, lax, none]: 设置 cookie 的 SameSite 设置。

## 图片 ( `picture`)

- `GRAVATAR_SOURCE`: **gravatar** : 可以`gravatar`，`duoshuo`或者类似的 `http://cn.gravatar.com/avatar/`。
- `DISABLE_GRAVATAR`: **false** : 启用此选项以仅使用本地头像。
- `ENABLE_FEDERATED_AVATAR`: **false**：启用对联合头像的支持（请参阅 [http://www.libravatar.org](http://www.libravatar.org/)）。
- `AVATAR_STORAGE_TYPE`：**default**： 中定义的存储类型`[storage.xxx]`。如果没有部分是 type `default`，则默认为读取。`[storage]``[storage]``local`
- `AVATAR_UPLOAD_PATH`: **data/avatars** : 存储用户头像图像文件的路径。
- `AVATAR_MAX_WIDTH`：**4096**：最大头像图像宽度（以像素为单位）。
- `AVATAR_MAX_HEIGHT`：**3072**：最大头像图像高度（以像素为单位）。
- `AVATAR_MAX_FILE_SIZE`：**1048576** (1Mb)：最大头像图像文件大小（以字节为单位）。
- `REPOSITORY_AVATAR_STORAGE_TYPE`：**default**： 中定义的存储类型`[storage.xxx]`。如果没有部分是 type `default`，则默认为读取。`[storage]``[storage]``local`
- `REPOSITORY_AVATAR_UPLOAD_PATH`: **data/repo-avatars** : 存储库头像图像文件的路径。
- `REPOSITORY_AVATAR_FALLBACK`: **none** : Gitea 如何处理缺少的仓库头像
  - none = 不显示头像
  - random = 将生成随机头像
  - 图像 = 将使用默认图像（在 中设置`REPOSITORY_AVATAR_FALLBACK_IMAGE`）
- `REPOSITORY_AVATAR_FALLBACK_IMAGE`: **/img/repo_default.png** : 用作默认存储库头像的`REPOSITORY_AVATAR_FALLBACK`图像（如果设置为图像并且没有上传）

## 项目 ( `project`)

项目板的默认模板：

- `PROJECT_BOARD_BASIC_KANBAN_TYPE`::**To Do, In Progress, Done**
- `PROJECT_BOARD_BUG_TRIAGE_TYPE`：**Needs Triage, High Priority, Low Priority, Closed**

## 问题和拉取请求附件 ( `attachment`)

- `ENABLED`: **true** : 是否启用问题和拉取请求附件。
- `ALLOWED_TYPES`: **.docx,.gif,.gz,.jpeg,.jpg,.log,.pdf,.png,.pptx,.txt,.xlsx,.zip** : 逗号分隔的允许文件扩展名列表 ( `.zip`), mime 类型( `text/plain`) 或通配符类型 ( `image/*`, `audio/*`, `video/*`)。空值或`*/*`允许所有类型。
- `MAX_SIZE`: **4** : 最大大小 (MB)。
- `MAX_FILES`: **5** : 一次可以上传的最大附件数。
- `STORAGE_TYPE`: **local** : 附件、`local`本地磁盘或`minio`s3 兼容对象存储服务的存储类型，默认为`local`或其他名称定义`[storage.xxx]`
- `SERVE_DIRECT`: **false** : 允许存储驱动程序重定向到经过身份验证的 URL 以直接提供文件。目前，仅通过签名 URL 支持 Minio/S3，本地不执行任何操作。
- `PATH`：**data/attachments**：存储附件的路径仅在 STORAGE_TYPE 为`local`
- `MINIO_ENDPOINT`: **localhost:9000** : Minio 端点仅在 STORAGE_TYPE 时可用`minio`
- `MINIO_ACCESS_KEY_ID`: Minio accessKeyID 仅当 STORAGE_TYPE 为连接时可用 `minio`
- `MINIO_SECRET_ACCESS_KEY`: Minio secretAccessKey 仅当 STORAGE_TYPE 为连接时可用 `minio`
- `MINIO_BUCKET`: **gitea** : **Minio** bucket 用于存储仅当 STORAGE_TYPE**为时**可用的附件`minio`
- `MINIO_LOCATION`: **us-east-1** : Minio location to create bucket only 当 STORAGE_TYPE 是`minio`
- `MINIO_BASE_PATH`：**attachments/**：存储桶上的 Minio 基本路径仅在 STORAGE_TYPE 为`minio`
- `MINIO_USE_SSL`: **false** : Minio 启用 ssl 仅当 STORAGE_TYPE 为`minio`

## 时间 ( `cron`)

- `ENABLED`: **false** : 启用以使用默认设置定期运行所有 cron 任务。
- `RUN_AT_START`: **false** : 在应用程序启动时运行 cron 任务。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE` 接受格式
  - 完整的 crontab 规格，例如 `* * * * * ?`
  - 描述符，例如`@midnight`，`@every 1h30m`...
  - 查看更多：[cron decment](https://pkg.go.dev/github.com/gogs/cron@v0.0.0-20171120032916-9f6c956d3e14)

### 基本 cron 任务 - 默认启用

#### Cron - 清理旧的存储库档案 ( `cron.archive_cleanup`)

- `ENABLED`: **true** : 启用服务。
- `RUN_AT_START`: **true** : 在启动时运行任务（如果已启用）。
- `SCHEDULE`：**@midnight**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.
- `OLDER_THAN`: **24h** :`OLDER_THAN`多年前创建的档案可能会被删除，例如`12h`。

#### Cron - 更新镜像 ( `cron.update_mirrors`)

- `SCHEDULE`: **@every 10m** : 调度更新镜像的 Cron 语法，例如`@every 3h`.
- `NO_SUCCESS_NOTICE`: **true** : 更新镜像成功报告的 cron 任务不是很有用 - 因为它只是意味着镜像已经排队。因此，默认情况下这是关闭的。
- `PULL_LIMIT`: **50** : 将添加到队列中的镜像数量限制为此数量（负值表示没有限制，0 将导致没有镜像排队有效禁用拉取镜像更新）。
- `PUSH_LIMIT`: **50** : 将添加到队列中的镜像数量限制为此数量（负值表示没有限制，0 将导致没有镜像排队有效禁用推送镜像更新）。

#### Cron - 存储库健康检查 ( `cron.repo_health_check`)

- `SCHEDULE`: **@midnight** : 用于安排存储库健康检查的 Cron 语法。
- `TIMEOUT`: **60s** : 健康检查执行超时的持续时间语法。
- `ARGS`: **<empty>** : 命令的参数`git fsck`，例如`--unreachable --tags`. 在http://git-scm.com/docs/git-fsck上查看更多信息

#### Cron - 存储库统计信息检查 ( `cron.check_repo_stats`)

- `RUN_AT_START`: **true** : 在开始时运行存储库统计信息检查。
- `SCHEDULE`：**@midnight**：用于调度存储库统计信息检查的 Cron 语法。

### Cron - 清理 hook_task 表 ( `cron.cleanup_hook_task_table`)

- `ENABLED`: **true** : 启用清理 hook_task 作业。
- `RUN_AT_START`: **false** : 在开始时运行清理 hook_task（如果已启用）。
- `SCHEDULE`：**@midnight**：用于清理 hook_task 表的 Cron 语法。
- `CLEANUP_TYPE` **OlderThan** OlderThan 或 PerWebhook 清除 hook_task 的方法，可以通过年龄（即 hook_task 记录交付的时间）或每个 webhook 保留的数量（即保留每个 webhook 的最近 x 次交付）。
- `OLDER_THAN`: **168h** : 如果 CLEANUP_TYPE 设置为 OlderThan，则任何早于此表达式的已传递 hook_task 记录都将被删除。
- `NUMBER_TO_KEEP`: **10** : 如果 CLEANUP_TYPE 设置为 PerWebhook，这是为 webhook 保留的 hook_task 记录数（即保留最近的 x 次交付）。

#### Cron - 更新迁移海报 ID ( `cron.update_migration_poster_id`)

- `SCHEDULE`: **@midnight** : Interval 作为每次同步之间的持续时间，它总是在实例启动时尝试同步。

#### Cron - 同步外部用户 ( `cron.sync_external_users`)

- `SCHEDULE`: **@midnight** : Interval 作为每次同步之间的持续时间，它总是在实例启动时尝试同步。
- `UPDATE_EXISTING`: **true** : 创建新用户，更新现有用户数据并禁用不再位于外部源中的用户（默认）或仅在 UPDATE_EXISTING 设置为 false 时创建新用户。

### 扩展 cron 任务（默认未启用）

#### Cron - 垃圾收集所有存储库（'cron.git_gc_repos'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.
- `TIMEOUT`: **60s** : 垃圾收集执行超时的持续时间语法。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `ARGS`: **<empty>** : 命令的参数`git gc`，例如`--aggressive --auto`. 默认值与 [git] -> GC_ARGS 相同

#### Cron - 使用 Gitea SSH 密钥更新“.ssh/authorized_keys”文件（“cron.resync_all_sshkeys”）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.

#### Cron - 重新同步所有存储库的预接收、更新和接收后挂钩（'cron.resync_all_hooks'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.

#### Cron - 重新初始化存在记录的所有丢失的 Git 存储库（'cron.reinit_missing_repos'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.

#### Cron - 删除所有缺少 Git 文件的存储库（'cron.delete_missing_repos'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.

#### Cron - 删除生成的存储库头像（'cron.delete_generated_repository_avatars'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`：**@every 72h**：用于安排存储库归档清理的 Cron 语法，例如`@every 1h`.

#### Cron - 从数据库中删除所有旧操作（'cron.delete_old_actions'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `NO_SUCCESS_NOTICE`: **false** : 设置为 true 以关闭成功通知。
- `SCHEDULE`: **@every 168h** : Cron 语法来设置检查的频率。
- `OLDER_THAN`: **@every 8760h** : 任何早于此表达式的操作都将从数据库中删除，建议使用`8760h`(1 year) 因为这是热图的最大长度。

#### Cron - 检查新的 Gitea 版本（'cron.update_checker'）

- `ENABLED`: **false** : 启用服务。
- `RUN_AT_START`: **false** : 在启动时运行任务（如果已启用）。
- `ENABLE_SUCCESS_NOTICE`: **true** : 设置为 false 以关闭成功通知。
- `SCHEDULE`：**@every 168h**：用于安排工作的 Cron 语法，例如`@every 168h`.
- `HTTP_ENDPOINT`：**https://dl.gitea.io/gitea/version.json**：Gitea 将检查更新版本的端点

## 吉特 ( `git`)

- `PATH`: **""** : git 可执行文件的路径。如果为空，Gitea 会搜索 PATH 环境。
- `DISABLE_DIFF_HIGHLIGHT`: **false** : 禁用添加和删除更改的突出显示。
- `MAX_GIT_DIFF_LINES`: **1000** : diff 视图中单个文件允许的最大行数。
- `MAX_GIT_DIFF_LINE_CHARACTERS`: **5000** : 在差异视图中突出显示的每行最大字符数。
- `MAX_GIT_DIFF_FILES`: **100** : 差异视图中显示的最大文件数。
- `COMMITS_RANGE_SIZE`: **50** : 设置默认提交范围大小
- `BRANCHES_RANGE_SIZE`: **20** : 设置默认分支范围大小
- `GC_ARGS`: **<empty>** : 命令的参数`git gc`，例如`--aggressive --auto`. 在http://git-scm.com/docs/git-gc/上查看更多信息
- `ENABLE_AUTO_GIT_WIRE_PROTOCOL`: **true** : 如果在 git version >= 2.18 时使用 git wire 协议版本 2，默认为 true，当你总是想要 git wire 协议版本 1 时设置为 false
- `PULL_REQUEST_PUSH_MESSAGE`: **true** : 响应推送到非默认分支的 URL 以创建拉取请求（如果存储库启用了它们）
- `VERBOSE_PUSH`: **true** : 在处理推送时打印有关推送的状态信息。
- `VERBOSE_PUSH_DELAY`: **5s** : 如果推送时间超过此延迟，则仅打印详细信息。
- `LARGE_OBJECT_THRESHOLD`：**1048576**：（仅限 Go-Git），不要在内存中缓存大于此值的对象。（设置为 0 以禁用。）
- `DISABLE_CORE_PROTECT_NTFS`: **false**设置为true 强制设置`core.protectNTFS`为false。

## Git - 超时设置 ( `git.timeout`)

- `DEFAUlT`: **360** : Git 操作默认超时秒数。
- `MIGRATE`: **600** : 迁移外部存储库超时秒数。
- `MIRROR`: **300** : 镜像外部存储库超时秒数。
- `CLONE`: **300** : Git 克隆从内部存储库超时秒。
- `PULL`: **300** : Git 从内部存储库中拉取超时秒数。
- `GC`: **60** : Git 存储库 GC 超时秒数。

## 指标 ( `metrics`)

- `ENABLED`: **false** : 为 prometheus 启用 /metrics 端点。
- `ENABLED_ISSUE_BY_LABEL`: **false** : 通过带有格式的标签指标启用问题`gitea_issues_by_label{label="bug"} 2`。
- `ENABLED_ISSUE_BY_REPOSITORY`: **false** : 按格式的存储库指标启用问题`gitea_issues_by_repository{repository="org/repo"} 5`。
- `TOKEN`: **<empty>** : 如果要在授权中包含指标，则需要指定令牌。需要在 prometheus 参数`bearer_token`或`bearer_token_file`.

## 原料药 ( `api`)

- `ENABLE_SWAGGER`: **true** : 启用 /api/swagger、/api/v1/swagger 等端点。对或错; 默认为真。
- `MAX_RESPONSE_ITEMS`: **50** : 页面中的最大项目数。
- `DEFAULT_PAGING_NUM`: **30** : API 的默认分页数。
- `DEFAULT_GIT_TREES_PER_PAGE`: **1000** : git 树 API 每页的默认和最大项目数。
- `DEFAULT_MAX_BLOB_SIZE`：**10485760**：blob API 可以返回的 blob 的默认最大大小。

## OAuth2 ( `oauth2`)

- `ENABLE`: **true** : 启用 OAuth2 提供程序。
- `ACCESS_TOKEN_EXPIRATION_TIME`: **3600** : OAuth2 访问令牌的生命周期（以秒为单位）
- `REFRESH_TOKEN_EXPIRATION_TIME`：**730**：OAuth2 刷新令牌的生命周期（以小时为单位）
- `INVALIDATE_REFRESH_TOKENS`: **false** : 检查刷新令牌是否已被使用
- `JWT_SIGNING_ALGORITHM`: **RS256** : 用于签署 OAuth2 令牌的算法。有效值： [ `HS256`, `HS384`, `HS512`, `RS256`, `RS384`, `RS512`, `ES256`, `ES384`, `ES512`]
- `JWT_SECRET`: **<empty>** : 用于访问和刷新令牌的 OAuth2 身份验证密钥，将其更改为唯一字符串。仅当`JWT_SIGNING_ALGORITHM`设置为`HS256`、`HS384`或时才需要此设置`HS512`。
- `JWT_SIGNING_PRIVATE_KEY_FILE`: **jwt/private.pem** : 用于签署 OAuth2 令牌的私钥文件路径。路径是相对于`APP_DATA_PATH`. 如果只需要该设置`JWT_SIGNING_ALGORITHM`设定的到`RS256`，`RS384`，`RS512`，`ES256`，`ES384`或`ES512`。该文件必须包含 PKCS8 格式的 RSA 或 ECDSA 私钥。如果不存在密钥，将为您创建一个 4096 位的密钥。
- `MAX_TOKEN_LENGTH`：**32767**：从 OAuth2 提供者接受的令牌/cookie 的最大长度

## i18n ( `i18n`)

- `LANGS`: **en-US,zh-CN,zh-HK,zh-TW,de-DE,fr-FR,nl-NL,lv-LV,ru-RU,ja-JP,es-ES,pt-BR,pt -PT,pl-PL,bg-BG,it-IT,fi-FI,tr-TR,cs-CZ,sr-SP,sv-SE,ko-KR,el-GR,fa-IR,hu-HU ,id-ID,ml-IN** : 语言选择器中显示的区域设置列表
- `NAMES`: **English,简体中文,繁体中文（香港）,繁体中文（台湾）,Deutsch,français,Nederlands,latviešu,русский,日本语,español,português do Brasil,Português de Portugal,polski,български,italiano,suomi,Türke ,čeština,српски,svenska,한국어,ελληνικά,فارسی,magyar nyelv,bahasa Indonesia,മലയാളം** : 对应于语言环境的可见名称

## U2F ( `U2F`)

- `APP_ID`::**`ROOT_URL`**声明应用程序的方面。需要 HTTPS。
- `TRUSTED_FACETS`：受信任的其他方面的列表。并非所有浏览器都支持此功能。

## 标记 ( `markup`)

- `MERMAID_MAX_SOURCE_CHARACTERS`: **5000** : 设置美人鱼源的最大尺寸。（设置为 -1 以禁用）

Gitea 可以使用外部工具支持标记。下面的示例将添加一个名为`asciidoc`.

```ini
[markup.asciidoc]
ENABLED = true
NEED_POSTPROCESS = true
FILE_EXTENSIONS = .adoc,.asciidoc
RENDER_COMMAND = "asciidoc --out-file=- -"
IS_INPUT_FILE = false
```

- ENABLED: **false**启用标记支持；设置为**true**以启用此渲染器。
- NEED_POSTPROCESS: **true**设置为**true**以替换链接/sha1 等。
- FILE_EXTENSIONS: **<empty>**应由外部命令呈现的文件扩展名列表。多个扩展名需要一个逗号作为分隔符。
- RENDER_COMMAND：渲染所有匹配扩展的外部命令。
- IS_INPUT_FILE: **false**输入不是标准输入，而是后跟的文件参数`RENDER_COMMAND`。

两个特殊的环境变量被传递给渲染命令：

- `GITEA_PREFIX_SRC`，其中包含`src`路径树中的当前 URL 前缀。用作链接的前缀。
- `GITEA_PREFIX_RAW`，其中包含`raw`路径树中的当前 URL 前缀。用作图像路径的前缀。

Gitea 支持为呈现的 HTML 自定义清理策略。下面的示例将支持 pandoc 的 KaTeX 输出。

```ini
[markup.sanitizer.TeX]
; Pandoc renders TeX segments as <span>s with the "math" class, optionally
; with "inline" or "display" classes depending on context.
ELEMENT = span
ALLOW_ATTR = class
REGEXP = ^\s*((math(\s+|$)|inline(\s+|$)|display(\s+|$)))+
ALLOW_DATA_URI_IMAGES = true
```

- `ELEMENT`：此政策适用的元素。必须非空。
- `ALLOW_ATTR`：此策略允许的属性。必须非空。
- `REGEXP`：匹配属性内容的正则表达式。必须存在，但对于此属性的无条件白名单可能为空。
- `ALLOW_DATA_URI_IMAGES`: **false**允许数据 uri 图像 ( `<img src="data:image/png;base64,..."/>`)。

可以通过添加独特的小节来定义多个清理规则，例如`[markup.sanitizer.TeX-2]`。要仅对指定的外部渲染器应用清理规则，它们必须使用渲染器名称，例如`[markup.sanitizer.asciidoc.rule-1]`. 如果规则定义在渲染器 ini 部分之上，或者名称与渲染器不匹配，则它将应用于每个渲染器。

## 突出显示映射 ( `highlight.mapping`)

- `file_extension e.g. .toml`:**语言，例如 ini**。语言映射覆盖的文件扩展名。
- 如果可用，Gitea 将使用文件中的`linguist-language`或`gitlab-language`属性突出显示文件`.gitattributes`。如果未设置或语言不可用，则将在此映射或文件类型中使用试探法查找文件扩展名。

## 时间 ( `time`)

- `FORMAT`: 在 UI 上显示的时间格式。即 RFC1123 或 2006-01-02 15:04:05
- `DEFAULT_UI_LOCATION`: 时间在 UI 上的默认位置，以便我们可以在 UI 上显示正确的用户时间。即上海/亚洲

## 任务 ( `task`)

任务队列配置已移至`queue.task`. 但是，为了向后兼容，保留了以下配置值：

- `QUEUE_TYPE`: **channel** : 任务队列类型，可以是`channel`或`redis`。
- `QUEUE_LENGTH`: **1000** : 任务队列长度，仅当`QUEUE_TYPE`为时可用`channel`。
- `QUEUE_CONN_STR`: **redis://127.0.0.1:6379/0** : 任务队列连接字符串，仅当`QUEUE_TYPE`是时可用`redis`。如果 redis 需要密码，请使用`redis://123@127.0.0.1:6379/0`.

## 迁移 ( `migrations`)

- `MAX_ATTEMPTS`: **3** : 迁移时每个 http/https 请求的最大尝试次数。
- `RETRY_BACKOFF`: **3** : 每个 http/https 请求重试的退避时间（秒）
- `ALLOWED_DOMAINS`: **<empty>** : 用于迁移存储库的域许可名单，默认为空。这意味着一切都将被允许。多个域可以用逗号分隔。
- `BLOCKED_DOMAINS`: **<empty>** : 用于迁移存储库的域阻止列表，默认为空白。多个域可以用逗号分隔。当`ALLOWED_DOMAINS`不为空时，此选项具有更高的优先级拒绝域。
- `ALLOW_LOCALNETWORKS`: **false** : 允许 RFC 1918、RFC 1122、RFC 4632 和 RFC 4291 定义的私有地址
- `SKIP_TLS_VERIFY`: **false** : 允许跳过 tls 验证

## 联邦 ( `federation`)

- `ENABLED`: **true** : 启用/禁用联合功能

## 镜子 ( `mirror`)

- `ENABLED`: **true** : 启用镜像功能。设置为**false**以禁用所有镜像。
- `DISABLE_NEW_PULL`: **false** : 禁止创建**新的**拉取镜像。预先存在的镜像仍然有效。如果`mirror.ENABLED`是，将被忽略`false`。
- `DISABLE_NEW_PUSH`: **false** : 禁止创建**新的**推送镜像。预先存在的镜像仍然有效。如果`mirror.ENABLED`是，将被忽略`false`。
- `DEFAULT_INTERVAL`: **8h** : 每次检查之间的默认间隔
- `MIN_INTERVAL`: **10m** : 检查的最小间隔。（必须>1m）。

## LFS ( `lfs`)

lfs 数据的存储配置。它将从默认值`[storage]`或 `[storage.xxx]`设置`STORAGE_TYPE`为`xxx`. 派生时，默认`PATH` 为`data/lfs`，默认`MINIO_BASE_PATH`为`lfs/`。

- `STORAGE_TYPE`: **local** : lfs 的存储类型、`local`本地磁盘或`minio`s3 兼容的对象存储服务或其他定义的名称`[storage.xxx]`
- `SERVE_DIRECT`: **false** : 允许存储驱动程序重定向到经过身份验证的 URL 以直接提供文件。目前，仅通过签名 URL 支持 Minio/S3，本地不执行任何操作。
- `PATH`：**./data/lfs**：在何处存放LFS文件，只有当可用`STORAGE_TYPE`的`local`。如果未设置，则回退到 [server] 部分中已弃用的 LFS_CONTENT_PATH 值。
- `MINIO_ENDPOINT`：**本地主机：9000**：Minio端点连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_ACCESS_KEY_ID`：Minio accessKeyID连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_SECRET_ACCESS_KEY`: Minio secretAccessKey 仅在连接时可用 `STORAGE_TYPE is` `minio`
- `MINIO_BUCKET`：**gitea**：Minio桶存放LFS仅当`STORAGE_TYPE`是`minio`
- `MINIO_LOCATION`: **us-east-1** : Minio location to create bucket only available when `STORAGE_TYPE`is`minio`
- `MINIO_BASE_PATH`：**LFS /**：在铲斗Minio基路径仅当可用`STORAGE_TYPE`是`minio`
- `MINIO_USE_SSL`: **false** : Minio 启用 ssl 仅在以下`STORAGE_TYPE`情况下可用`minio`

## 存储 ( `storage`)

附件、lfs、头像等的默认存储配置。

- `SERVE_DIRECT`: **false** : 允许存储驱动程序重定向到经过身份验证的 URL 以直接提供文件。目前，仅通过签名 URL 支持 Minio/S3，本地不执行任何操作。
- `MINIO_ENDPOINT`：**本地主机：9000**：Minio端点连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_ACCESS_KEY_ID`：Minio accessKeyID连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_SECRET_ACCESS_KEY`: Minio secretAccessKey 仅在连接时可用 `STORAGE_TYPE is` `minio`
- `MINIO_BUCKET`：**gitea**：Minio桶存储唯一可用的数据时`STORAGE_TYPE`是`minio`
- `MINIO_LOCATION`: **us-east-1** : Minio location to create bucket only available when `STORAGE_TYPE`is`minio`
- `MINIO_USE_SSL`: **false** : Minio 启用 ssl 仅在以下`STORAGE_TYPE`情况下可用`minio`

您还可以定义自定义存储，如下所示：

```ini
[storage.my_minio]
STORAGE_TYPE = minio
; Minio endpoint to connect only available when STORAGE_TYPE is `minio`
MINIO_ENDPOINT = localhost:9000
; Minio accessKeyID to connect only available when STORAGE_TYPE is `minio`
MINIO_ACCESS_KEY_ID =
; Minio secretAccessKey to connect only available when STORAGE_TYPE is `minio`
MINIO_SECRET_ACCESS_KEY =
; Minio bucket to store the attachments only available when STORAGE_TYPE is `minio`
MINIO_BUCKET = gitea
; Minio location to create bucket only available when STORAGE_TYPE is `minio`
MINIO_LOCATION = us-east-1
; Minio enabled ssl only available when STORAGE_TYPE is `minio`
MINIO_USE_SSL = false
```

并由`[attachment]`、`[lfs]`等用作`STORAGE_TYPE`。

## 存储库归档存储 ( `storage.repo-archive`)

存储库归档存储的配置。它将继承默认值`[storage]`或 `[storage.xxx]`设置`STORAGE_TYPE`为`xxx`. 默认`PATH` 为`data/repo-archive`，默认`MINIO_BASE_PATH`为`repo-archive/`。

- `STORAGE_TYPE`: **local** : 存储类型，用于 repo 存档、`local`本地磁盘或`minio`s3 兼容对象存储服务或其他定义的名称`[storage.xxx]`
- `SERVE_DIRECT`: **false** : 允许存储驱动程序重定向到经过身份验证的 URL 以直接提供文件。目前，仅通过签名 URL 支持 Minio/S3，本地不执行任何操作。
- `PATH`：**./data/repo-archive**：在何处存放档案文件，仅当`STORAGE_TYPE`是`local`。
- `MINIO_ENDPOINT`：**本地主机：9000**：Minio端点连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_ACCESS_KEY_ID`：Minio accessKeyID连接仅当`STORAGE_TYPE`是`minio`
- `MINIO_SECRET_ACCESS_KEY`: Minio secretAccessKey 仅在连接时可用 `STORAGE_TYPE is` `minio`
- `MINIO_BUCKET`：**gitea**：Minio桶存放LFS仅当`STORAGE_TYPE`是`minio`
- `MINIO_LOCATION`: **us-east-1** : Minio location to create bucket only available when `STORAGE_TYPE`is`minio`
- `MINIO_BASE_PATH`：**回购存档/**：在桶Minio基本路径时，才可`STORAGE_TYPE`为`minio`
- `MINIO_USE_SSL`: **false** : Minio 启用 ssl 仅在以下`STORAGE_TYPE`情况下可用`minio`

## 代理 ( `proxy`)

- `PROXY_ENABLED`: **false** : 如果为true，则启用代理，所有通过HTTP向外部发出的请求都会受到影响，如果为false，则即使环境http_proxy/https_proxy也不使用代理
- `PROXY_URL`: **<empty>** : 代理服务器地址，支持http://、https//、socks://，空白会跟随环境http_proxy/https_proxy
- `PROXY_HOSTS`: **<empty>** : 需要代理的主机名的逗号分隔列表。接受全局模式 (*)；使用 ** 匹配所有主机。

IE

```ini
PROXY_ENABLED = true
PROXY_URL = socks://127.0.0.1:1080
PROXY_HOSTS = *.github.com
```

## 其他 ( `other`)

- `SHOW_FOOTER_BRANDING`: **false** : 在页脚中显示 Gitea 品牌。
- `SHOW_FOOTER_VERSION`: **true** : 在页脚中显示 Gitea 和 Go 版本信息。
- `SHOW_FOOTER_TEMPLATE_LOAD_TIME`: **true** : 在页脚中显示模板执行的时间。