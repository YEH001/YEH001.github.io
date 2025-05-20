hexo clean
hexo g
hexo d # 更新服务器上的博文
git pull origin hexo
git checkout hexo
git merge hexo
git add .
git commit -a -m 'update'
git push
