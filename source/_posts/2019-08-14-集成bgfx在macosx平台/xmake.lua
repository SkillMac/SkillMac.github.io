-- add_includedirs("Engine")
-- includes("Engine/core/xmake.lua")

-- add_includedirs("Engine/thirdparty/glad/include")
-- includes("Engine/xmake.lua")

local BGFX_DIR = "deps/bgfx/"
local BX_DIR = "deps/bx/"
local BIMG_DIR = "deps/bimg/"
local GLFW_DIR = "deps/glfw-3.3/"
local GLM_DIR = "deps/glm/"
local CHAI_DIR = "deps/chaiscript/"

set_project("vker")
set_version("0.0.1")

add_rules("mode.debug", "mode.release")

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

target("chai")
    set_kind("binary")
    
    add_cxxflags("-std=c++14", "-stdlib=libc++")
    add_includedirs(CHAI_DIR .. "include")
    add_files(CHAI_DIR .. "src/main.cpp")
    add_files(CHAI_DIR .. "static_libs/*.cpp")

    if is_plat("windows") then
        add_defines("WIN32", "_WINDOWS", "NDEBUG", "CMAKE_INTDIR=Release")
    elseif is_plat("macosx") then
        add_defines("NDEBUG")
    end 


