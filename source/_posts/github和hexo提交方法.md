---
title: github和hexo提交方法
date: 2023-06-12 11:40:53
tags:
categories: 日志管理
---

由于总是记不住github和hexo提交方法，需要现搜，因此写个博客记录一下

<!-- more -->

### github 提交方法

#### 1.本地提交到main

```
git init #已经初始化就不需要
git status #查看未追踪文件，非必要
git add xxx
git status #查看未提交文件，非必要
git commit -m "注释"
git status #查看文件是否提交，非必要
git branch -M main
git remote add origin git@github.com/xxxxxx.git
git pull
git push -u origin main #提交到main
```



### hexo提交方法

在cmd中cd到blog/xxx文件里面

#### 1.新建文章

```
hexo new "articleName"
```

#### 2.上传博客

```
hexo clean
hexo g
hexo d
hexo s #在本地服务器查看
```

#### 3.新建页面

```
hexo n page menu #新建页面，地址为：主页地址/aboutme/
```

