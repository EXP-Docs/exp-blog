# 示例引用告警

------

## 相关插件

- gitbook-plugin-alerts: 支持 4 种不同样式的引用框警示
- gitbook-plugin-flexible-alerts: 比 alerts 功能更丰富的警示引用框

### alerts 语法效果

Info styling
> **[info] For info**
>
> Use this for infomation messages.

Warning styling
> **[warning] For warning**
>
> Use this for warning messages.

Danger styling
> **[danger] For danger**
>
> Use this for danger messages.

Success styling
> **[success] For info**
>
> Use this for success messages.



### flexible-alerts 语法效果

```
> [!type|style:xx|label:xx|icon:xx|className:xx|labelVisibility:xx|iconVisibility:xx]
> 内容部分
```

| 键	 | 允许的值 | 说明 |
|:---:|:---|:---|
| !type | NOTE，TIP，WARNING和DANGER | 警告级别设置 |
| style | 以下值之一:  callout（默认）, flat | 警告样式 |
| label | 任何文字	警告块的标题位置，即Note这个字段位置（不支持中文） |
| icon | e.g. 'fa fa-info-circle' | 一个有效的Font Awesome图标，那块小符号 |
| className | CSS类的名称 | 指定css文件，用于指定外观 |
| labelVisibility | 以下值之一：visible（默认），hidden | 标签是否可见 |
| iconVisibility | 以下值之一：visible（默认），hidden | 图标是否可见 |


> [!NOTE]
> 这是一个简单的Note类型的使用，所有的属性都是默认值。

---

> [!NOTE|style:flat|lable:Mylable|iconVisibility:hidden]
> "!type":`NOTE`、"style":`flat`、"lable":`自定义标签`、图标不可见

