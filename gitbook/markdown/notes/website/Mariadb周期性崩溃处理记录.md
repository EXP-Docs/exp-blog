# Mariadb周期性崩溃问题处理：Error establishing a database connection

------


## 问题描述

- 建站环境：Centos7 + LAMP + WordPress
- 物理内存：2G
- 相关插件：Redis Object Cache （Redis缓存加速）
- 数据库：Mariadb + Redis （均使用默认数据库配置）
- 异常现象：几乎**很规律地每周一次**打开站点时提示`Error establishing a database connection`
- 临时恢复手段：重启 Marridb 进程




## 问题分析

刚开始以为是偶发的，就没在意，但是数个月来都是每周一次，就实在是折腾人了。

最初分析以为是 Redis Object Cache 插件导致的（怀疑是Redis缓存数据过期引起的雪崩），但是关掉Redis Object Cache 之后依旧是每周一次，那就**肯定是Mariadb自身的问题**了。

而且这个问题有几个很有意思的关键点：

- 很有规律地每周一次（当然是基于我的环境而言，不同的环境触发时机可能不同）
- Mariadb数据库未做过任何配置优化（纯粹使用默认配置）
- 每次都可以通过重启Mariadb进程恢复

不难联想到是内存导致的（事后也证实了是这个原因），而重启Mariadb进程可以解决是因为做了内存的释放与再分配。





## 原因定位

首先去核查Mariadb数据库的异常日志，确认数据库崩溃的时候都发生了些什么。

如果不知道异常日志的位置，可以通过输入以下命令，利用Mariadb的进程信息找到它：
```bash
ps -ef|grep mariadb
```

若Mariadb正在运行，会返回类似于以下的信息：

> mysql    31877 31532  0 16:07 ?        00:00:04 
<br/> /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin <font color="red">--log-error=/var/log/mariadb/mariadb.log</font> --pid-file=/var/run/mariadb/mariadb.pid --socket=/var/lib/mysql/mysql.sock --port=3306

其中log-error就是异常日志的位置，这里为：

> /var/log/mariadb/mariadb.log

通过`tail /var/log/mariadb/mariadb.log`命令可查看最近发生的异常。

具体的日志我就不全部贴出来了，这里只拷贝日志中一些与当下要解决的问题相关的部分：

> **&#35; Mariadb崩溃前打印的异常**
<br/> 180906  0:51:40 InnoDB: Fatal error: <font color="red">cannot allocate **memory** for the buffer pool</font>
<br/> 180807 19:30:09 [ERROR] mysqld: <font color="red">Out of **memory**</font> (Needed 128917504 bytes)
<br/> 180908 13:56:25 InnoDB: <font color="red">The InnoDB **memory** heap is disabled</font>
<br/> **&#35; Mariadb重启后打印的信息**
<br/> 180910  8:04:41 InnoDB: Initializing <font color="blue">buffer pool, size = 128.0M</font>
<br/> 180910  8:04:41 InnoDB: Completed initialization of buffer pool

前三行就是导致`Error establishing a database connection`异常的罪魁祸首，在一次数据库崩溃的时候不一定都会出现，但他们所描述的大概意思都是差不多的：由于机器内存不足，无法分配给InnoDB缓冲池足够的内存，导致InnoDB无法启用。

后两行是Mariadb重启后打印的，意思是：成功分配给InnoDB缓冲池128M内存（**具体分配多少内存是视Mariadb的实际配置而定的**）。

需知道Mariadb本质上就是Mysql的分支，因此也具备了InnoDB和MyISAM两种存储引擎。而InnoDB的缓存机制与MyISAM的最大区别就在于，InnoDB不仅仅缓存索引，还会缓存实际的数据。所以**使用InnoDB的前提是要有足够大的物理内存**。

> **[info]** 在Mariadb的服务配置文件中有一个innodb_buffer_pool_size 参数，它用来设置InnoDB缓存用户表及索引数据的最主要缓存空间，对InnoDB整体性能影响也最大。

其实前面说了这么多，<font color="red">**总结下来就是**</font>：

Mariadb没有配置好InnoDB，WordPress本身就比较占资源，站点访问量稍微大一些，之前已分配给InnoDB的内存就满了。机器内存由于还提供了其他应用服务，剩余内存不够InnoDB重分配，而**机器本身又没有针对垃圾内存的释放策略**，于是Mariadb进程就锁死了。最终WordPress由于无法连接到数据库，在站点页面打印了异常`Error establishing a database connection`。





## 问题处理

其实这个问题多发于内存低配的服务器上，内存高配服务器并不明显。

