# Git命令行安装与使用笔记

------------


## 1. 安装环境

- 操作系统：Centos 7 （纯命令行环境）
- Git服务器：Github
- 安装的Git命令行版本：1.8.3.1

------------


## 2. Git下载

首先需要安装git的依赖包：
> yum install curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel

切到安装目录：
> cd /usr/local

Centos自带的Git版本比较旧，这里直接到官网下载最新版 ：
> wget http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.xz

注意下载回来的是<font color="red">.xz包</font>（注意不是.gz包，我下载的时候，.gz包是0字节，可能是官方的问题），对其解压：
> xz -d git-latest.tar.xz
<br/> tar -xvf git-latest.tar

解压出来的文件夹是 git-xxxx-xx-xx（xxxx-xx-xx是版本的日期，例如2018-07-23），切到该目录下：
> cd git-xxxx-xx-xx

------------


## 3. Git安装

生成Git的配置脚本configure：
> autoconf

修改安装路径，可随意指定：
> ./configure --prefix=<font color="red">/usr/local/git</font>

注意，若指定的安装路径不存在，则需要先预建目录：
> mkdir -p <font color="red">/usr/local/git</font>

编译并安装：
> make | make install

把Git命令添加到系统环境变量，修改系统环境变量文件：
> vi /etc/profile

在文件最后添加以下内容：
> GIT_HOME=<font color="red">/usr/local/git</font>
<br/> PATH=&#36;PATH:&#36;GIT_HOME/bin
<br/> export GIT_HOME PATH

重载系统环境变量使其生效：
> source /etc/profile

通过查看git版本号验证是否安装成功：
> git --version

**<font color="red">至此Git命令行安装完成</font>**。

> ***注：***
<br/> ○ 若安装时不通过 ./configure --prefix=xxx 命令指定安装路径，那么Git的可执行文件默认放在/usr /local/bin，库文件默认放在/usr/local/lib，配置文件默认放在/usr/local/etc，其它的资源文件放在/usr /local/share
<br/> ○ 那么当需要卸载Git时，要么在原来的make目录下执行make uninstall（前提是make文件指定过uninstall），要么在上述目录中把相关的文件一个个手工删掉。
<br/> ○ 但若指定了安装路径，则只需直接删掉该路径文件夹即可。


------------

## 4. 连接Github

配置Github的账号和邮箱：
> git config --global user.name &quot;<font color="red">你的Github账号</font>&quot;
<br/> git config --global user.email &quot;<font color="red">你的Github邮箱</font>&quot;

生成该GitHub账号的SSH Keys（<font color="red">本质是RSA公私钥</font>）：
> ssh-keygen -t rsa -C &quot;你的Github邮箱&quot;

运行该命令后，系统会确认一些问题，什么都不用输入，<font color="red">保持默认，连续三次回车即可</font>。

期间系统会提示所生成的RSA公私钥保存位置（一般在<font color="red">`~/.ssh`目录</font>）：

- 私钥文件位置：`~/.ssh/id_rsa`
- 公钥文件位置：`~/.ssh/id_rsa.pub`


私钥不要动，只需把公钥设置到Github上就可以实现连接了。

先查看公钥文件内容：
> `cat ~/.ssh/id_rsa.pub`

然后在浏览器登陆你的Github：
> Settings =&gt; SSH and GPG Keys =&gt; New SSH key

把公钥内容复制进去并保存即可：

![](/res/img/article/20180724_01.png)

> ***注：***
<br/> 以后在这台Centos机器连接到Github时，就是使用这对RSA公私密钥，而不用通过Github密码，所以需要保管好这对密钥。

回到Centos，输入以下命令尝试连接到Github：
> ssh -T git@github.com

此时会提示以下内容，<font color="red">输入yes</font>即可：

> The authenticity of host 'github.com (xxx.xxx.xxx.xxx)' can't be established.
<br/> RSA key fingerprint is xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.xx.
<br/> Are you sure you want to continue connecting (yes/no)? <font color="red">yes</font>

最终提示以下内容则表示连接成功：
> Warning: Permanently added 'github.com, xxx.xxx.xxx.xxx' (RSA) to the list of known hosts.
<br/> Hi smartwen! You've successfully authenticated, but GitHub does not provide shell access.

此时随便指定一个目录并切换进去，如：
> cd /tmp/

把该目录初始化为Git的代码仓库：
> git init

然后就可以同步Github上的项目代码（和它的整个代码历史）到本地了：
> git clone <font color="red">项目仓库URL</font>

------------

## 5. Git命令手册

由于Centos下并不支持图形化界面（我用的是云服务器，纯命令行），因此需要熟悉Git的命令进行代码版本维护。

一般来说，日常使用只要记住下图6个命令就可以了：

