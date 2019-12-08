# 禁用 XMLRPC 避免 WP 站点被 DDOS 或暴力登录

------

## 诱因

自从使用 Wordpress 建站以来，就一直被机器人暴力爆破登录密码，其规模已经足以引起DDos攻击，导致服务器启动没多久，资源就被耗尽，打开极其缓慢。

即使安装 Limit Login Attempts 插件进行登录限制，依然会被机器人用 IP 池持续攻击，成效甚微：

![](/res/img/article/20181204/01.png)

## 分析

从 Limit Login Attempts 插件的限制日志可以发现， 通过 XMLRPC 登录的次数远远大于通过 WP Login 登录的次数。

WP Login 就是通过 http://${site-url}/wp-login.php 直接登录， Limit Login Attempts 插件会加上校验码，使其不容易被爆破。

而 XMLRPC 的全称是 XML Remote Procedure Call，即 XML远程方法调用。它是 XHR （即 XMLHttpRequest）的一种实现，其交互消息都是基于 HTTP-POST 请求，请求的内容是 XML，服务端的返回结果同样也是 XML。

对于爬虫机器人而言，相对于 WP Login 方式，使用 XMLRPC 会更方便。因为前者更接近仿真方式登录，而后者则是纯脚本交互，而且可以绕过 Limit Login Attempts 等插件对登录页面的保护。

## 处理

知道根源，处理就很简单了。因为作为站长，一般是用不到 XMLRPC 去管理自己站点的，所以禁用它即可。

而禁用的方法有很多，最简单直接的方法，就是修改网站后台根目录的 `.htaccess` 文件，在末尾加上这段内容即可：
```xml
# forbit xmlrpc.php request (crawler, ddos, ...)
<Files xmlrpc.php>
order deny,allow
deny from all
</Files>
```

