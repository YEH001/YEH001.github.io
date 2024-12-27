---
title: GAMES系列学习笔记
date: 2024-12-21 10:14:26
tags:
- Graphic
categories: 图形学
---

记录GAMES课程中的学习笔记，目前主要包括001基础数学和104现代游戏引擎，102用纸质记录了，后续二刷再改成电子版

<!-- more -->

## GAMES001 图形学中的数学

几何代数、数值方法、微分方程(物理模拟)、优化拓扑(场景模拟)

### 基础概念

#### 世界模拟器

##### 物理模拟

刚体、可变性固体(橡胶、肌肉、雪、奶油)、薄壳类(布料、纸)、流体(水、烟雾、液膜)、流固耦合、磁流体、基于点云估算动力学模型、基于视频的物理场景重建(密度场、速度场)

##### 人体运动

单目视频重建人体骨骼运动、骨骼重定向、动作捕捉、仿真控制、高级控制、语音转手势

##### 仿真模拟

自动驾驶训练、机器人训练、虚拟现实示教、智能体大任务

#### 向量

##### 低维向量

###### 物理空间

Mesh、曲线、点云坐标及导数

###### 颜色空间

RGB、CMYK

##### 高维向量

灰度数字图像上像素组成的向量

二维或三维图形的所有自由度组成的向量

##### 线性映射

缩放、旋转。平移不为线性映射。

仿射变换=缩放、旋转+平移

##### 矩阵

###### 转置

###### 行列式

坐标的拉伸转换

##### 矩阵运算

###### 逆矩阵求解

伴随矩阵、高斯消元

##### 线性变换

###### 2D变换

$$
scale=()
$$

### 几何代数

### 数值方法

### 微分方程

### 优化拓扑

## GAMES101



## GAMES104 现代游戏引擎

游戏引擎架构

### 引擎架构分层

#### Tool Layer 工具层

##### Digital Content Creation 数字资产生成

类似于MAYA、Blender 将数字资产导出与导入

#### Function Layer 功能层

##### **Tick** 时钟周期

###### TickLogic 逻辑

###### TickLogic 渲染

##### 线程

将任务分解成子任务job，使用多核进行计算

#### Resource Layer 资源层

**composeAsset 资产合集** 类似于Unity的Prefab，拥有唯一GUID(全局唯一编号)

**实时资源管理器** 生命周期管理，类GC

#### Core Layer 核心层

##### 数学库

**旋转、放缩** 使用线性变换

**SIMD** 单指令多数据流，SSE 向量计算

##### 数据结构、容器

C++提供的标准化容器高频存取会导致内存碎片化，单纯扩大两倍容量

##### 内存管理

###### Memory Pool/Allocator 内存池

###### Reduce cache miss 缓存命中

###### Memory alignment 内存对齐

#### Platform Layer 平台层

###### Render Hardware Interface(RHI)

包装各个平台的图形API

###### Hardware Architeture

兼容平台、PC的游戏需要考虑硬件结构

### 构建游戏世界

#### 组成

##### Dynamic Game Objects 动态物

##### Static Game Objects 静态物体

##### Environments 环境

###### 地形系统

###### 植被

###### 天空

##### Other

###### Rule 规则

###### Air wall 空气墙

###### TriggerArea 

###### Navigation Mesh 

#### GameObject

##### property 属性

##### Behavior 行为

组件化

##### Interact 交互

使用Event

##### Scene Management 场景管理

###### query 查询场景物体

unique game object ID

object position

###### Spatial Data Structures/Hierarchical Segmentation Method 空间数据结构/多层分割

BVH

Binary Space Partitioning

Octree

Scene Graph

### 引擎绘制系统

#### 渲染概述

##### 四大难题

多类型物体集中绘制

显卡的复杂结构

稳定帧率

硬件计算资源占用

##### Hardware architecture 硬件架构

###### SIMD & SIMT 单指令多数据运算&单指令多线程

###### GPU架构

以Fermi为例https://zhuanlan.zhihu.com/p/661533704

###### Data Flow from CPU to GPU

单向流通会快很多

###### Cache Efficiency

减少cache miss

##### Render data organization 可渲染物体

###### Mesh Render Component

Vertex(Normal\Position\VertexBuffer)

Index(Vertex\IndexBuffer)

Materials、Texture(ALBEDO+NORMAL+METALLIC+ROUGHNWSS+AO)

Shader

SubMesh

Instance 实例化Mesh方便ReUse

Sort by Material 批量渲染(合批)

##### Visibility 可见性数据

###### Culling 视锥剔除

###### Bounding Box 包围盒

###### Hierarchical View Frustum 空间划分

BVH

PVS(Potential Visibility Set) 遮挡剔除

###### GPU Culling

z-buffer 深度剔除

##### Texture Compression 纹理压缩

ASTC

#### Materials，Shaders and Lighting

#### Special Rendering

##### Terrain 地形系统

##### Sky/Fog 天气系统

##### Postprocess 后处理系统

#### Pipeline