![](/res/img/article/20180724_02.png)

但为了日后使用方便起见，此处整理一下Git的命令清单：

------------


### 5.1. 专有名词

- Workspace：工作区
- Index / Stage：暂存区
- Repository：仓库区（或本地仓库）
- Remote：远程仓库


------------

### 5.2. 新建代码库

> <font color="red">&#35; 在当前目录新建一个Git代码库</font>
<br/> <font color="red">git init</font>
<br/> &nbsp;
<br/> &#35; 新建一个目录，将其初始化为Git代码库
<br/> git init [project-name]
<br/> &nbsp;
<br/> <font color="red">&#35; 下载一个项目和它的整个代码历史</font>
<br/> <font color="red">git clone [url]</font>

------------

### 5.3. 配置

Git的配置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）。

> &#35; 显示当前的Git配置
<br/> git config --list
<br/> &nbsp;
<br/> &#35; 编辑Git配置文件
<br/> git config -e [--global]
<br/> &nbsp;
<br/> &#35; 设置提交代码时的用户信息
<br/> git config [--global] user.name &quot;[name]&quot;
<br/> git config [--global] user.email &quot;[email address]&quot;


------------

### 5.4. 增加/删除文件

> <font color="red">&#35; 添加指定文件到暂存区</font>
<br/> <font color="red">git add [file1] [file2] ...</font>
<br/> &nbsp;
<br/> &#35; 添加指定目录到暂存区，包括子目录
<br/> git add [dir]
<br/> &nbsp;
<br/> <font color="red">&#35; 添加当前目录的所有文件到暂存区</font>
<br/> <font color="red">git add .</font>
<br/> &nbsp;
<br/> &#35; 添加每个变化前，都会要求确认
<br/> &#35; 对于同一个文件的多处变化，可以实现分次提交
<br/> git add -p
<br/> &nbsp;
<br/> &#35; 删除工作区文件，并且将这次删除放入暂存区
<br/> git rm [file1] [file2] ...
<br/> &nbsp;
<br/> &#35; 停止追踪指定文件，但该文件会保留在工作区
<br/> git rm --cached [file]
<br/> &nbsp;
<br/> &#35; 改名文件，并且将这个改名放入暂存区
<br/> git mv [file-original] [file-renamed]

------------

### 5.5. 代码提交

> <font color="red">&#35; 提交暂存区到仓库区</font>
<br/> <font color="red">git commit -m [message]</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 提交暂存区的指定文件到仓库区</font>
<br/> <font color="red">git commit [file1] [file2] ... -m [message]</font>
<br/> &nbsp;
<br/> &#35; 提交工作区自上次commit之后的变化，直接到仓库区
<br/> git commit -a
<br/> &nbsp;
<br/> &#35; 提交时显示所有diff信息
<br/> git commit -v
<br/> &nbsp;
<br/> &#35; 使用一次新的commit，替代上一次提交
<br/> &#35; 如果代码没有任何新变化，则用来改写上一次commit的提交信息
<br/> git commit --amend -m [message]
<br/> &nbsp;
<br/> &#35; 重做上一次commit，并包括指定文件的新变化
<br/> git commit --amend [file1] [file2] ...

------------

### 5.6. 分支

> <font color="red">&#35; 列出所有本地分支</font>
<br/> <font color="red">git branch</font>
<br/> &nbsp;
<br/> &#35; 列出所有远程分支
<br/> git branch -r
<br/> &nbsp;
<br/> <font color="red">&#35; 列出所有本地分支和远程分支</font>
<br/> <font color="red">git branch -a</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 新建一个分支，但依然停留在当前分支</font>
<br/> <font color="red">git branch [branch-name]</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 新建一个分支，并切换到该分支</font>
<br/> <font color="red">git checkout -b [branch]</font>
<br/> &nbsp;
<br/> &#35; 新建一个分支，指向指定commit
<br/> git branch [branch] [commit]
<br/> &nbsp;
<br/> &#35; 新建一个分支，与指定的远程分支建立追踪关系
<br/> git branch --track [branch] [remote-branch]
<br/> &nbsp;
<br/> <font color="red">&#35; 切换到指定分支，并更新工作区</font>
<br/> <font color="red">git checkout [branch-name]</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 切换到上一个分支</font>
<br/> <font color="red">git checkout -</font>
<br/> &nbsp;
<br/> &#35; 建立追踪关系，在现有分支与指定的远程分支之间
<br/> git branch --set-upstream [branch] [remote-branch]
<br/> &nbsp;
<br/> &#35; 合并指定分支到当前分支
<br/> git merge [branch]
<br/> &nbsp;
<br/> &#35; 选择一个commit，合并进当前分支
<br/> git cherry-pick [commit]
<br/> &nbsp;
<br/> <font color="red">&#35; 删除分支</font>
<br/> <font color="red">git branch -d [branch-name]</font>
<br/> &nbsp;
<br/> &#35; 删除远程分支
<br/> git push origin --delete [branch-name]
<br/> git branch -dr [remote/branch]