但无论低配还是高配服务器，都需要具备一套针对内存不足时的处理策略。现在既然知道到了问题的根本原因，就能定制出对应的处理方案：

- **减少InnoDB需求的内存**：这是直观上处理手段，但是指标不治本，只是问题的触发周期延长了而已。
- **优化服务器的内存处理策略**：推荐建立合理的交换分区swap（类似于虚拟内存技术），可从根本上解决问题。
- **建立Mariadb进程的守护进程**：这是备用的补救措施，如可通过crontab命令检测Mariadb进程状态，发生异常时即时重启。




## 创建交换分区swap

swap（即交换分区）是在Linux上较为推崇的、类似于Windows的虚拟内存技术。具备swap的Linux，当遇到物理内存不足的情况，就可以把部分硬盘空间当成虚拟内存使用，从而解决了物理内存不足的问题。

Linux把物理内存划分为多个内存段，称为页面。而交换就是指内存页面被复制到预先设定好的硬盘空间（即交换空间）的过程，目的是释放掉页面的内存，供其他应用使用。物理内存和交换空间的总大小是可用的虚拟内存的总量。

下面描述如何在Centos上创建交换分区。



首先需要使用`root用户`登陆系统。

通过`free -mh`命令查看内存和swap的分配情况，**默认Centos是没有设置swap的，因此swap分区的大小是0**：
> 　　　　total　　used　　　free　　shared　buff/cache　available
<br/> Mem: 　　　1.8G　　662M　　210M　　560K　　　965M　　　1.0G
<br/> <font color="red">Swap:　　　　0　　　　0　　　　0</font>


<br/>
> **[info]** 也可以通过`swapon -s`命令查看已经配置的swap空间（但若无配置swap空间则此命令无任何反应）。


按照习惯，**建议swap交换分区的大小为实际物理内存的2~2.5倍**。在本例中的物理内存是2G，因此这里创建4G的交换分区。

此前先通过`df -h`命令查看硬盘是否有大于4G的可用空间（本例中可见剩余36G，足够了）：
> Filesystem　　Size　Used　Avail　Use%　Mounted on
<br/>　/dev/vda1　　　50G　　12G　<font color="red">36G</font>　25%　　　/
<br/>　devtmpfs　　　909M    　 0　　909M　0%　　　/dev
<br/>　tmpfs　　　　　920M　24K　920M　1%　　　/dev/shm
<br/>　tmpfs　　　　　920M　460K　919M　1%　　/run
<br/>　tmpfs　　　　　920M　　0　　920M　0%　　/sys/fs/cgroup
<br/>　tmpfs　　　　　184M　　0　　184M　0%　　/run/user/0


使用`dd`命令创建swap交换分区文件`/home/swap`，大小为4G（由于较大，可能耗时较久）：
```bash
dd if=/dev/zero of=/home/swap bs=1024 count=4096000

# 命令参数解析
# if=<文件>：代表输入文件，默认从stdin中读取输入。/dev/zero 是一个字符设备，会不断返回0值字节（\0）
# of=<文件>：代表输出文件，默认以stdout作为输出
# bs=<单个块的字节数>：交换分区的读写是以block（块）为单位的，每个block的大小默认为1K，即1024字节
# count=<块数>：交换分区文件的block数，count*bs就是交换分区的大小

# 若创建成功则返回：
# 4096000+0 records in
# 4096000+0 records out
# 4194304000 bytes (4.2 GB) copied, 40.4638 s, 104 MB/s
```

在这个**交换分区文件**上创建**交换分区**：
```bash
mkswap /home/swap

# 若创建成功则返回：
# Setting up swapspace version 1, size = 4095996 KiB
# no label, UUID=ec9e00e2-3d82-4bc0-bc99-e2e4837dcca5
```

激活交换分区：
```bash
swapon /home/swap

# 若激活成功则返回：
# swapon: /home/swap: insecure permissions 0644, 0600 suggested.
```

再次通过`free -mh`命令查看内存和swap的分配情况：
> 　　　　total　　used　　　free　　shared　buff/cache　available
<br/>Mem: 　　　1.8G　　662M　　210M　　560K　　　965M　　　1.0G
<br/><font color="red">Swap:　　　3.9G　　　　0B　　　3.9G</font>

或通过`swapon -s`命令查看本机已配置的swap空间：
> Filename　　　Type　　　　Size　Used　Priority
<br/>/home/swap　　　　file　　4095996　　0　　　-1

为了避免系统重启后交换分区失效，需要**设置交换分区在开机后自动挂载**。

