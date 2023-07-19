# ngx_module_t接口
```
struct ngx_command_s {
    ngx_str_t             name;
    ngx_uint_t            type;
    char               *(*set)(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);
    ngx_uint_t            conf;
    ngx_uint_t            offset;
    void                 *post;
};
```

```
struct ngx_module_s {
    ngx_uint_t            ctx_index;
    ngx_uint_t            index;

    char                 *name;

    ngx_uint_t            spare0;
    ngx_uint_t            spare1;

    ngx_uint_t            version;
    const char           *signature;

    void                 *ctx;
    ngx_command_t        *commands;
    ngx_uint_t            type;

    ngx_int_t           (*init_master)(ngx_log_t *log);

    ngx_int_t           (*init_module)(ngx_cycle_t *cycle);

    ngx_int_t           (*init_process)(ngx_cycle_t *cycle);
    ngx_int_t           (*init_thread)(ngx_cycle_t *cycle);
    void                (*exit_thread)(ngx_cycle_t *cycle);
    void                (*exit_process)(ngx_cycle_t *cycle);

    void                (*exit_master)(ngx_cycle_t *cycle);

    uintptr_t             spare_hook0;
    uintptr_t             spare_hook1;
    uintptr_t             spare_hook2;
    uintptr_t             spare_hook3;
    uintptr_t             spare_hook4;
    uintptr_t             spare_hook5;
    uintptr_t             spare_hook6;
    uintptr_t             spare_hook7;
}
```


# Nginx启动过程
- 获取参数：根据命令行传递的参数，将一些设置存储进static类型的变量中。
``` C
ngx_get_options(argc, argv);
```
- 创建log：将其中的ngx_error_log设置为NGX_ERROR_LOG_PATH（logs/error.log），设置ngx_prefix参数为当前目录，然后根据以上两个路径，以append和create的方式打开error.log，这里在拼接路径时需要在堆上创建一块内存，打开文件后这块内存就没用了，所以最后需要释放掉，而这个打开的文件描述符需要存放到ngx_log_file中。
```C
ngx_log_init(ngx_prefix, ngx_error_log);
```
- 设置一个临时的ngx_cycle
	- 创建一个16Byte对齐，1024Byte大小的内存池。
	- 分段存储传入的参数个数和参数，其中参数用一个二维指针数组存储。
- 配置文件路径
- 初始化日志
- 初始化slab
- 如果处于升级中，则监听环境变量里传递的监听句柄
	- 初始化listening的array
	- 获取环境变量填充listening
	- 




















