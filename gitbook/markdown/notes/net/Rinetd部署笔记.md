# Centos 实现端口转发：Rinetd 部署笔记

------------

## 前言

虽然Linux本身自带的iptables可以实现端口转发功能，但其配置相对复杂。因此本文介绍另一个端口转发工具Rinetd，其安装和配置都更为简单。



## Rinetd部署环境

本文是基于Centos7系统部署Rinetd端口转发工具。



## Rinetd安装

到官网下载最新版，得到安装包<font color="red">rinetd.tar.gz</font> ：
> 官网地址：[https://boutell.com/rinetd/](https://boutell.com/rinetd/)

上传到Linux，本文上传位置为：
> <font color="red">/usr/local/</font>

解压安装包：
> tar -zxvf <font color="red">rinetd.tar.gz</font>

由于Rinetd需要编译安装，先安装gcc编译环境：
> yum install gcc

进入Rinetd安装目录：
> cd <font color="red">/usr/local/rinetd</font>

检查安装配置文件：
> vi Makefile

注意配置文件中涉及到两处安装路径，一般情况下保持默认值即可：

```
CFLAGS=-DLINUX -g

rinetd: rinetd.o match.o
        gcc rinetd.o match.o -o rinetd

install: rinetd
        install -m 700 rinetd /usr/sbin
        install -m 644 rinetd.8 /usr/man/man8
```

但是若 /usr/man/man8 目录不存在，需要先手建：
> mkdir -p /usr/man/man8

编译并安装：
> make && make install

<font color="red">至此Rinetd安装完成</font>。



## Rinetd配置

配置端口转发规则（该文件可能不存在，直接创建即可）：
> vi /etc/rinetd.conf

该文件每行一个转发规则，配置格式为：
> \[source_address\] \[source_port\] \[destination_address\] \[destination_port\]

即：
> \[本机IP（若非多网卡直接设为0.0.0.0）\] \[转发端口\] \[服务IP\] \[服务端口\]

如：
> 0.0.0.0 9527 192.168.64.22 9527



## Rinetd使用

Rinetd的启动需要指定规则配置文件，而停止需要杀掉进程：


> 启动：rinetd -c /etc/rinetd.conf
<br/> 停止：killall rinetd

查看端口转发状态：
> netstat -tanulp|grep rinetd



## 资源下载

<a class="download" href="http://download.csdn.net/download/lyy289065406/10551468" target="_blank"><i class="fa fa-cloud-download"></i>本文全文下载</a>


