---
title: python_optionparser模块
comments: true
brief: 对 python optionParser 模块的记录
layout: post
categories:
  - python
tags:
  - python
  - optionParser
abbrlink: ce1d3b12
date: 2018-04-11 16:01:20
permalink:
---
本文主要是 python 对命令行的处理模块 就象是这样的
{% asset_img 1.png show optionParser result}
<!-- more -->
第一步: 导入模块 

``` python
    from optparse import OptionParser
```

第二步: 构建对象

``` python
    parser = OptionParser(usage:"usage: %prog -t theme")
    # 里面是构建程序的相关信息.
    #当然你也可以这样写:
    parser = OptionParser(usage="%prog -t theme", version="%prog 1.0")
    ## 直接输入 --version
    ## 打印 你程序名字 + 版本号
    > -----------------------------------------
    λ python sortFilebySize.py --version
      sortFilebySize.py 1.0
    > -----------------------------------------
    ##这里面 %prog 被直接替换成 你程序的名字 其实就是替换成 os.path.basename.(sys.argv[0]).
```

这个模块主要是对这个函数 `add_option`的使用

第三步: 解析 add_option 函数

``` python
    parser.add_option("-v","--version",
                    action="store",
                    dest="m_version",
                    type="string",
                    default="1.0.0",
                    metavar="version",
                    help="show cur version")
    # help 的帮助 信息里面 是可以使用 %default 传递一个默认值
```

>1-2:前两个是你要提示的参数,长短参数.
>action:acton 有几个值 `store` `store_true` `store_false` `store_const` `append` `count` `callback `
>如果没有指定 dest 参数，将用命令行的参数名来对 options 对象的值进行存取。
store 也有其它的两种形式： store_true 和 store_false ，用于处理带命令行参数后面不 带值的情况。

``` python
    parser.add_option("-v", action="store_true", dest="m_version")
    # 这时候你拿到的值默认会置为True
    parser.add_option("-v", action="store_false", dest="m_version")
    # 这时候你拿到的值默认会置为False
```

>dest:设置对象存储这个值的变量名

``` python
    parser.add_option("-v", action="store_true", dest="m_version")
    (options, args) = parser.parse_args()
    print(options.m_version)
    > -----------------------------------------
    > λ python sortFilebySize.py -v
    >   True
    > -----------------------------------------
```

>type:指定变量的类型
>你也可以指定 add_option() 方法中 type 参数为其它值，如 int 或者 float 等等.

>default:设置这个变量的默认值. 也可以使用这个函数设置 set_defaults()

``` python
    parser.set_defaults(m_version="1.0.0") 
```

>metavar: 设置 add_option 方法中的 metavar 参数，有助于提醒用户，该命令行参数所期待的参数，如 metavar="version"：

`注意： metavar 参数中的字符串会自动变为大写。`

``` python
    > -----------------------------------------
    > λ python sortFilebySize.py -h
    >   Usage: sortFilebySize.py -t theme
    > Options:
    >  # -v VERSION, --version=VERSION show program's version number and exit
    > -----------------------------------------
```

>help:用于显示的提示信息

如果程序有很多的命令行参数，你可能想为他们进行分组，这时可以使用 OptonGroup:进行分组

``` python
    from optparse import OptionGroup
    group = OptionGroup(parser, "Custom Group Options",  
                        "Custom Group show message"
                        "use Custom Group")
    group.add_option("-t",action="store",help="Group options")
    parser.add_option_group(group) 
```

## **处理异常:**
>指因用户输入无效的、不完整的命令行参数而引发的异常.

``` python
    [-]
    (options, args) = parser.parse_args()   
    if options.a and options.b:
        parser.error("options -a and -b invalid")
```

完整的程序例子

``` python
    #! python2
    # coding: utf-8
    from optparse import OptionParser
    from optparse import OptionGroup
    def main():
        parser = OptionParser(usage="usage: %prog -t theme",version="%prog 1.0")
        parser.add_option("-v", action="store_true", dest="m_version")
        group = OptionGroup(parser, "Custom Group Options",  
                        "Custom Group show message"
                        "use Custom Group")
        group.add_option("-t",action="store",help="Group options")
        parser.add_option_group(group)
        (options, args) = parser.parse_args()
        if options.m_version:
            parser.error("options m_version invalid")
        # ...
```
