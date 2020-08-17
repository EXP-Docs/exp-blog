# WINDOWS 内核学习顺序指引清单

------

## 前言

鉴于很多同学想学习 <font color="red">**逆向工程**</font>，但是找不到切入点导致无从入手，因此编写了这个指引清单。

本文原则上只是一个<font color="red">学习指引目录</font>（虽然部分章节有提供一些资料），因涉及知识面太多，具体内容以后再逐渐填充。

有兴趣的同学可根据指引清单，先行逐步扩展学习每个知识点。当整个清单都弄懂了，也就入门了（**对的，你没看错，只是入门**）。





## 1. 基础知识

### 1.1. 驱动框架（NT和WDM）

- 《<a href=" http://blog.csdn.net/msk10k/article/details/51226666" target="_blank" rel="nofollow">NT - WDM - WDF 驱动概念</a>》

### 1.2. 驱动基础（编程概念、内核函数、基本数据结构等等）

- 《<a href="http://blog.csdn.net/erin45/article/details/7401678" target="_blank" rel="nofollow">WDM驱动程序的基本结构和实例</a>》
- 《<a href="http://blog.csdn.net/huangxy10/article/details/15307061" target="_blank" rel="nofollow">Windows驱动开发常用的数据结构</a>》
- 《<a href="http://blog.csdn.net/baggiowangyu/article/details/7936414" target="_blank" rel="nofollow">内存管理</a>》
- 《<a href="http://blog.csdn.net/whw8007/article/details/8865231" target="_blank" rel="nofollow">CE驱动开发常用宏定义</a>》
- 《<a href="http://blog.csdn.net/chenlycly/article/details/52777707" target="_blank" rel="nofollow">windows 内核函数前缀解析</a>》
- 《<a href="http://blog.csdn.net/lanuage/article/details/53413391" target="_blank" rel="nofollow">Windows常用内核函数</a>》


### 1.3. 驱动通信（R3主动与R0通信、R0主动与R3交互）

- R3：用户层
- R0：内核层
- 《<a href="http://www.cnblogs.com/pcajax/archive/2011/03/16/1986407.html" target="_blank" rel="nofollow">ring0和ring3的区别</a>》


### 1.4. 基本操作（系统线程、工作队列、计时器、字符串、内存、链表等等等等）

......





## 2. 进程相关

### 2.1. 枚举进程（PID、EPROCESS、进程路径等）

- 《<a href="http://blog.csdn.net/yangluoning/article/details/14647969" target="_blank" rel="nofollow">四种方法实现VC枚举系统当前进程</a>》
- 《<a href="http://blog.csdn.net/zhongbin104/article/details/7867309" target="_blank" rel="nofollow">C++枚举进程的方法</a>》
- 《<a href="http://blog.csdn.net/myjisgreat/article/details/46481497" target="_blank" rel="nofollow">IsWow64Process函数理解的偏差</a>》


### 2.2. 结束进程（多种方法）

......


### 2.3. 挂起进程

......

### 2.4. 恢复进程

......


### 2.5. 保护进程（API HOOK、回调）

......


### 2.6. 隐藏进程（API HOOK、DKOM）

......


### 2.7. 枚举线程

......


### 2.8. 结束线程（多种方法）

......


### 2.9. 挂起线程

......


### 2.10. 恢复线程

......


### 2.11. 枚举DLL（多种方法）

......


### 2.12. 卸载DLL

......


### 2.13. 注入DLL/SHELLCODE（NT6注入到系统进程）

......


### 2.14. RING3 INLINE HOOK/UNHOOK/绕过（多种方法）

......


### 2.15. RING3 EAT HOOK/UNHOOK

......


### 2.16. RING3 IAT HOOK/UNHOOK

......


### 2.17. 窗口操作（枚举、发消息、隐藏/显示、启用/禁用等）

......


### 2.18. 内存操作（枚举、申请、释放、读写、修改保护类型等）

......


### 2.19. 消息钩子（枚举、删除）

......


### 2.20. 内核回调表（枚举、清除HOOK）

......


### 2.21. 枚举句柄

......


### 2.22. .关闭句柄

......


### 2.23. 监控进程创建/退出（API HOOK、回调）

......


### 2.24. 监控线程创建/退出（API HOOK、回调）

......


### 2.25. 监控DLL加载（API HOOK、回调）

......






## 3. 文件相关

### 3.1. API层文件操作（枚举、复制、删除、重命名）

......


### 3.2. FSD层文件操作（枚举、复制、删除、重命名）

......


### 3.3. DISK层文件操作（读写）

