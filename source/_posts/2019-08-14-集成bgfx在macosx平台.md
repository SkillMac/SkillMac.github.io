---
author: Vker
title: 集成bgfx在macosx平台
comments: true
brief: ''
tags:
  - cpp
  - bgfx
  - xmake
  - lua
  - 前端
categories:
  - 前端
  - bgfx
abbrlink: 4c19fcfe
date: 2019-08-14 11:24:55
cover_picture: https://s2.ax1x.com/2019/08/01/eUkNJs.jpg
permalink:
---
这一篇实在上一篇在windows平台的基础上加上 macosx 平台的编译
[上一篇地址传送门](http://leng521.top/posts/ea56194d/)

> 涉及的知识点,如下:
1. 使用 xmake 构建工程, xmake 使用lua 不会可以简单的补一下语法
2. 修复编译 bgfx 时报的错误
3. 编译 shaderc 可执行文件
4. 编译 glsl 到二进制, 因为bgfx 使用编译后的着色器代码
5. 编译 glfw, bgfx, bimg, bx 库


<!-- more -->

这里就不在详细说之前的配置了,这里主要说明 macosx xmake的配置

### bgfx的 xmake 配置

```lua
target("bgfx")
    set_kind("static")

    add_cxxflags("-std=c++14", "-stdlib=libc++")
    add_mxxflags("-std=c++14", "-stdlib=libc++")
    
    if is_mode("debug") then
        set_targetdir("$(buildir)/libs/debug")
    elseif is_mode("release") then
        set_targetdir("$(buildir)/libs/release")
    end

    add_includedirs(BGFX_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty")
    add_includedirs(BX_DIR .. "include")
    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty/khronos")
    
    if is_plat("windows") then
        add_defines("__STDC_LIMIT_MACROS"
                , "__STDC_FORMAT_MACROS"
                , "__STDC_CONSTANT_MACROS"
                , "NDEBUG"
                , "WIN32"
                , "_WIN32"
                , "_HAS_EXCEPTIONS=0"
                , "_HAS_ITERATOR_DEBUGGING=0"
                , "_ITERATOR_DEBUG_LEVEL=0"
                , "_SCL_SECURE=0"
                , "_SECURE_SCL=0"
                , "_SCL_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_DEPRECATE")

        add_includedirs(BGFX_DIR .. "3rdparty/dxsdk/include")
        add_includedirs(BX_DIR .. "include/compat/msvc")

        add_syslinks("user32", "gdi32")

        -- default cl complier
        add_files(BGFX_DIR .. "src/**.cpp|amalgamated.cpp") --|glcontext_glx.cpp|glcontext_egl.cpp

    elseif is_plat("macosx") then
        add_defines("NDEBUG")
        add_cxxflags("-Wno-microsoft-enum-value", "-Wno-microsoft-const-init", "-x objective-c++")
        --add_mxxflags("-Wno-microsoft-enum-value", "-Wno-microsoft-const-init", "-x objective-c++")

        add_mxxflags("-weak_framework Metal", "-weak_framework MetalKit")
        add_ldflags("-weak_framework Metal", "-weak_framework MetalKit")

        add_frameworks("CoreVideo","IOKit","Cocoa","QuartzCore","OpenGL")
        add_includedirs(BX_DIR .. "include/compat/osx")

        add_files(BGFX_DIR .. "src/glcontext_**.mm")
        add_files(BGFX_DIR .. "src/renderer_**.mm")
        add_files(BGFX_DIR .. "src/**.cpp|amalgamated.cpp")
    end


    if is_mode("debug") then
        add_defines("BGFX_CONFIG_DEBUG=1")
  
    end
```

上面配置表的逻辑应该写的很清楚了,这里简单的说明一下.
1. bgfx使用了c++14的特性但是默认编译器是c++11 所以要指定到c++14
2. bgfx 依赖的库有: Metal, MetalKit, CoreVideo, IOKit, Cocoa, QuartzCore, OpenGL

下面编译 bimg和 bx 库都是同样的道理,这里我就直接放置配置文件了

### bx 的 xmake 配置
```lua
target("bx")
    set_kind("static")

    add_cxxflags("-std=c++14", "-stdlib=libc++")

    if is_mode("debug") then
        set_targetdir("$(buildir)/libs/debug")
    elseif is_mode("release") then
        set_targetdir("$(buildir)/libs/release")
    end

    add_includedirs(BX_DIR .. "include")
    add_includedirs(BX_DIR .. "include/bx/inline")

    if is_plat("windows") then 
        add_defines("__STDC_LIMIT_MACROS"
                , "__STDC_FORMAT_MACROS"
                , "__STDC_CONSTANT_MACROS"
                , "NDEBUG"
                , "WIN32"
                , "_WIN32"
                , "_HAS_EXCEPTIONS=0"
                , "_HAS_ITERATOR_DEBUGGING=0"
                , "_ITERATOR_DEBUG_LEVEL=0"
                , "_SCL_SECURE=0"
                , "_SECURE_SCL=0"
                , "_SCL_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_DEPRECATE")

        add_includedirs(BX_DIR .. "include/compat/msvc")
        add_includedirs(BX_DIR .. "3rdparty")

        add_files(BX_DIR .. "src/**.cpp|amalgamated.cpp") --|crtnone.cpp

    elseif is_plat("macosx") then
        add_includedirs(BX_DIR .. "include/compat/osx")
        add_includedirs(BX_DIR .. "3rdparty")

        add_files(BX_DIR .. "src/**.cpp|amalgamated.cpp")
    end
    
```

### bimg 的 xmake 配置
```lua
target("bimg")
    set_kind("static")
    add_cxxflags("-std=c++14", "-stdlib=libc++")

    if is_mode("debug") then
        set_targetdir("$(buildir)/libs/debug")
    elseif is_mode("release") then
        set_targetdir("$(buildir)/libs/release")
    end

    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(BIMG_DIR .. "3rdparty/astc-codec")
    add_includedirs(BIMG_DIR .. "3rdparty/astc-codec/include")
    add_includedirs(BX_DIR .. "include")
    
    if is_plat("windows") then 

        add_defines("__STDC_LIMIT_MACROS"
                , "__STDC_FORMAT_MACROS"
                , "__STDC_CONSTANT_MACROS"
                , "NDEBUG"
                , "WIN32"
                , "_WIN32"
                , "_HAS_EXCEPTIONS=0"
                , "_HAS_ITERATOR_DEBUGGING=0"
                , "_ITERATOR_DEBUG_LEVEL=0"
                , "_SCL_SECURE=0"
                , "_SECURE_SCL=0"
                , "_SCL_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_WARNINGS"
                , "_CRT_SECURE_NO_DEPRECATE")

        add_includedirs(BX_DIR .. "include/compat/msvc")

    elseif  is_plat("macosx") then 
        add_includedirs(BX_DIR .. "include/compat/osx")        
    end
    
    add_files(BIMG_DIR .. "src/image.cpp")
    add_files(BIMG_DIR .. "src/image_gnf.cpp")
    add_files(BIMG_DIR .. "3rdparty/astc-codec/src/decoder/*.cc")
```

### glfw 的 xmake 配置
```lua
target("glfw")
    set_kind("static")

    if is_mode("debug") then
        set_targetdir("$(buildir)/libs/debug")
    elseif is_mode("release") then
        set_targetdir("$(buildir)/libs/release")
    end
    add_includedirs(GLFW_DIR .. "include")

    add_files(GLFW_DIR .. "src/context.c")
    
    add_files(GLFW_DIR .. "src/init.c")
    add_files(GLFW_DIR .. "src/input.c")
    add_files(GLFW_DIR .. "src/monitor.c")
    add_files(GLFW_DIR .. "src/vulkan.c")
    add_files(GLFW_DIR .. "src/window.c")

    if is_plat("windows") then
        add_defines("_GLFW_WIN32", "_CRT_SECURE_NO_WARNINGS", "_WIN64")
        
        add_files(GLFW_DIR .. "src/win32_*.c")
        add_files(GLFW_DIR .. "src/wgl_context.c")
        add_files(GLFW_DIR .. "src/egl_context.c")
        add_files(GLFW_DIR .. "src/osmesa_context.c")

        add_syslinks("shell32")
    elseif is_plat("linux") then
        add_defines("_GLFW_X11")

        add_files(GLFW_DIR .. "src/glx_context.c")
        add_files(GLFW_DIR .. "src/osmesa_context.c")
        add_files(GLFW_DIR .. "src/linux*.c")
        add_files(GLFW_DIR .. "src/posix*.c")
        add_files(GLFW_DIR .. "src/x11*.c")
        add_files(GLFW_DIR .. "src/xkb*.c")
    
    elseif is_plat("macosx") then

        add_defines("_GLFW_COCOA")
        add_frameworks("CoreVideo","IOKit","Cocoa","CoreFoundation")

        add_files(GLFW_DIR .. "src/cocoa_*.m")
        add_files(GLFW_DIR .. "src/cocoa_time.c")
        add_files(GLFW_DIR .. "src/posix_thread.c")
        add_files(GLFW_DIR .. "src/nsgl_context.m")
        add_files(GLFW_DIR .. "src/egl_context.c")
        add_files(GLFW_DIR .. "src/osmesa_context.c")

        add_mflags("-fno-common")
        add_cflags("-fno-common")
    end
```

> 这里面加了linux版本的配置但是没有实测,这里你们注意一下.
这里主要的问题就是 你要正确的过滤出每个平台的需要加入编译的文件, 具体你可以参考 glfw的cmake 配置

### 链接到工程里面
```lua
target("vkEngine")

    add_cxxflags("-std=c++14", "-stdlib=libc++")
    add_mxxflags("-std=c++14", "-stdlib=libc++")
    
    add_deps("bgfx")
    add_deps("bx")
    add_deps("bimg")
    add_deps("glfw")

    set_kind("binary")

    add_includedirs(BGFX_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty")
    
    add_includedirs(BGFX_DIR .. "3rdparty/khronos")
    add_includedirs(BX_DIR .. "include")
    
    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(GLFW_DIR .. "include")
    add_includedirs(GLM_DIR)

    if is_plat("windows") then

        add_includedirs(BGFX_DIR .. "3rdparty/dxsdk/include")
        add_includedirs(BX_DIR .. "include/compat/msvc")

        add_ldflags("/SUBSYSTEM:CONSOLE")
    
    elseif is_plat("macosx") then
        add_includedirs(BX_DIR .. "include/compat/osx")
        add_frameworks("CoreVideo","IOKit","Cocoa","CoreFoundation", "Foundation", "QuartzCore", "OpenGL")
        add_mxxflags("-weak_framework Metal", "-weak_framework MetalKit")
        add_ldflags("-weak_framework Metal", "-weak_framework MetalKit")
    end

    add_includedirs("src/")

    if is_mode("debug") then 
        add_linkdirs("$(buildir)/libs/debug")
        add_links("glfw", "bgfx", "bx", "bimg")
    elseif is_mode("release") then
        add_linkdirs("$(buildir)/libs/release")
        add_links("glfw", "bgfx", "bx", "bimg")
    end

    add_files("src/**.cpp|mesh.cpp|bounds.cpp")
```
这里你们看看也就是应该知道这里都做了什么了,

### 编译shader metal版

默认 macosx上使用 metal 图形库
```shell
./shaderc -f ../../examples/cubes/vs_cubes.sc -o ../../examples/cubes/shaders/metal/vs_cubes.bin --varyingdef ../../examples/cubes/varying.def.sc --platform osx -i ../../examples/common/sh/ -p metal --type vertex
./shaderc -f ../../examples/cubes/fs_cubes.sc -o ../../examples/cubes/shaders/metal/fs_cubes.bin --varyingdef ../../examples/cubes/varying.def.sc --platform osx -i ../../examples/common/sh/ -p metal --type fragment
```

具体每个参数是什么用可以去看上一篇文章有介绍这些东西.

### 编译好的可执行文件
我这里放上我编译好的 macosx平台 Release 版的工具
里面包含 `geometryc` 	`geometryv` `texturec` `texturev` `shaderc`

[下载地址](https://www.lanzous.com/i5kf5af)

### ending
这里我就不放代码了,,, 需要你们自己动手去做,,, 我可以把构建配置发给你们
我也只是用了一点, 后面会继续深入,,, 大家一块学习,,, 讨论交流.
这个官方的文档比较的少, 不全面, 需要自己多看看他们的例子和源码.

xmake.lua 配置
{% asset_link xmake.lua %}
