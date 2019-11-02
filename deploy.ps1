# Github Pages 要求所发布的 Html 路径不能有下划线，否则无法解析
# 此脚本的目的是把 GitBook 生成的 _book 目录复制到 book

Remove-Item gitbook/book -recurse

docker run --rm -v "$PWD/gitbook:/gitbook" -p 4000:4000 exp/gitbook-server gitbook build

Copy-Item gitbook/_book gitbook/book -recurse

echo "Deploy Finish."
echo "You can push to github now."