---
author: Vker
title: golang-protobuf记录
top: 1
comments: true
brief: ''
tags:
  - golang
  - protobuf
categories:
  - 后端
  - golang
  - protobuf
abbrlink: 353f2255
date: 2019-11-20 11:30:42
cover_picture:
permalink:
---

记录 golang protobuf 的使用 和 遇到的一些问题, 为什么使用这个东西, 我就不说了.

> 涉及的知识点如下:
1. golang protobuf 使用方法
2. proto3 语法规则记录
3. 一些使用中遇到的问题

<!-- more -->

### golang protobuf 使用方法

#### 安装
[参考链接 简书](https://www.jianshu.com/p/c1a29a099ab2)

```
下载protoc
可以去https://github.com/google/protobuf/releases下载源码自己编译
或者https://github.com/google/protobuf/releases去下载编译好的二进制文件

2. 安装protoc-gen-go
go get github.com/golang/protobuf/protoc-gen-go
安装好了之后, 在$GOPATH/bin下面会找到protoc-gen-go.exe

3. 使用protoc.exe 和 protoc-gen-go.exe 生成协议代码
protoc --proto_path=./proto  --go_out=./src_gen/go/    scoreserver/score_info.proto
注意使用的时候, protoc.exe和protoc-gen-go.exe要放在同一个目录下，或者二者的路径都放入环境变量PATH里面

简化命令 ==> protoc --go_out . test.proto

4. 安装protobuf库
go get github.com/golang/protobuf/proto
```
### proto3 语法规则记录

```
开头:

syntax = "proto3"
package pb;

========================

消息体:

message Login {
	string NickName = 1;
	string HeadUrl  = 2;
}

========================

嵌套消息体:

message vec2 {
	float X = 1;
	float Y = 2;
}

message Fight {
	vec2 pos = 1;
}

========================

使用数组:

message Fight {
	repeated vec2 pos = 5;
}
	
```

暂时只用到这几个语法, 暂时就记录这么多, 后面有更复杂的需求时, 会再次更新的

### Problem

#### 关于 omitempty 问题
在 protoc 编译的时候 会在最后面 默认添加这个字段, 这个字段的意思是, 如果这个字段的值 是默认值, 就会在这个 发包中 省略这个字段,

举个例子
```
发送:
{
	name: ""
}

接收: 
{

}
```

name 字段丢失.

#### 解决方案

```
全局查找这个字段 在这个文件中 protoc-gen-go/generator/generator.go
omitempty

tag := fmt.Sprintf(“protobuf:%s json:%q”, g.goTag(message, field, wiretype), jsonName+”,omitempty”)

替换为 ag := fmt.Sprintf(“protobuf:%s json:%q”, g.goTag(message, field, wiretype), jsonName)

重新编译文件
go install github.com/golang/protobuf/protoc-gen-go
```