# EXP-BLOG

> EXP 的 GitBook 博客

------

## 简介

此博客主要是利用 [GitBook](https://exp-blog.gitbook.io/articles/) 搭建的，同时兼容在 [Github Pages](https://lyy289065406.github.io/exp-blog/index.html) 和 [本地（线下）](http://127.0.0.1:4000/) 运行。

博客数据存储在 [`gitbook`](https://github.com/lyy289065406/exp-blog/tree/master/gitbook) 目录下，编辑方式有两种：

- 线上编辑： 使用 [GitBook](http://app.gitbook.com/) 即可（编辑需要科学上网，展示不需要），会自动推送到 Github，并同步到 [Github Pages](https://lyy289065406.github.io/exp-blog/index.html) 
- 线下编辑： 要先搭建[本地 GitBook](http://127.0.0.1:4000/) 环境，编辑后手动推送到 Github ，会自动同步到 [GitBook（线上）](https://exp-blog.gitbook.io/articles/) 和  [Github Pages](https://lyy289065406.github.io/exp-blog/index.html)

> 关于 **本地** 环境的搭建可见 [gitbook-server-docker](https://github.com/lyy289065406/gitbook-server-docker)

------
## 运行环境

　![](https://img.shields.io/badge/Platform-Windows%2010%20x64-brightgreen.svg) ![](https://img.shields.io/badge/Platform-Linux%20x64-brightgreen.svg) ![](https://img.shields.io/badge/Platform-Mac%20x64-brightgreen.svg) 

------

## 本地发布流程

- 先按照 [gitbook-server-docker](https://github.com/lyy289065406/gitbook-server-docker) 的方法在本地搭建 GitBook 的 Docker 环境
- 按需修改 `./gitbook/markdown` 目录下的博客数据（注意目录外的 `SUMMARY.md` 和 `README.md` 是固定的）
- `./gitbook_book` 和 `./gitbook/book` 是编译时生成的数据，均不需要修改
- 重新编译博客： `docker run --rm -v "$PWD/gitbook:/gitbook" exp/gitbook-server gitbook build`
- 执行脚本 `deploy-for-github` 用于生成 `./gitbook/book` 以兼容 [GitHub Pages](https://lyy289065406.github.io/exp-blog/index.html) 的发布
- 启动本地服务： `docker run -d --rm -v "$PWD/gitbook:/gitbook" -p 4000:4000 exp/gitbook-server gitbook serve`
- 本地预览编辑效果： [http://127.0.0.1:4000/](http://127.0.0.1:4000/)
- 手动提交全部变更内容到 Github


> 关于博客展示所用的数据：
<br/>　[线上 GitBook](https://exp-blog.gitbook.io/articles/) 依赖 `./gitbook/*.md` 文件
<br/>　[本地 GitBook](http://127.0.0.1:4000/) 依赖 `./gitbook/_book` 目录
<br/>　[Github Pages](https://lyy289065406.github.io/exp-blog/index.html) 依赖 `./gitbook/book` 目录

<br/>
<br/>

>　*编辑 GitBook 的语法详见 《[GitBook 学习笔记](https://yangjh.oschina.io/gitbook/)》*
<br/>　*[GitBook 主题](http://gitbook.zhangjikai.com/themes.html)，[GitBook 插件](http://gitbook.zhangjikai.com/plugins.html)*

https://blog.csdn.net/fghsfeyhdf/article/details/88403548
https://www.cnblogs.com/zhangjk1993/p/5066771.html#_label2
https://www.cnblogs.com/zhangjk1993/p/5066771.html

https://docs.gitbook.com/

------