由于系统开机时会主动读取`/etc/fstab`文件里的配置进行磁盘挂载，这样只需要将交换分区的挂载信息写入这个文件中就可以了。

通过命令`vi /etc/fstab`编辑文件，在末尾增加下面一行并保存即可：
```bash
/home/swap           swap                 swap       defaults              0 0
```

<font color="red">至此交换分区创建完成。</font>




## 附1：减少InnoDB的需求缓存

一般来说，设置了交换分区就已经解决了这个问题了。但这里还是附上裁减InnoDB缓存的设置方法，针对一些内存极少的机器还是需要的。

首先登陆到Mariadb数据库`mysql -u root -p`，通过SQL查看当前InnoDB缓存是多大（若未修改过任何配置，默认情况下应该是128M）：
```sql
 SELECT @@innodb_buffer_pool_size/1024/1024;

+-+
| @@innodb_buffer_pool_size/1024/1024 |
+-+
|                        128.00000000 |
+-+
```

若要变更，只需在Mariadb配置文件修改·innodb_buffer_pool_size·参数大小即可。

默认情况下，Centos的Mariadb配置文件位置为：
> /etc/my.cnf

但是官方并不推荐修改这个配置文件，因为当Mariadb升级时很可能会将其覆盖掉。不过这个配置文件会包含了一个配置目录`/etc/my.cnf.d`，其下的全部配置文件都会被包含进来。默认情况下，目录`/etc/my.cnf.d`内有三个配置文件：
> /etc/my.cnf.d/client.cnf
<br/> /etc/my.cnf.d/mysql-clients.cnf
<br/> /etc/my.cnf.d/server.cnf

一般情况下，我们只需修改`/etc/my.cnf.d/server.cnf`配置文件即可。但是也可以在`/etc/my.cnf.d`目录下创建新的配置文件（它将被`/etc/my.cnf`自动包含）。

在本例中我们选择后者，即在`/etc/my.cnf.d`目录下创建新的配置文件。

打开`/usr/share/mysql`目录，可以发现这里有一些现成的mysql数据库样例配置文件，对应不同的使用场景：
> my-huge.cnf
<br/> my-innodb-heavy-4G.cnf
<br/> my-large.cnf
<br/> my-medium.cnf
<br/> my-small.cnf

这里把`my-medium.cnf`拷贝过来：
```bash
cp /usr/share/mysql/my-medium.cnf /etc/my.cnf.d/
```

通过命令`vi /etc/my.cnf.d/my-medium.cnf`编辑配置文件，找到`innodb_buffer_pool_size`参数，去掉前面的#注释并修改成期望的大小即可（本文改成了32M）。

修改完成后，需重启Mariadb服务使其生效：
```bash
systemctl restart mariadb
```




## 附2：利用crontab守护Mariadb

作为备用方案，可利用crontab实时监控Mariadb的进程状态，万一崩溃则自动重启Mariadb进程，这样在最坏的情况下也能保证站点的正常使用了。

crontab是Centos内置的定时计划服务，可以用以下命令启动和停止服务：
```bash
systemctl start crond.service   # 启动crontab服务
systemctl stop crond.service    # 停止crontab服务
```

使用`crontab -e`命令在crontab添加一行计划任务（拷贝下面的命令到末尾保存即可）：<font color="red">每分钟对Mariadb进程进行检查，若进程不存在则重新启动数据库服务</font>：
```bash
*/1 * * * * if [ -z `ps -ef|grep mariadb|grep -v grep|awk '{print $2}'` ];then systemctl start mariadb;fi

# 此计划任务解释：
# */1 * * * *： 是cron表达式，这里表示每分钟执行一次。cron的语法可自行谷歌或百度
# ps -ef：表示查看当前运行中的进程列表
# grep mariadb：表示仅保留包含mariadb关键字的进程
# grep -v grep：表示排除包含grep关键字的进程
# awk '{print $2}'：表示提取进程号
# -z：表示判断进程号是否为空
```

重载或重启crontab使配置生效：
```bash
systemctl reload crond.service   # 重载crontab配置
systemctl restart crond.service   # 重启crontab服务
```

通过`crontab -l`命令可确认当前用户的计划任务列表。

需注意crontab默认不会开机自启，可编辑`vi /etc/rc.d/rc.local`文件，在末尾添加以下内容并保存即可：
> systemctl start crond.service





## 资源下载

<a class="download" href="http://download.csdn.net/download/lyy289065406/10657460" target="_blank"><i class="fa fa-cloud-download"></i>本文全文下载</a>
