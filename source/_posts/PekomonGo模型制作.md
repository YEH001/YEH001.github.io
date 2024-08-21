---
title: PekomonGo模型制作
date: 2023-06-12 17:11:55
tags:"游戏开发"
categories:"Unity"
---

前期准备：https://www.bilibili.com/read/cv13487943

注意Citra模拟器新版没有转为rom的选项，不能直接导入cci，需要用空文件夹存入cci文件再导入

由于我前期建立项目用的不是URP，因此记录一下怎么导入模型

1.往项目里导入URP渲染通道，详见

https://blog.csdn.net/csDN_Smily/article/details/129126082

1.1 首先要确认模型材质支持 URP ，然后新建3D项目，在 Window-->PackageManager--

\>UnityReglstry--->UniversalRP

1.2 Project 面板下面加号点击 ---->Rendering--->Univerasal Pipeline--->PipelineAssetst 创建通用 渲染通道

1.3 管理通道 新建文件夹 重命名为 PiplineFoder, 将创建好的通用渲染通道拖拽到 PiplineFoder 文件夹下

1.4 Edit--->ProgectSttings--->Graphics 在此选项栏找到 Scriptable Render Pipeline Settings 把里面的渲染管线替换成通用渲染管线

1.5 如果导入进来的素材出现材质丢失(紫色)，在确认该素材支持URP的情况下，点击 Edit----\>RenderPipline--->UniverRenderPipline---->Upgrade Project Materials to UniversalRP

Materials （全部资源替换成URP材质选项）