------------

### 5.7. 标签

> &#35; 列出所有tag
<br/> git tag
<br/> &nbsp;
<br/> &#35; 新建一个tag在当前commit
<br/> git tag [tag]
<br/> &nbsp;
<br/> &#35; 新建一个tag在指定commit
<br/> git tag [tag] [commit]
<br/> &nbsp;
<br/> &#35; 删除本地tag
<br/> git tag -d [tag]
<br/> &nbsp;
<br/> &#35; 删除远程tag
<br/> git push origin :refs/tags/[tagName]
<br/> &nbsp;
<br/> &#35; 查看tag信息
<br/> git show [tag]
<br/> &nbsp;
<br/> &#35; 提交指定tag
<br/> git push [remote] [tag]
<br/> &nbsp;
<br/> &#35; 提交所有tag
<br/> git push [remote] --tags
<br/> &nbsp;
<br/> &#35; 新建一个分支，指向某个tag
<br/> git checkout -b [branch] [tag]

------------

### 5.8. 查看信息

> <font color="red">&#35; 显示有变更的文件</font>
<br/> <font color="red">git status</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 显示当前分支的版本历史</font>
<br/> <font color="red">git log</font>
<br/> &nbsp;
<br/> &#35; 显示commit历史，以及每次commit发生变更的文件
<br/> git log --stat
<br/> &nbsp;
<br/> &#35; 搜索提交历史，根据关键词
<br/> git log -S [keyword]
<br/> &nbsp;
<br/> &#35; 显示某个commit之后的所有变动，每个commit占据一行
<br/> git log [tag] HEAD --pretty=format:%s
<br/> &nbsp;
<br/> &#35; 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件
<br/> git log [tag] HEAD --grep feature
<br/> &nbsp;
<br/> &#35; 显示某个文件的版本历史，包括文件改名
<br/> git log --follow [file]
<br/> git whatchanged [file]
<br/> &nbsp;
<br/> &#35; 显示指定文件相关的每一次diff
<br/> git log -p [file]
<br/> &nbsp;
<br/> &#35; 显示过去5次提交
<br/> git log -5 --pretty --oneline
<br/> &nbsp;
<br/> &#35; 显示所有提交过的用户，按提交次数排序
<br/> git shortlog -sn
<br/> &nbsp;
<br/> &#35; 显示指定文件是什么人在什么时间修改过
<br/> git blame [file]
<br/> &nbsp;
<br/> <font color="red">&#35; 显示暂存区和工作区的代码差异</font>
<br/> <font color="red">git diff</font>
<br/> &nbsp;
<br/> &#35; 显示暂存区和上一个commit的差异
<br/> git diff --cached [file]
<br/> &nbsp;
<br/> &#35; 显示工作区与当前分支最新commit之间的差异
<br/> git diff HEAD
<br/> &nbsp;
<br/> &#35; 显示两次提交之间的差异
<br/> git diff [first-branch]...[second-branch]
<br/> &nbsp;
<br/> &#35; 显示今天你写了多少行代码
<br/> git diff --shortstat "@{0 day ago}"
<br/> &nbsp;
<br/> <font color="red">&#35; 显示某次提交的元数据和内容变化</font>
<br/> <font color="red">git show [commit]</font>
<br/> &nbsp;
<br/> &#35; 显示某次提交发生变化的文件
<br/> git show --name-only [commit]
<br/> &nbsp;
<br/> &#35; 显示某次提交时，某个文件的内容
<br/> git show [commit]:[filename]
<br/> &nbsp;
<br/> &#35; 显示当前分支的最近几次提交
<br/> git reflog
<br/> &nbsp;
<br/> <font color="red">&#35; 从本地master拉取代码更新当前分支：branch 一般为master</font>
<br/> <font color="red">git rebase [branch]</font>


------------

### 5.9. 远程同步

> &#35; 下载远程仓库的所有变动
<br/> git fetch [remote]
<br/> &nbsp;
<br/> &#35; 显示所有远程仓库
<br/> git remote -v
<br/> &nbsp;
<br/> &#35; 显示某个远程仓库的信息
<br/> git remote show [remote]
<br/> &nbsp;
<br/> &#35; 增加一个新的远程仓库，并命名
<br/> git remote add [shortname] [url]
<br/> &nbsp;
<br/> <font color="red">&#35; 取回远程仓库的变化，并与本地分支合并</font>
<br/> <font color="red">git pull [remote] [branch]</font>
<br/> &nbsp;
<br/> <font color="red">&#35; 上传本地指定分支到远程仓库</font>
<br/> <font color="red">git push [remote] [branch]</font>
<br/> &nbsp;
<br/> &#35; 强行推送当前分支到远程仓库，即使有冲突
<br/> git push [remote] --force
<br/> &nbsp;
<br/> &#35; 推送所有分支到远程仓库
<br/> git push [remote] --all

