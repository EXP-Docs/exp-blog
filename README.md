# EXP-BLOG

> EXP 技术博客

------

## 简介

此博客是利用 [GitBook](https://docs.gitbook.com/) 搭建的，同时兼容在 [Github Pages](https://lyy289065406.github.io/exp-blog/index.html) 和 [本地（线下）](http://127.0.0.1:4000/) 运行。

> 博客数据存储在 [`gitbook`](https://github.com/lyy289065406/exp-blog/tree/master/gitbook) 目录下，编辑前需要先搭建[本地 GitBook](http://127.0.0.1:4000/) 环境
<br/> 关于 **本地** 环境的搭建可见 [gitbook-server-docker](https://github.com/lyy289065406/gitbook-server-docker) 的说明


------

## 目录说明

```
exp-blog
|-- .gitignore  ..............  [Git 过滤配置]
|-- Dockerfile  ..............  [构建 GitBook 本地服务器的 Docker 脚本]
|-- deploy.ps1  ..............  [把博客变更发布到 Github Pages 的脚本（Windows）]
|-- deploy.sh  ...............  [把博客变更发布到 Github Pages 的脚本（Linux）]
|-- index.html  ..............  [Github Pages 首页（会自动跳转到博客首页）]
|-- gitbook  .................  [GitBook 的工作目录，存储博客数据]
|   |-- _book  ...............  [通过 GitBook 编译生成的静态网站数据，用于本地测试（因含下划线不被 Github Pages 支持）]
|   |-- book  ................  [通过 deploy 脚本复制 _book 目录的镜像，用于 Github Pages]
|   |-- img  .................  [存储博客图片的目录]
|   |-- markdown  ............  [存储博客文章的目录（只有 *.md 文件）]
|   |-- README.md  ...........  [博客介绍文档（固定文件）]
|   |-- SUMMARY.md  ..........  [博客目录索引（固定文件）]
|   |-- node_modules  ........  [GitBook 的插件目录]
|   |-- book.json  ...........  [GitBook 的插件配置]
|   └-- package-lock.json  ...  [GitBook 的插件清单]
|-- LICENSE  .................  [版权说明]
└-- README.md  ...............  [此仓库的说明文档]

```


## 发布流程

- 先按照 [gitbook-server-docker](https://github.com/lyy289065406/gitbook-server-docker#%E6%9E%84%E5%BB%BA-gitbook-%E9%95%9C%E5%83%8F) 的方法在本地搭建 GitBook 的 Docker 环境
- 按需修改 `./gitbook` 下的博客数据（编辑文章在 `markdown` 下操作 `*.md` ，语法参考[这里](https://yangjh.oschina.io/gitbook/)；若编辑插件则参考[这里](https://github.com/lyy289065406/gitbook-server-docker#0x06-%E6%80%8E%E6%A0%B7%E5%AE%89%E8%A3%85-gitbook-%E6%8F%92%E4%BB%B6)）
- 编辑完成后执行发布脚本 `deploy.ps1` 或 `deploy.sh` （该脚本会通过 Docker 执行 `gitbook build` 命令） 
- 若发布成功，会生成 `./gitbook/_book` 和 `./gitbook/book` 目录（前者用于本地调试，后者用于 Github Pages）
- 启动本地服务： `docker run -d --rm -v "$PWD/gitbook:/gitbook" -p 4000:4000 exp/gitbook-server gitbook serve`
- 本地预览编辑效果： [http://127.0.0.1:4000/](http://127.0.0.1:4000/)
- 手动提交全部变更内容到 Github 即可 （`./gitbook/_book` 已通过 `.gitignore` 过滤）


------
