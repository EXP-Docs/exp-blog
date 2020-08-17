# WP插件：Baidu Links Submit – 实时推送站点链接到百度

------

## 前言

想要站点文章被百度收录，最快的方法就是主动推送文章链接到 [百度站长平台](https://ziyuan.baidu.com/badlink/index?site=) 。

目前 [百度站长平台](https://ziyuan.baidu.com/badlink/index?site=) 提供了5种提交链接的方式：

○ **自动提交**

- □ 主动推送（API实时推送）
- □ 自动推送（嵌入JS脚本实时推送）
- □ sitemap（被动抓取）

○ **手动提交**

- □ 普通提交
- □ 新站提交（限首次备案不超过3个月的站点）


其中，**sitemap**只要配置好站点地图就不用管了，百度会定时抓取。

而**手动提交**一般没人去做，因为每篇文章都手动就太麻烦了（但是若是新站，则建议手动去提交下，会优先被录取）

至于 **主动推送** 和 **自动推送** 的功能是一样的，但因为有些站长因为不具备开发能力，操作起来还是相对麻烦的。

而本文要介绍的 <font color="red">Baidu Links Submit 插件就是封装了 **主动推送** 的能力</font>。


## 下载并安装插件

Baidu Links Submit 插件最初来源于 [百度站长论坛](http://bbs.zhanzhang.baidu.com/thread-28753-1-1.html)，但是因为原版主在2015年已停更，后来百度站长平台又升级了、加之插件本身也有几个BUG，最后导致无法使用了。

鉴于我比较喜欢这个插件的风格，因此我把2015版本的BUG修正后，重新发布了这个2018修正版：

<a class="download" href="http://download.csdn.net/download/lyy289065406/10519791" target="_blank"><i class="fa fa-cloud-download"></i>Baidu Links Submit  v2.0（20180704）下载</a>


把插件内的 **baidu-links-submit文件夹** 解压到 **/wp-content/plugins/ 目录** 即可完成安装。（由于此插件需要打印日志到文件，因此<font color="red">Linux系统注意不要使用root用户解压</font>，否则WordPress可能没有写日志文件的权限）

## 使用方法

如前文所述，该插件的功能就是向百度实时 **主动推送** 网站的新链接，因此需要注册 [百度站长平台](https://ziyuan.baidu.com/badlink/index?site=) 配合使用。



### ① 注册百度站长平台

在 [**百度站长平台**](https://ziyuan.baidu.com/badlink/index?site=) 注册一个账号，然后在“用户中心->站点管理”添加你的网站域名。

这里需要注意，如果网站是一级域名，例如本站是 exp-blog.com ，虽然在访问的时候是等价于 www.exp-blog.com 的， 但是<font color="red">在WordPress中设置的站点是 exp-blog.com，那么在百度站长平台添加的站点也必须是 exp-blog.com</font> （百度会建议你加上www，除非你的站点也有www，否则无视掉这个建议）。

换而言之，<font color="red">WordPress的站点必须与百度站长平台设置的站点完全一致，否则之后无法推送链接</font>。




### ② 获取主动推送的 site 和 token

注册后，在“站点管理->链接提交->自动提交->主动推送（实时）”可以得到一串类似这样的推送地址：
> http://data.zz.baidu.com/urls?<font color="red">**site**</font>=exp-blog.com&<font color="red">**token**</font>=xxxxxxxxxxxx

把其中的site和token记录下来（注意这里的site其实就是第①步设置的站点地址）。



### ③ 设置 site 和 token 到插件

在WordPress插件管理页面启动此插件，进入设置，填写第②步得到的 site 和token（同时建议打开Log日志开关），保存即可，以后新建文章或页面时就会自动推送到百度了。

![](/res/img/article/20180707/02.png)

## 关于推送结果

发布文章后，可以通过插件的设置页，查看“**当日限额&提交量**”是否发生变化，以确认是否推送成功（**百度站长平台是隔天统计的，不能马上查看到推送情况**）。

若提交量无变化，则可登陆系统后台查看日志确认原因：
> /wp-content/plugins/baidu-links-submit/log/submits.log

若**推送成功**返回的报文日志是这样的（其中remain表示当天的剩余配额，success表示已成功推送的数量）：
```json
{
  "remain": 4999999,
  "success": 1
}
```

若推送返回的报文日志是这样的（**not_same_site非空**），则是提交失败：
```json
{
  "remain": 5000000,
  "success": 0,
  "not_same_site": [
    "http://www.exp-blog.com/2018/07/04/pid-1525/"
  ]
}
```

发生这种情况是因为百度认为**当前站点推送了不属于该站点的链接**，这是不允许的。而原因很可能就是 WordPress设置的站点名称 与 百度站长平台设置的站点名称 不一致引起的，**处理方法**见前文 [① 注册百度站长平台](#①-注册百度站长平台)。

## 关于重复推送

每篇文章在推送到百度后，文章的<font color="red">**自定义栏目会多出一个值Baidusubmit**</font>， true表示推送成功，false表示推送失败。

推送成功的文章不会再次推送链接（即使更新过内容），而推送失败的文章，在下次更新时会尝试重新推送。

若需要重新推送某篇已推送成功的文章，可以把Baidusubmit的值改成false（或直接删除之），但**一般不建议这样做**，因为**二次提交容易导致百度翻脸，从而下调推送配额**。



