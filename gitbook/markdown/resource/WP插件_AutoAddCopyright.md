# WP插件：Auto Add Copyright – 被复制时自动追加版权链接

------

## 前言

这是本站出品的第一个WP插件，纪念一下。

当你在网站辛苦发布的文章，被别人不露声色随便拷贝走了，是不是很心痛呢？

**本插件可以在别人拷贝你站点内容的时候，自动在内容末尾追加你的站点版权信息**。



顺带一提，虽然已经有插件（如 [WP Content Copy Protection & No Right Click](../notes/website/WordPress插件推荐.html#wp-content-copy-protection--no-right-click-（文章保护插件）)）可以**完全禁止读者复制你站点的内容**以保护你的资源，但是这对读者**是很不友好的**。尤其当你的站点提供了一些教程类的文章、且文章中存在命令断句时，读者如果不能复制这些命令是很痛苦的事情。


## 优势比对

网上已经有很多同类的JS脚本， 但是**大部分都因为过时而存在不少问题**，这里简单做个比较：


| 方法 | 类型 | 优点 | 缺点 |
|:---:|:---:|:---:|:---:|
| window.clipboard | JS脚本 | 直接操作剪贴板，简单易用  | 仅适用于IE浏览器  |
| ZeroClipboard | JS脚本 |  解决了window.clipboard的适用范围问题 | 需要Flash支持，但在HTML5技术<br/>流行的当下，Flash已淘汰  |
| window.getSelection | JS脚本 | 无需操作剪贴板，兼容大部分浏览器  |  所复制的内容会丢失换行等格式，<br/>且内容中若有代码也会丢失<br/>（尤其是html）  |
| <font color="red">Auto Add Copyright</font>  | WP插件 | 解决了前面所有缺点  | 暂时没想到  |

> ***注：***
<br/> *且凡是需要通过JS脚本实现的，一般都要修改主题的 function.php、head.php 或 footer.php 文件。*
<br/> *先不论站长是否具备编程能力，至少切换主题后都需要再次修改代码。*
<br/> *而本插件则完全没有这个问题。*



## 插件特色

- 当读者试图复制站点内容时，会自动在复制内容末尾追加站点版权信息
- 可设置允许读者复制的内容长度，小于这个长度不会触发追加机制
- 可设置本插件的生效范围：全站、或仅文章页面
- 支持大部分主流浏览器
- 复制内容支持纯文本、代码等，不会造成复制内容格式变形

![](/res/img/article/20180707/01.png)

## 插件下载

> [!NOTE|style:flat|icon:fa fa-cloud-download|label:Download]
> 
> [Auto Add Copyright   v1.0（20180707）下载](https://download.csdn.net/download/lyy289065406/10527059)

