---
layout: post
title: Hello World
data: '2018-1-17 17:37'
comments: true
categories:
    - hexo
tags:
  - hello world
  - github page
  - 博客
brief: 搭建自己的博客
abbrlink: 4a17b156
---

搭建自己的博客在github page
---
经过2天的折腾的终于把自己的博客给搭建出来了,也可以说是自己的一个`Hello World` 吧
<!-- more -->
这个主题是使用**Litten**的theme通过hexo搭建

## **准备环境** ##
    * install git   
    * install node
    * 注册github的账号

[Git Download](https://git-scm.com/downloads)
[nodejs Download](http://nodejs.cn/download/)
[github 注册的地址](https://github.com/)

## **再创建之前思考一个事情**
就是在你做完这些之后，你开始写自己的博客的时候，突然之间要换电脑了，这个时候你要怎么办
这个思考是对于那些使用过 github 或者是使用过别的版本控制的工具。 

## **Build to blog** ##
    安装 nodejs 很简单,就是傻瓜式的安装。
    在安装 git 的时候也是一键式安装。
    然后自己注册github的账号。

记得配置自己的 `nodejs的Path`

在 cmd 窗口 输入 path
![path](/assets/hello-world/path_1.png)
我自己的 `nodejs` 在E盘

同样看看自己的 git 的 path 有没有配置

然后就是验证你的安装是否正确打开你 cmd 输入 git
![git](/assets/hello-world/git_1.png)
输入 node -v
![node -v](/assets/hello-world/node_1.png)
github 就不用验证了吧

然后就是利用 node 的 npm 工具去安装 hexo 输入 

    npm install -g hexo-cli

如果自己的 hexo 安装成功的话

在 cmd 中 输入 hexo -v
![hexo -v](/assets/hello-world/hexo_1.png)

## **创建自己的 hexo 工程**
假设自己的 hexo 的工程目录是在 D:\Pro\pro_wdh\nodejs

    1. 在 cmd 中 输入 pushd D:\Pro\pro_wdh\nodejs
    2. cmd的当前目录直接跳转到 D:\Pro\pro_wdh\nodejs
    3. 使用 hexo init 命令 初始化  （）hexo init [folderName] ）

> hexo init hexo
> cd hexo
> nmp install

完成之后目录结构如下：

    .
    ├── _config.yml
    ├── package.json
    ├── scaffolds
    ├── source
    |   ├── _drafts
    |   └── _posts
    └── themes
### **_config.yml**
网站的 配置 信息，您可以在此配置大部分的参数。

### **package.json**
应用程序的信息。EJS, Stylus 和 Markdown renderer 已默认安装，您可以自由移除。

### **scaffolds**
模版 文件夹。当您新建文章时，Hexo 会根据 scaffold 来建立文件。

Hexo的模板是指在新建的markdown文件中默认填充的内容。例如，如果您修改scaffold/post.md中的Front-matter内容，那么每次新建一篇文章时都会包含这个修改。

### **source**
资源文件夹是存放用户资源的地方。除 _posts 文件夹之外，开头命名为 _ (下划线)的文件 / 文件夹和隐藏的文件将会被忽略。Markdown 和 HTML 文件会被解析并放到 public 文件夹，而其他文件会被拷贝过去。

### **themes**
主题 文件夹。Hexo 会根据主题来生成静态页面。

## **运行自己的hexo工程**

在 cmd 中 输入 hexo s 
![](/assets/hello-world/hexo_2.png)

在自己的浏览器中打开 `http://localhost:4000/.`

这时你会看到自己的静态网页

[更多的 hexo的命令](https://segmentfault.com/a/1190000002632530)
[hexo 的官网](https://hexo.io/zh-cn/)

## **部署自己的笔记2github**

网上的一些教程都是 使用 SSH 去上传自己的博客
但是使用 htpp 的方式也同样可以 上传

创建自己的 github 的仓库
![](/assets/hello-world/github_1.png)
上面的仓库名字就和你 github 的名字一样就行了

然后就是在 hexo 的根目录下的 _config.yml 中 找到
![](/assets/hello-world/config_1.png)
按照图片上的配置自己的 github 仓库的地址
github 仓库的地址在这里拿
![](/assets/hello-world/github_2.png)

然后执行 hexo的命令 在cmd中输入  

    1.hexo clean
    2.hexo g
    3.hexo d

静静的等待

上传完成之后

打开 `http://Test.github.io` 就可以看到自己的博客了

## **回答上面的提出的思考**

答案就是 在 github 上创建自己的 branch(分支)

我是在自己的 github 创建自己的 blog(分支)

[git 的一些命令](http://note.youdao.com/noteshare?id=7abb057f779aca20328c74a7c810e027&sub=855026A2B8904F61A0933D26CA9E27FF)

不是太全,但是应对日常还是可以的

做法如下：
    
    git chcekout -b blog
    git add -A
    git commit - m "commit my blog"
    git push origin blog

解释一下吧

> 创建新的分支 blog
> 添加自己的文件到缓存区
> 提交到本地版本库
> 推送到远端

[更多 git 的知识](http://www.runoob.com/?s=git)

这只是一些基础

更多需要你多去尝试,多自己动手。

有疑问可以加QQ一起讨论


