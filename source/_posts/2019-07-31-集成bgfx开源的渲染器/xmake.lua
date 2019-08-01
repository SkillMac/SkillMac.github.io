-- add_includedirs("Engine")
-- includes("Engine/core/xmake.lua")

-- add_includedirs("Engine/thirdparty/glad/include")
-- includes("Engine/xmake.lua")

local BGFX_DIR = "deps/bgfx/"
local BX_DIR = "deps/bx/"
local BIMG_DIR = "deps/bimg/"
local GLFW_DIR = "deps/glfw-3.3/"
local GLM_DIR = "deps/glm"

set_project("vker")
set_version("0.0.1")

add_rules("mode.debug", "mode.release")

target("vkEngine")
    add_deps("bgfx")
    add_deps("bx")
    add_deps("bimg")
    add_deps("glfw")

    set_kind("binary")

    add_includedirs(BGFX_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty")
    add_includedirs(BGFX_DIR .. "3rdparty/dxsdk/include")
    add_includedirs(BGFX_DIR .. "3rdparty/khronos")
    add_includedirs(BX_DIR .. "include")
    add_includedirs(BX_DIR .. "include/compat/msvc")
    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(GLFW_DIR .. "include")
    add_includedirs(GLM_DIR)

    add_includedirs("src/")

    if is_mode("debug") then 
        add_linkdirs("$(buildir)/libs/debug")
        add_links("glfw", "bgfx", "bx", "bimg")
    elseif is_mode("release") then

    end
    

    add_ldflags("/SUBSYSTEM:CONSOLE")

    add_files("src/**.cpp")

target("bgfx")
    set_kind("static")
    
    set_targetdir("$(buildir)/libs")

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

    if is_mode("debug") then
        add_defines("BGFX_CONFIG_DEBUG=1")
    end

    add_includedirs(BGFX_DIR .. "include")
    add_includedirs(BGFX_DIR .. "3rdparty")
    add_includedirs(BGFX_DIR .. "3rdparty/dxsdk/include")
    add_includedirs(BGFX_DIR .. "3rdparty/khronos")
    add_includedirs(BX_DIR .. "include")
    add_includedirs(BX_DIR .. "include/compat/msvc")
    add_includedirs(BIMG_DIR .. "include")

    -- default cl complier
    add_files(BGFX_DIR .. "src/**.cpp|amalgamated.cpp|glcontext_glx.cpp|glcontext_egl.cpp")
    add_syslinks("user32", "gdi32")
    

target("bimg")
    set_kind("static")

    set_targetdir("$(buildir)/libs")

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

    add_includedirs(BIMG_DIR .. "include")
    add_includedirs(BIMG_DIR .. "3rdparty/astc-codec")
    add_includedirs(BIMG_DIR .. "3rdparty/astc-codec/include")
    add_includedirs(BX_DIR .. "include")
    add_includedirs(BX_DIR .. "include/compat/msvc")
    
    add_files(BIMG_DIR .. "src/image.cpp")
    add_files(BIMG_DIR .. "src/image_gnf.cpp")
    add_files(BIMG_DIR .. "3rdparty/astc-codec/src/decoder/*.cc")

target("bx")
    set_kind("static")

    set_targetdir("$(buildir)/libs")
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

    add_includedirs(BX_DIR .. "include")
    add_includedirs(BX_DIR .. "include/bx/inline")
    add_includedirs(BX_DIR .. "include/compat/msvc")
    add_includedirs(BX_DIR .. "3rdparty")

    add_files(BX_DIR .. "src/**.cpp|amalgamated.cpp|crtnone.cpp")

target("glfw")
    set_kind("static")

    set_targetdir("$(buildir)/libs")
    add_includedirs(GLFW_DIR .. "include")

    add_files(GLFW_DIR .. "src/context.c")
    add_files(GLFW_DIR .. "src/egl_context.c")
    add_files(GLFW_DIR .. "src/init.c")
    add_files(GLFW_DIR .. "src/input.c")
    add_files(GLFW_DIR .. "src/monitor.c")
    add_files(GLFW_DIR .. "src/osmesa_context.c")
    add_files(GLFW_DIR .. "src/vulkan.c")
    add_files(GLFW_DIR .. "src/window.c")

    if is_plat("windows") then
        add_defines("_GLFW_WIN32", "_CRT_SECURE_NO_WARNINGS", "_WIN64")
        
        add_files(GLFW_DIR .. "src/win32_*.c")
        add_files(GLFW_DIR .. "src/wgl_context.c")
    elseif is_plat("linux") then
        add_defines("_GLFW_X11")

        add_files(GLFW_DIR .. "src/glx_context.c")
        add_files(GLFW_DIR .. "src/linux*.c")
        add_files(GLFW_DIR .. "src/posix*.c")
        add_files(GLFW_DIR .. "src/x11*.c")
        add_files(GLFW_DIR .. "src/xkb*.c")
    end

    add_syslinks("shell32")
