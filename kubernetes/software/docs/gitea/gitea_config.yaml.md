```yaml
gitea:
  config:
    default:
      !APP_NAME: Gitea
      !RUN_USER: git
      !RUN_MODE: prod
    repository:
      # ROOT: data/gitea-repositories/
      # SCRIPT_TYPE: bash
      # DETECTED_CHARSETS_ORDER: UTF-8, UTF-16BE, UTF-16LE, UTF-32BE, UTF-32LE, ISO-8859, windows-1252, ISO-8859, windows-1250, ISO-8859, ISO-8859, ISO-8859, windows -1253, ISO-8859, windows-1255, ISO-8859, windows-1251, windows-1256, KOI8-R, ISO-8859, windows-1254, Shift_JIS, GB18030, EUC-JP, EUC-KR, Big5, ISO -2022、ISO-2022、ISO-2022、IBM424_rtl、IBM424_ltr、IBM420_rtl、IBM420_ltr
      # ANSI_CHARSET: <empty> 
      # FORCE_PRIVATE: false
      # DEFAULT_PRIVATE: last
      # DEFAULT_PUSH_CREATE_PRIVATE: true
      !MAX_CREATION_LIMIT: -1
      # PULL_REQUEST_QUEUE_LENGTH: 1000
      # MIRROR_QUEUE_LENGTH: 1000
      # PREFERRED_LICENSES: Apache License 2.0,MIT License
      # DISABLE_HTTP_GIT: false
      # USE_COMPAT_SSH_URI: false
      !ACCESS_CONTROL_ALLOW_ORIGIN: <empty> 
      # DEFAULT_CLOSE_ISSUES_VIA_COMMITS_IN_ANY_BRANCH: false
      # ENABLE_PUSH_CREATE_USER: false 
      # ENABLE_PUSH_CREATE_ORG: false 
      !DISABLED_REPO_UNITS: empty
      # DEFAULT_REPO_UNITS: repo.code,repo.releases,repo.issues,repo.pulls,repo.wiki,repo.projects
      !PREFIX_ARCHIVE_FILES: true
      # DISABLE_MIGRATIONS: false
      !DISABLE_STARS: true
      # DEFAULT_BRANCH: master
      !ALLOW_ADOPTION_OF_UNADOPTED_REPOSITORIES: false
      !ALLOW_DELETION_OF_UNADOPTED_REPOSITORIES: false 
      editor:
        # LINE_WRAP_EXTENSIONS: .txt,.md,.markdown,.mdown,.mkd
        # PREVIEWABLE_FILE_MODES: markdown
      pull-request:
        !WORK_IN_PROGRESS_PREFIXES: WIP:,[WIP]
        # CLOSE_KEYWORDS: close, closes, closed, fix, fixes, fixed, resolve, resolves, resolved
        # REOPEN_KEYWORDS: reopen, reopens, reopened
        # DEFAULT_MERGE_MESSAGE_COMMITS_LIMIT: 50
        # DEFAULT_MERGE_MESSAGE_SIZE: 5120
        # DEFAULT_MERGE_MESSAGE_ALL_AUTHORS: false
        # DEFAULT_MERGE_MESSAGE_MAX_APPROVERS: 10
        # DEFAULT_MERGE_MESSAGE_OFFICIAL_APPROVERS_ONLY: true
        # POPULATE_SQUASH_COMMENT_WITH_COMMIT_MESSAGES: false
        # ADD_CO_COMMITTER_TRAILERS: true
      issue:
        # LOCK_REASONS: Too heated,Off-topic,Resolved,Spam
      upload:
        # ENABLED: true
        # TEMP_PATH: data/tmp/uploads
        !ALLOWED_TYPES: 
        # FILE_MAX_SIZE: 3
        # MAX_FILES: 5
      release:
        !ALLOWED_TYPES: 
        # DEFAULT_PAGING_NUM: 10
      !!!signing:
        SIGNING_KEY: default
      local:
        # LOCAL_COPY_PATH: tmp/local-repo
      mimetype_mapping:
        # Content-Type: application/vnd.android.package-archive
    !!!cors:
      !ENABLED: false
      !SCHEME: http
      !ALLOW_DOMAIN: *****
      !ALLOW_SUBDOMAIN: false
      !METHODS: GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS
      !MAX_AGE: 10m
      !ALLOW_CREDENTIALS: false
      !X_FRAME_OPTIONS: SAMEORIGIN
    ui:
      # EXPLORE_PAGING_NUM: 20
      # ISSUE_PAGING_NUM: 10
      # MEMBERS_PAGING_NUM: 20
      # FEED_MAX_COMMIT_NUM: 5
      # FEED_PAGING_NUM: 20
      # GRAPH_MAX_COMMIT_NUM: 100
      !CODE_COMMENT_LINES: 4
      # DEFAULT_THEME: auto
      !SHOW_USER_EMAIL: false
      # THEMES: auto,gitea,arc-green
      # THEME_COLOR_META_TAG: #6cc644
      # MAX_DISPLAY_FILE_SIZE: 8388608
      !REACTIONS: 
      # CUSTOM_EMOJIS: gitea, codeberg, gitlab, git, github, gogs
      # DEFAULT_SHOW_FULL_NAME: false
      # SEARCH_REPO_DESCRIPTION: true
      # USE_SERVICE_WORKER: true
      admin:
        # USER_PAGING_NUM: 50
        # REPO_PAGING_NUM: 50
        # NOTICE_PAGING_NUM: 25
        # ORG_PAGING_NUM: 50
      meta: 
        !AUTHOR: Gitea - Git with a cup of tea
        !DESCRIPTION: Gitea (Git with a cup of tea) is a painless self-hosted Git service written in Go
        !EYWORDS: go,git,self-hosted,gitea
      notification:
        # MIN_TIMEOUT: 10s
        # MAX_TIMEOUT: 60s
        # TIMEOUT_STEP: 10s
        # EVENT_SOURCE_UPDATE_TIME: 10s
      images:
        # ENABLE_RENDER: true
      csv:
        # MAX_FILE_SIZE: 524288 (512kb)
    markdown:
      # ENABLE_HARD_LINE_BREAK_IN_COMMENTS: true
      # ENABLE_HARD_LINE_BREAK_IN_DOCUMENTS: false
      !CUSTOM_URL_SCHEMES: 
    server:
      !PROTOCOL: http
      !DOMAIN: localhost
      # ROOT_URL: %(PROTOCOL)s://%(DOMAIN)s:%(HTTP_PORT)s/
      # STATIC_URL_PREFIX: 
      !HTTP_ADDR: 0.0.0.0
      !HTTP_PORT: 3000
      # UNIX_SOCKET_PERMISSION: 666
      # LOCAL_ROOT_URL: %(PROTOCOL)s://%(HTTP_ADDR)s:%(HTTP_PORT)s/
      # PER_WRITE_TIMEOUT: 30s
      # PER_WRITE_PER_KB_TIMEOUT: 10s
      # DISABLE_SSH: false
      # START_SSH_SERVER: false
      # BUILTIN_SSH_SERVER_USER: %(RUN_USER)s
      !SSH_DOMAIN: %(DOMAIN)s
      !SSH_PORT: 22
      !SSH_LISTEN_HOST: 0.0.0.0
      !SSH_LISTEN_PORT: %(SSH_PORT)s
      # SSH_ROOT_PATH: ~/.ssh
      # SSH_CREATE_AUTHORIZED_KEYS_FILE: true
      # SSH_AUTHORIZED_KEYS_BACKUP: true
      !SSH_TRUSTED_USER_CA_KEYS: 
      # SSH_TRUSTED_USER_CA_KEYS_FILENAME: RUN_USER/.ssh/gitea-trusted-user-ca-keys.pem
      !SSH_AUTHORIZED_PRINCIPALS_ALLOW: off or username, email
      # SSH_CREATE_AUTHORIZED_PRINCIPALS_FILE: false/true
      # SSH_AUTHORIZED_PRINCIPALS_BACKUP: false/true
      # SSH_AUTHORIZED_KEYS_COMMAND_TEMPLATE: {{.AppPath}} –config={{.CustomConf}} serv key-{{.Key.ID}}
      # SSH_SERVER_CIPHERS: aes128-ctr, aes192-ctr, aes256-ctr, aes128-gcm@openssh.com, arcfour256, arcfour128
      # SSH_SERVER_KEY_EXCHANGES: diffie-hellman-group1-sha1, diffie-hellman-group14-sha1, ecdh-sha2-nistp256, ecdh-sha2-nistp384, ecdh-sha2-nistp521, curve25519-sha256@libssh.org
      # SSH_SERVER_MACS: hmac-sha2-256-etm@openssh.com, hmac-sha2-256, hmac-sha1, hmac-sha1-96
      # SSH_SERVER_HOST_KEYS: ssh/gitea.rsa, ssh/gogs.rsa
      # SSH_KEY_TEST_PATH: /tmp
      # SSH_KEYGEN_PATH: ssh-keygen
      # SSH_EXPOSE_ANONYMOUS: false
      # SSH_PER_WRITE_TIMEOUT: 30s
      # SSH_PER_WRITE_PER_KB_TIMEOUT: 10s
      # MINIMUM_KEY_SIZE_CHECK: true
      # OFFLINE_MODE: false
      # DISABLE_ROUTER_LOG: false
      !CERT_FILE: https/cert.pem
      !KEY_FILE: https/key.pem
      # STATIC_ROOT_PATH: ./
      !APP_DATA_PATH: data (/data/gitea on docker)
      # STATIC_CACHE_TIME: 6h
      # ENABLE_GZIP: false
      # ENABLE_PPROF: false
      !PPROF_DATA_PATH: data/tmp/pprof
      !LANDING_PAGE: home
      # LFS_START_SERVER: false
      # LFS_CONTENT_PATH: %(APP_DATA_PATH)/lfs
      # LFS_JWT_SECRET: 
      # LFS_HTTP_AUTH_EXPIRY: 20m
      # LFS_MAX_FILE_SIZE: 0
      # LFS_LOCKS_PAGING_NUM: 50
      !REDIRECT_OTHER_PORT: false
      !PORT_TO_REDIRECT: 80
      # SSL_MIN_VERSION: TLSv1.2
      # SSL_MAX_VERSION: 
      # SSL_CURVE_PREFERENCES: X25519,P256
      # SSL_CIPHER_SUITES: ecdhe_ecdsa_with_aes_256_gcm_sha384,ecdhe_rsa_with_aes_256_gcm_sha384,ecdhe_ecdsa_with_aes_128_gcm_sha256,ecdhe_rsa_with_aes_128_gcm_sha256,ecdhe_ecdsa_with_chacha20_poly1305,ecdhe_rsa_with_chacha20_poly1305
      # ENABLE_LETSENCRYPT: false
      # LETSENCRYPT_ACCEPTTOS: false
      # LETSENCRYPT_DIRECTORY: https
      # LETSENCRYPT_EMAIL: email@example.com
      # ALLOW_GRACEFUL_RESTARTS: true
      # GRACEFUL_HAMMER_TIME: 60s
      # STARTUP_TIMEOUT: 0
    !!!database:
    !!!indexer:
      # ISSUE_INDEXER_TYPE: bleve
      # ISSUE_INDEXER_CONN_STR: ****
      # ISSUE_INDEXER_NAME: gitea_issues
      # ISSUE_INDEXER_PATH: indexers/issues.bleve
      # ISSUE_INDEXER_QUEUE_TYPE: levelqueue
      # ISSUE_INDEXER_QUEUE_DIR: queues/common
      # ISSUE_INDEXER_QUEUE_CONN_STR: addrs=127.0.0.1
      # ISSUE_INDEXER_QUEUE_BATCH_NUMBER: 20
      # REPO_INDEXER_ENABLED: false
      # REPO_INDEXER_TYPE: bleve
      # REPO_INDEXER_PATH: indexers/repos.bleve
      # REPO_INDEXER_CONN_STR: ****
      # REPO_INDEXER_NAME: gitea_codes
      # REPO_INDEXER_INCLUDE: empty
      # REPO_INDEXER_EXCLUDE: empty
      # REPO_INDEXER_EXCLUDE_VENDORED: true
      # UPDATE_BUFFER_LEN: 20
      # MAX_FILE_SIZE: 1048576
      # STARTUP_TIMEOUT: 30s
    queue:
      # TYPE: persistable-channel
      # DATADIR: queues/
      # LENGTH: 20
      # BATCH_LENGTH: 20
      !CONN_STR: redis
      # QUEUE_NAME: _queue
      # SET_NAME: _unique
      # WRAP_IF_NECESSARY: true
      # MAX_ATTEMPTS: 10
      # TIMEOUT: GRACEFUL_HAMMER_TIME + 30s
      # WORKERS: 0 (v1.14 and before
      # MAX_WORKERS: 10
      # BLOCK_TIMEOUT: 1s
      # BOOST_TIMEOUT: 5m
      # BOOST_WORKERS: 1 
    admin:
      # DEFAULT_EMAIL_NOTIFICATIONS: enabled
      !DISABLE_REGULAR_ORG_CREATION: true
    security:
      !INSTALL_LOCK: true
      # SECRET_KEY: 
      # LOGIN_REMEMBER_DAYS: 7
      # COOKIE_USERNAME: gitea_awesome
      # COOKIE_REMEMBER_NAME: gitea_incredible
      # REVERSE_PROXY_AUTHENTICATION_USER: X-WEBAUTH-USER
      # REVERSE_PROXY_AUTHENTICATION_EMAIL: X-WEBAUTH-EMAIL
      # REVERSE_PROXY_LIMIT: 1
      # REVERSE_PROXY_TRUSTED_PROXIES: 127.0.0.0/8,::1/128 
      # DISABLE_GIT_HOOKS: true
      !DISABLE_WEBHOOKS: false
      # ONLY_ALLOW_PUSH_IF_GITEA_ENVIRONMENT_SET: true
      # IMPORT_LOCAL_PATHS: false
      # INTERNAL_TOKEN: 
      # INTERNAL_TOKEN_URI: 
      # PASSWORD_HASH_ALGO: pbkdf2
      # CSRF_COOKIE_HTTP_ONLY: true
      # MIN_PASSWORD_LENGTH: 6
      # PASSWORD_COMPLEXITY: off
      # PASSWORD_CHECK_PWN: false
      # SUCCESSFUL_TOKENS_CACHE_SIZE: 20
    openid:
      # ENABLE_OPENID_SIGNIN: false
      !ENABLE_OPENID_SIGNUP: ! DISABLE_REGISTRATION
      # WHITELISTED_URIS: 
      # BLACKLISTED_URIS: 
    oauth2_client:
      # REGISTER_EMAIL_CONFIRM: [service] REGISTER_EMAIL_CONFIRM
      # OPENID_CONNECT_SCOPES: 
      # ENABLE_AUTO_REGISTRATION: false
      # USERNAME: nickname
      # UPDATE_AVATAR: false
      # ACCOUNT_LINKING: login
    service: 
      # ACTIVE_CODE_LIVE_MINUTES: 180
      # RESET_PASSWD_CODE_LIVE_MINUTES: 180
      # REGISTER_EMAIL_CONFIRM: false
      # REGISTER_MANUAL_CONFIRM: false
      !DISABLE_REGISTRATION: true
      # REQUIRE_EXTERNAL_REGISTRATION_PASSWORD: false
      !REQUIRE_SIGNIN_VIEW: true
      !ENABLE_NOTIFY_MAIL: true
      # ENABLE_BASIC_AUTHENTICATION: true
      # ENABLE_REVERSE_PROXY_AUTHENTICATION: false
      # ENABLE_REVERSE_PROXY_AUTO_REGISTRATION: false
      # ENABLE_REVERSE_PROXY_EMAIL: false
      # ENABLE_CAPTCHA: false
      # REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA: false
      # CAPTCHA_TYPE: image
      # RECAPTCHA_SECRET: ""
      # RECAPTCHA_SITEKEY: ""
      # RECAPTCHA_URL: https
      # HCAPTCHA_SECRET: ""
      # HCAPTCHA_SITEKEY: ""
      # DEFAULT_KEEP_EMAIL_PRIVATE: false
      DEFAULT_ALLOW_CREATE_ORGANIZATION: false
      !!!DEFAULT_USER_IS_RESTRICTED: false
      !!!DEFAULT_ENABLE_DEPENDENCIES: true
      # ALLOW_CROSS_REPOSITORY_DEPENDENCIES : true 
      !ENABLE_USER_HEATMAP: false
      # ENABLE_TIMETRACKING: true
      # DEFAULT_ENABLE_TIMETRACKING: true
      # DEFAULT_ALLOW_ONLY_CONTRIBUTORS_TO_TRACK_TIME: true
      # EMAIL_DOMAIN_WHITELIST: 
      # EMAIL_DOMAIN_BLOCKLIST: 
      !SHOW_REGISTRATION_BUTTON: false
      # SHOW_MILESTONES_DASHBOARD_PAGE: true 
      # AUTO_WATCH_NEW_REPOS: true
      # AUTO_WATCH_ON_CHANGES: false
      # DEFAULT_USER_VISIBILITY: public
      # ALLOWED_USER_VISIBILITY_MODES: public,limited,private
      # DEFAULT_ORG_VISIBILITY: public
      !DEFAULT_ORG_MEMBER_VISIBLE: false 
      # ALLOW_ONLY_INTERNAL_REGISTRATION: false 
      # ALLOW_ONLY_EXTERNAL_REGISTRATION: false 
      # NO_REPLY_ADDRESS: noreply.DOMAIN 
      # USER_DELETE_WITH_COMMENTS_MAX_TIME: 0 
      # VALID_SITE_URL_SCHEMES: http,https
      explore:
        !REQUIRE_SIGNIN_VIEW: true
        !DISABLE_USERS_PAGE: true
    !!!ssh:
      # minimum_key_sizes: 
      #   ED25519: 256
      #   ECDSA: 256
      #   RSA: 2048
      #   DSA: -1
    !!!webhook:
      # QUEUE_LENGTH: 1000
      # DELIVER_TIMEOUT: 5
      # ALLOWED_HOST_LIST: external
      # SKIP_TLS_VERIFY: false
      # PAGING_NUM: 10
      # PROXY_URL: <empty>
      # PROXY_HOSTS: <empty>
    mailer: 
      # ENABLED: false
      # DISABLE_HELO: <empty>
      # HELO_HOSTNAME: <empty>
      # HOST: <empty>
      # IS_TLS_ENABLED: false
      # FROM: <empty>
      # ENVELOPE_FROM: <empty>
      # USER: <empty>
      # PASSWD: <empty>
      # SEND_AS_PLAIN_TEXT: false
      # SKIP_VERIFY: fals
      # USE_CERTIFICATE: false
      # CERT_FILE: custom/mailer/cert.pem
      # KEY_FILE: custom/mailer/key.pem
      # SUBJECT_PREFIX: <empty>
      # MAILER_TYPE: [smtp, sendmail, dummy]
      # SENDMAIL_PATH: sendmail
      # SENDMAIL_ARGS: <empty>
      # SENDMAIL_TIMEOUT: 5m
      # SEND_BUFFER_LEN: 100
    cache:
      # ENABLED: true
      # ADAPTER: memory
      # INTERVAL: 60
      # HOST: [redis,memcache]
      # ITEM_TTL: 16h
      # last_commit:
      #   ENABLED: true
      #   ITEM_TTL: 8760h
      #   COMMITS_COUNT: 1000
    session:
      # PROVIDER: memory
      # PROVIDER_CONFIG: data/sessions
      # COOKIE_SECURE: false
      # COOKIE_NAME: i_like_gitea
      # GC_INTERVAL_TIME: 86400
      # SESSION_LIFE_TIME: 86400
      # DOMAIN: <empty>
      # SAME_SITE: lax [strict, lax, none]
    picture:
      # GRAVATAR_SOURCE: gravatar 
      !DISABLE_GRAVATAR: true
      # ENABLE_FEDERATED_AVATAR: false 
      # AVATAR_STORAGE_TYPE: default 
      # AVATAR_UPLOAD_PATH: data/avatars
      # AVATAR_MAX_WIDTH: 4096 
      # AVATAR_MAX_HEIGHT: 3072 
      # AVATAR_MAX_FILE_SIZE: 1048576(1Mb) 
      # REPOSITORY_AVATAR_STORAGE_TYPE: default 
      # REPOSITORY_AVATAR_UPLOAD_PATH: data/repo-avatars 
      !REPOSITORY_AVATAR_FALLBACK: random 
      # REPOSITORY_AVATAR_FALLBACK_IMAGE: /img/repo_default.png Project
    project:
      # PROJECT_BOARD_BASIC_KANBAN_TYPE: To Do, In Progress, Done
      # PROJECT_BOARD_BUG_TRIAGE_TYPE: Needs Triage, High Priority, Low Priority, Closed
    !attachment: 
      # ENABLED: true
      # ALLOWED_TYPES: .docx,.gif,.gz,.jpeg,.jpg,.log,.pdf,.png,.pptx,.txt,.xlsx,.zip
      # MAX_SIZE: 4
      # MAX_FILES: 5
      # STORAGE_TYPE: local
      # SERVE_DIRECT: false
      # PATH: data/attachments
      # MINIO_ENDPOINT: localhost
      # MINIO_ACCESS_KEY_ID: 
      # MINIO_SECRET_ACCESS_KEY: 
      # MINIO_BUCKET: gitea
      # MINIO_LOCATION: us-east-1
      # MINIO_BASE_PATH: attachments/
      # MINIO_USE_SSL: false
    log: 
      # ROUTER: console
      # NABLE_ACCESS_LOG: false
      # ENABLE_SSH_LOG: false
      # ACCESS: file
      # !!!ACCESS_LOG_TEMPLATE: {{.Ctx.RemoteAddr}} - {{.Identity}} {{.Start.Format "[02/Jan/2006:15:04:05 -0700]" }} "{{.Ctx.Req.Method}} {{.Ctx.Req.URL.RequestURI}} {{.Ctx.Req.Proto}}" {{.ResponseWriter.Status}} {{.ResponseWriter.Size}} "{{.Ctx.Req.Referer}}\" \"{{.Ctx.Req.UserAgent}}"
      # ENABLE_XORM_LOG: true
      name: 
        # LEVEL: log.LEVEL
        # STACKTRACE_LEVEL: log.STACKTRACE_LEVEL
        # MODE: name,console,file
        # EXPRESSION: ""
        # FLAGS: stdflags
        # PREFIX: ""
        # COLORIZE: false
      console:
        # STDERR: false
      file:
        # FILE_NAME: %{ROOT_PATH}
        # MAX_SIZE_SHIFT: 28
        # DAILY_ROTATE: true
        # MAX_DAYS: 7
        # COMPRESS: true
        # COMPRESSION_LEVEL: -1
      conn: 
        # RECONNECT_ON_MSG: false
        # RECONNECT: false
        # PROTOCOL: tcp
        # ADDR: 7020
      !!!smtp: 
        # USER: 
        # PASSWD: 
        # HOST: 127.0.0.1
        # RECEIVERS: 
        # SUBJECT: 
    cron: 
      # ENABLED: false
      # RUN_AT_START: false
      # NO_SUCCESS_NOTICE: false
      # ! SCHEDULE accept formats: ~
      archive_cleanup:
        # ENABLED: true
        # RUN_AT_START: true
        # SCHEDULE: @midnight
        # OLDER_THAN: 24h
      update_mirrors:
        # SCHEDULE: @every 10m
        # NO_SUCCESS_NOTICE: true
        # PULL_LIMIT: 50
        # PUSH_LIMIT: 50
      repo_health_check:
        # SCHEDULE: @midnight
        # TIMEOUT: 60s
        # ARGS: <empty>
      check_repo_stats:
        # RUN_AT_START: true
        # SCHEDULE: @midnight
      cleanup_hook_task_table:
        # ENABLED: true
        # RUN_AT_START: false
        # SCHEDULE: @midnight
        # !CLEANUP_TYPE OlderThan 
        # OLDER_THAN: 168h
        # NUMBER_TO_KEEP: 10
      update_migration_poster_id:
        # SCHEDULE: @midnight 
      sync_external_users:
        # SCHEDULE: @midnight 
        # UPDATE_EXISTING: true
    git:
      # PATH: ""
      # DISABLE_DIFF_HIGHLIGHT: false
      # MAX_GIT_DIFF_LINES: 1000
      # MAX_GIT_DIFF_LINE_CHARACTERS: 5000
      # MAX_GIT_DIFF_FILES: 100
      # COMMITS_RANGE_SIZE: 50
      # BRANCHES_RANGE_SIZE: 20
      # GC_ARGS: 
      # ENABLE_AUTO_GIT_WIRE_PROTOCOL: true
      # PULL_REQUEST_PUSH_MESSAGE: true
      # VERBOSE_PUSH: true
      # VERBOSE_PUSH_DELAY: 5s
      # LARGE_OBJECT_THRESHOLD: 1048576
      # DISABLE_CORE_PROTECT_NTFS: false
      timeout:
        # DEFAUlT: 360
        # MIGRATE: 600
        # MIRROR: 300
        # CLONE: 300
        # PULL: 300
        # GC: 60
    !!!metrics:
      # ENABLED: false
      # ENABLED_ISSUE_BY_LABEL: false
      # ENABLED_ISSUE_BY_REPOSITORY: false
      # TOKEN: <empty>
    api:
      ENABLE_SWAGGER: true
      MAX_RESPONSE_ITEMS: 50
      DEFAULT_PAGING_NUM: 30
      DEFAULT_GIT_TREES_PER_PAGE: 1000
      DEFAULT_MAX_BLOB_SIZE: 10485760
    !!!oauth2:(no)
      !ENABLE: false
      # ACCESS_TOKEN_EXPIRATION_TIME: 3600
      # REFRESH_TOKEN_EXPIRATION_TIME: 730
      # INVALIDATE_REFRESH_TOKENS: false
      # JWT_SIGNING_ALGORITHM: RS256
      # JWT_SECRET: 
      # JWT_SIGNING_PRIVATE_KEY_FILE: jwt/private.pem
      # MAX_TOKEN_LENGTH: 32767
    i18n (i18n):
      LANGS: en-US,zh-CN,zh-HK,zh-TW,de-DE,fr-FR,nl-NL,lv-LV,ru-RU,ja-JP,es-ES,pt-BR,pt-PT,pl-PL,bg-BG,it-IT,fi-FI,tr-TR,cs-CZ,sr-SP,sv-SE,ko-KR,el-GR,fa-IR,hu-HU,id-ID,ml-IN
      NAMES: English,简体中文,繁體中文（香港）,繁體中文（台灣）,Deutsch,français,Nederlands,latviešu,русский,日本語,español,português do Brasil,Português de Portugal,polski,български,italiano,suomi,Türkçe,čeština,српски,svenska,한국어,ελληνικά,فارسی,magyar nyelv,bahasa Indonesia,മലയാളം
    U2F:
      # APP_ID: ROOT_URL
      # TRUSTED_FACETS: 
    !!!markup:
       ABC: 2
    highlight: 
      mapping:
        !file_extension e.g. .toml: ini
    time:
      # FORMAT: RFC1123
      # DEFAULT_UI_LOCATION: Shanghai/Asia
    !!!task: 
      # QUEUE_TYPE: channel
      # QUEUE_LENGTH: 1000
      # QUEUE_CONN_STR: redis
    migrations: 
      # MAX_ATTEMPTS: 3
      # RETRY_BACKOFF: 3
      # ALLOWED_DOMAINS: <empty>
      # BLOCKED_DOMAINS: <empty>
      !ALLOW_LOCALNETWORKS: false
      !SKIP_TLS_VERIFY: false
    federation: 
      # ENABLED: true
    !!!mirror: 
      # ENABLED: true
      # DISABLE_NEW_PULL: false
      # DISABLE_NEW_PUSH: false
      # DEFAULT_INTERVAL: 8h
      # MIN_INTERVAL: 10m
    !!!lfs: 
      # STORAGE_TYPE: local
      # SERVE_DIRECT: false
      # PATH: ./data/lfs
      # MINIO_ENDPOINT: localhost:9000
      # MINIO_ACCESS_KEY_ID: 
      # MINIO_SECRET_ACCESS_KEY: 
      # MINIO_BUCKET: gitea
      # MINIO_LOCATION: us-east-1
      # MINIO_BASE_PATH: lfs/
      # MINIO_USE_SSL: false
    !!!storage: 
      # SERVE_DIRECT: false
      # MINIO_ENDPOINT: localhost:9000
      # MINIO_ACCESS_KEY_ID: Minio accessKeyID to connect only available when STORAGE_TYPE is minio
      # MINIO_SECRET_ACCESS_KEY: Minio secretAccessKey to connect only available when STORAGE_TYPE is minio
      # MINIO_BUCKET: gitea
      # MINIO_LOCATION: us-east-1
      # MINIO_USE_SSL: false
      repo-archive: 
        # STORAGE_TYPE: local
        # SERVE_DIRECT: false
        # PATH: ./data/repo-archive
        # MINIO_ENDPOINT: localhost:9000
        # MINIO_ACCESS_KEY_ID: 
        # MINIO_SECRET_ACCESS_KEY: 
        # MINIO_BUCKET: gitea
        # MINIO_LOCATION: us-east-1
        # MINIO_BASE_PATH: repo-archive/
        # MINIO_USE_SSL: false
    !!!proxy: 
      # PROXY_ENABLED: false
      # PROXY_URL: <empty>
      # PROXY_HOSTS: <empty>
    other: 
      # SHOW_FOOTER_BRANDING: false
      !SHOW_FOOTER_VERSION: false
      # SHOW_FOOTER_TEMPLATE_LOAD_TIME: true
```