......


### 3.4. 解析NTFS/FAT32

......


### 3.5. 监控文件操作（API HOOK、SFILTER、MINIFILTER）

......






## 4. 注册表相关

### 4.1. API层注册表操作（枚举、新建、删除、重命名）

......


### 4.2. 解析HIVE操作注册表

......


### 4.3. 监控注册表操作（API HOOK、回调、DKOH）

......






## 5. HOOK相关

### 5.1. SSDT HOOK/UNHOOK（包括SHADOW SSDT）

......


### 5.2. INLINE HOOK/UNHOOK/绕过（多种方法）

......


### 5.3. IRP HOOK

......


### 5.4. OBJECT HOOK/UNHOOK

......


### 5.5. IDT HOOK/UNHOOK

......


### 5.6. EAT HOOK/UNHOOK

......


### 5.7. IAT HOOK/UNHOOK

......


### 5.8. MSR HOOK/UNHOOK

......






## 6. 内核相关

### 6.1. 枚举内核模块（链表、目录对象、暴搜）

......


### 6.2. 监控驱动加载（API HOOK、回调）

......


### 6.3. 枚举/删除回调（进程、线程、映像、注册表、蓝屏、关机、对象、文件系统改变）

......


### 6.4. 枚举/删除定时器（IO/DPC）

......


### 6.5. 枚举GDT

......






## 7. 网络相关

### 7.1. 内核网络通信（TDI、WSK）

......


### 7.2. 监控网络通信（WFP、TDI HOOK、NDIS HOOK、NDIS FILTER）

......


### 7.3. 枚举网络连接（API方法、发IRP法）

......


### 7.4. 枚举/挂钩NDIS处理函数

......


### 7.5. 流量统计/下载限速

......


### 7.6. 端口复用

......






## 8. 64位系统专用

### 8.1. 破解PATCHGUARD（动态/静态）

- 《<a href="https://bbs.pediy.com/thread-187214.htm" target="_blank" rel="nofollow">过Patchguard的梗</a>》
- 《<a href="http://www.mengwuji.net/thread-2398-1-1.html" target="_blank" rel="nofollow">过patchguard源码</a>》
- 《<a href="http://www.m5home.com/bbs/thread-5893-1-1.html" target="_blank" rel="nofollow">在Win7x64上加载无签名驱动以及让PatchGuard失效(Win7x64内核越狱)</a>》
- 《<a href="https://bbs.pediy.com/thread-158157.htm" target="_blank" rel="nofollow">让PatchGuard变狗屎的那些方法</a>》


### 8.2. 破解DSE（动态/静态）

- 《<a href="http://www.m5home.com/bbs/thread-7870-1-1.html" target="_blank" rel="nofollow">攻破WIN7~WIN10的KPP和DSE（WIN64内核越狱）</a>》
- 《<a href="http://www.m5home.com/bbs/thread-7880-1-1.html" target="_blank" rel="nofollow">WIN64免签名加载驱动SDK</a>》
- 《<a href="http://www.m5home.com/bbs/forum.php?mod=viewthread&tid=8134" target="_blank" rel="nofollow">神奇的内核路径欺骗</a>》
- 《<a href="http://www.m5home.com/bbs/thread-7390-1-1.html" target="_blank" rel="nofollow">Win7x64全自动无提示破解PatchGuard和Driver Signature Enforcement</a>》
- 《<a href="http://www.m5home.com/bbs/thread-7845-1-1.html" target="_blank" rel="nofollow">在Win64系统上动态加载无签名驱动：WIN64UDL</a>》
- 《<a href="http://blog.csdn.net/zhuhuibeishadiao/article/details/51055046" target="_blank" rel="nofollow">Win7 x64动态开启DSE</a>》






## 9. 杂项

### 9.1. 对象劫持

......


### 9.2. 符号操作

......


### 9.3. PE解析

......


### 9.4. 反调试

......






## 10. 整体项目

### 10.1. PE工具

......


### 10.2. ARK

......


### 10.3. 调试器

......


### 10.4. 主动防御

......


### 10.5. 沙箱

......


### 10.6. 透明加密

......


### 10.7. VT级调试/反调试/主动防御

......






## 11. 其他

### 11.1. MFC开发

- 《<a href="https://www.cnblogs.com/findumars/p/6275607.html" target="_blank" rel="nofollow">VS2010/MFC编程入门教程之目录和总结</a>》
- 《<a href="http://www.jizhuomi.com/school/c/159.html" target="_blank" rel="nofollow">VS2010/MFC编程入门</a>》