------------

### 5.10. 撤销

> &#35; 恢复暂存区的指定文件到工作区
<br/> git checkout [file]
<br/> &nbsp;
<br/> &#35; 恢复某个commit的指定文件到暂存区和工作区
<br/> git checkout [commit] [file]
<br/> &nbsp;
<br/> &#35; 恢复暂存区的所有文件到工作区
<br/> git checkout .
<br/> &nbsp;
<br/> &#35; 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
<br/> git reset [file]
<br/> &nbsp;
<br/> <font color="red">&#35; 重置暂存区与工作区，与上一次commit保持一致</font>
<br/> <font color="red">git reset --hard</font>
<br/> &nbsp;
<br/> &#35; 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
<br/> git reset [commit]
<br/> &nbsp;
<br/> &#35; 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
<br/> git reset --hard [commit]
<br/> &nbsp;
<br/> &#35; 重置当前HEAD为指定commit，但保持暂存区和工作区不变
<br/> git reset --keep [commit]
<br/> &nbsp;
<br/> &#35; 新建一个commit，用来撤销指定commit
<br/> &#35; 后者的所有变化都将被前者抵消，并且应用到当前分支
<br/> git revert [commit]
<br/> &nbsp;
<br/> <font color="red">&#35; 暂时将未提交的变化移除，稍后再移入</font>
<br/> <font color="red">git stash</font>
<br/> <font color="red">git stash pop</font>

------------

### 5.11. 其他

> &#35; 生成一个可供发布的压缩包
<br/> git archive


------------

## 6. 示例：工作中使用Git的一般流程

（1）下载远程代码仓库并创建分支：
<br/>　　　　git clone [远程代码仓库]
<br/>　　　　git branch [本地分支名称] <font color="#00a67c">*（创建本地分支）*</font>
<br/>　　　　git branch <font color="#00a67c">*（查看本地所有分支）*</font>
<br/>　　　　git checkout [本地分支名称] <font color="#00a67c">*（切换到本地分支）*</font>

（2） 写代码.......

（3） 确认变更并提交：
<br/>　　　　git status <font color="#00a67c">*（查看文件改变记录）*</font>
<br/>　　　　git diff <font color="#00a67c">*（查看代码级改变）*</font>
<br/>　　　　git add <font color="#00a67c">*（确认改变）*</font>
<br/>　　　　git commit -m 提交注释 <font color="#00a67c">*（提交到当前分支的本地工作区）*</font>
<br/>　　　　git push [远程分支：origin] [本地分支的名称] <font color="#00a67c">*（上传本地分支到远程仓库）*</font>

（4） 去Git管理网站（如Github）创建Merge Request

（5） 等待管理员（有选择地）合并所有人的Merge Request

（6） 管理员合并后，从远程代码仓库更新本地分支：
<br/>　　　　git checkout master <font color="#00a67c">*（切换至master）*</font>
<br/>　　　　git pull <font color="#00a67c">*（从远程master更新至本地master）*</font>
<br/>　　　　git checkout [本地分支名称] <font color="#00a67c">*（切换至本地分支）*</font>
<br/>　　　　git rebase master [本地分支名称] <font color="#00a67c">*（从本地master拉取代码更新当前分支）*</font>

（7） 拉取更新过程中，若有冲突的解决方法：
<br/>　　　　① 修改代码文件并解决冲突
<br/>　　　　② git add . <font color="#00a67c">*（加入待提交）*</font>
<br/>　　　　③ git rebase --continue <font color="#00a67c">*（继续执行前面第6步的rebase）*</font>
<br/>　　　　④ 如果仍然有冲突，重复前面①②③步骤
<br/>　　　　⑤ git rebase --skip <font color="#00a67c">*（无法解决冲突时的处理手法1：直接用master覆盖本地分支）*</font>
<br/>　　　　⑥ git push -f origin [本地分支名称] <font color="#00a67c">*（无法解决冲突时的处理手法2：强制用本地的代码去覆盖掉远程仓库的代码。其中origin为远程仓库名）*</font>

（8） 去Git管理网站（如Github）重新创建Merge Request

（9） 等待管理员合并Merge Request.......

（10）重复上述对应步骤.......



------------

## 资源下载

> **[info] [本文全文下载](https://download.csdn.net/download/lyy289065406/10559792)**
