# 从 Git 仓库拉取代码到本地

------

```bash
#!/bin/bash
# 从 Git 仓库拉取代码到本地
#-------------------------------------------------
# 命令执行示例：
# ./pull_git_repository.sh -u USERNAME -p PASSWORD
#-------------------------------------------------

# 命令参数定义
DOMAIN="www.xyz.com/repository"
GITURL="https://${DOMAIN}"               # -a: Git 仓库地址
GITBRANCH="master"                       # -b: Git 仓库分支名称
GITUSER="user@abc.com"                   # -u: Git 仓库账号
GITPASS="123456"                         # -p: Git 仓库密码
GITTAG="latest"                          # -v: 要使用的 Git 的 tag 基线版本名称 (若使用分支的最新版本，保持为默认值即可)
TARGET="/tmp/repository"                 # -t: 拉取仓库到本地的存储位置(若该位置已存在 Git 则自动拉取最新代码，此时忽略其他参数)


# 使用说明
usage()
{
  cat <<EOF
    -h            This help message.
    -a <url>      Git Repository URL. (Default: "${GITURL}")
    -b <branch>   Git Repository Branch. (Default: "${GITBRANCH}")
    -u <username> Git Repository Username. (Default: "${GITUSER}")
    -p <password> Git Repository Password. (Default: "${GITPASS}")
    -v <tag>      Git Repository Tag Version. (Default: "${GITTAG}")
    -t <path>     Save Git Repository Directory. (Default: "${TARGET}")
EOF
  exit 0
}
# [ "$1" = "" ] && usage
[ "$1" = "-h" ] && usage
[ "$1" = "-H" ] && usage


# 定义参数键和值
set -- `getopt a:b:u:p:v:t: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -a) GITURL="$2"
        shift ;;
    -b) GITBRANCH="$2"
        shift ;;
    -u) GITUSER="$2"
        shift ;;
    -p) GITPASS="$2"
        shift ;;
    -v) GITTAG="$2"
        shift ;;
    -t) TARGET="$2"
        shift ;;
  esac
  shift
done




# 标记目标路径 ${TARGET} 是否已存在 Git Repository
export EXIST_GITLAB="F"

# 判断存储路径是否存在 ".." , 避免入参路径穿越
if [[ ${TARGET} =~ ".." ]] ; then
  echo "Error: target path '${TARGET}' exists path crossing risk (Please remove all '..' !!!)"
  exit 1
fi

# 禁止直接使用一、二级目录(如 /, /tmp, /home 等)，必须至少是三级目录
if [[ ${TARGET} =~ ^/[a-zA-Z0-9]*$ ]] ; then
  echo "Error: target path '${TARGET}' must be a three-level directory at least, eg: /tmp/repository"
  exit 1
fi

# 要求存储项目的目录为空目录, 确保把相关操作控制在该目录内
if [ ! -d ${TARGET} ] ; then
  : # 目录不存在

elif [ "`ls -A ${TARGET}`" = "" ] ; then
  : # 目录存在但是为空

else

  # 检查目标目录是否已存在仓库
  if [[ $(cat ${TARGET}/.git/config | grep 'url') =~ ${DOMAIN} ]] ; then
    EXIST_GITLAB="T"

  else
    echo "Error: target path '${TARGET}' already exists and is not an empty directory."
    exit 1
  fi
fi





# 删除 url 地址开头的 http 标识
export GITURI=${GITURL#https://}
GITURI=${GITURI#http://}

# 把 username 和 password 里面的 @ 字符编码为 %40
GITUSER=${GITUSER//@/%40}
GITPASS=${GITPASS//@/%40}

echo "---------- Input Params ----------"
echo "Git Repository URL = ${GITURL}"
echo "Git Repository Branch = ${GITBRANCH}"
echo "Git Repository User = ${GITUSER}"
# echo "Git Repository Pass = ${GITPASS}"
echo "Git Repository Pass = ********"
echo "Git Repository Tag Version = ${GITTAG}"
echo "Save Directory = ${TARGET}"
echo "----------------------------------"




# 从 Git 仓库拉取项目
if [ ${EXIST_GITLAB} = "F" ] ; then
  echo "Pulling Git Repository from ${GITURL} ..."
  git clone https://${GITUSER}:${GITPASS}@${GITURI} ${TARGET}

  if [ -d ${TARGET} ] ; then
    echo "Git Repository has been saved to : ${TARGET}"

  else
    echo "Error: Pull Git Repository Failed."
    exit 1
  fi
fi



# 更新 master 最新的代码以及 branch 、 tag 等信息
echo "Update Git Repository ..."
cd ${TARGET}
git checkout master
git pull



# 切换 branch
# git checkout <branch>
if [ "${GITTAG}" = "latest" ] ; then
  echo "Switch to branch ${GITBRANCH} ..."
  branch=$(git branch -a | grep ${GITBRANCH})
  echo "${branch}"

  if [ -n "${branch}" ]; then
    git checkout ${GITBRANCH} # 切换分支
    git pull        # 更新到分支的最新版本

  else
    echo "Error: branch '${GITBRANCH}' is not exists."
    exit 1
  fi

# 切换 tag (注意 tag 是基线，不需要也不能通过 pull 更新代码)
# git checkout -b <local_branch> <tag>
else
  echo "Switch to tag ${GITTAG} ..."
  tag=$(git tag | grep ${GITTAG})
  branch=$(git branch -a | grep ${GITTAG})

  # 若 tag 存在
  if [ -n "${tag}" ]; then

    # 若未创建该 tag 对应的本地分支，则创建并切换到该分支
    if [ -z "${branch}" ]; then
      git checkout -b ${GITTAG} ${GITTAG}

    # 若已创建该 tag 对应的本地分支，则直接切换到该分支
    else
      git checkout ${GITTAG}
    fi

  else
    echo "Error: tag '${GITTAG}' is not exists."
    exit 1
  fi
fi

echo "Finish: Git Repository has been updated to : ${TARGET}"
exit 0
```