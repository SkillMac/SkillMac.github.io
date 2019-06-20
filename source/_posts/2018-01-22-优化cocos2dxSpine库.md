---
title: 优化cocos2dxSpine库
brief: 对cocos2dxSpine库的升级和优化
categories:
    - cocos2dx
tags:
  - spine
comments: true
abbrlink: c4c0a180
date: 2018-01-22 20:44:31
---
# **对cocos2dxSpine库的升级和优化**

### **本文的大纲**
1.升级spine在cocos2dx-3.15的运行时库
2.优化spine在创建的时候效率

在开发的时候出现的问题
1.spine这个软件导出3.6新加的特效在cocos2dx3.15 不能使用
2.spine在批量创建的时候帧数会下降
<!-- more -->
### **升级spine ->3.6** ###
[spine code github 地址](https://github.com/EsotericSoftware/spine-runtimes)
去这个地址clone或者是下载Zip这个你随便
然后会产现这个目录
<!-- ![]() -->
{% asset_img spine-code_1.png spine的目录 %}
主要就是我使用箭头标记的这两个目录

    spine-c/spine-c/include/spine/*.h
    spine-c/spine-c/src/spine/*.c
    spine-cocos2dx/src/spine/*.cpp  and  spine-cocos2dx/src/spine/*.h

找到自己的工程的根目录 然后去找这个目录
全部放在 `···/frameworks/cocos2d-x/cocos/editor-support/spine`

直接全部替换
然后打开自己的VS去编译记住一点将你添加的C或C++的文件给添加到libSpine的工程中的源文件中

{% asset_img libSpine_1.png 添加到libSpine的工程中去 %}

选中 Source Files 执行 `Shift + Alt + A` 添加现有项  或者是鼠标右键添加好可以

然后编译,你会惊奇的发现编译成功了,但是不要高兴的太早了,因为这个在编译Android的时候会报错,当然原因也很简单，接着往下面看。

**在Android中的实现**
你找到 这个目录里面会有 `···/frameworks/cocos2d-x/cocos/editor-support/spine`
`Android.mk`的文件
将你添加的写在这个配置里面 注意只写 *.h 的文件
然后使用 Android Studio 编译 Apk, 这里你也可以使用NDK编译,但是在Android2.？这个不记得了,就已经不在支持NDK编译了
所以还是使用Android Studio 吧

在 ios 中的实现也是同样如此，这里就不再讲述了

### **优化spine在创建的时候效率** ###
在原先的 spine 创建的时候每次都需要解析数据,生成骷髅数据,其实这个是很消耗CPU的,导致FPS下降。
我的做法是保留 spine create 的原有接口,自己再从新写一个新的接口。
原理：创建字典<map>保留骷髅数据每次创建的时候询问这个 Map 是否存在 key 没有创建,有直接使用。

代码的写法有很多种,我这只是参考

在SkeletonAnimation.cpp 中添加如下代码
``` c++
    SkeletonAnimation* SkeletonAnimation::createFromCache(const std::string& key_skeletonData)
    {
        if (spSkeletonData* skeleton_data = SkeletonAnimation::getSkeletonDataFromCache(key_skeletonData))
        {
            return SkeletonAnimation::createWithData(skeleton_data, false);
        }
        else
        {
            skeleton_data = SkeletonAnimation::loadSkeletonDataToCache(key_skeletonData, key_skeletonData + ".json", key_skeletonData + ".atlas");
            if (skeleton_data) 
            {
                return SkeletonAnimation::createWithData(skeleton_data, false);
            }
        }
        
        return nullptr;
    }
    spSkeletonData* SkeletonAnimation::loadSkeletonDataToCache(const std::string& key_skeletonData, const std::string& skeletonJsonFile, const std::string& atlasFile, float scale)
    {
        iteratorSkeletonData it = _allSkeletonDataCache.find(key_skeletonData);

        if (it == _allSkeletonDataCache.end())
        {
            SkeletonDataInCache skeleton_data_in_cache;
            spAtlas* atlas = nullptr;
            spAttachmentLoader* attachmentLoader = nullptr;
            skeleton_data_in_cache._skeleton_data = nullptr;

            atlas = spAtlas_createFromFile(atlasFile.c_str(), 0);
            CCASSERT(atlas, "loadSkeletonDataToCache Error  atlas file.");

            attachmentLoader = SUPER(Cocos2dAttachmentLoader_create(atlas));

            spSkeletonJson* json = spSkeletonJson_createWithLoader(attachmentLoader);
            json->scale = scale;
            skeleton_data_in_cache._skeleton_data = spSkeletonJson_readSkeletonDataFile(json, skeletonJsonFile.c_str());
            CCASSERT(skeleton_data_in_cache._skeleton_data, json->error ? json->error : "loadSkeletonDataToCache Error reading skeleton data file.");
            spSkeletonJson_dispose(json);
            spAtlas_dispose(atlas);

            if (skeleton_data_in_cache._skeleton_data)
            {
                _allSkeletonDataCache[key_skeletonData] = skeleton_data_in_cache;
                return skeleton_data_in_cache._skeleton_data;
            }
            else
            {
                //error release
                if (skeleton_data_in_cache._skeleton_data)
                {
                    spSkeletonData_dispose(skeleton_data_in_cache._skeleton_data);
                }
            }
        }

        return nullptr;
    }
    spSkeletonData* SkeletonAnimation::getSkeletonDataFromCache(const std::string& key_skeletonData)
    {
        iteratorSkeletonData it = _allSkeletonDataCache.find(key_skeletonData);
        if (it != _allSkeletonDataCache.end())
        {
            return it->second._skeleton_data;
        }

        return nullptr;
    }
    bool SkeletonAnimation::removeSkeletonData(const std::string& key_skeletonData)
    {
        iteratorSkeletonData it = _allSkeletonDataCache.find(key_skeletonData);
        if (it != _allSkeletonDataCache.end()) {
            if (it->second._skeleton_data) spSkeletonData_dispose(it->second._skeleton_data);

            _allSkeletonDataCache.erase(it);
            return true;
        }

        return false;
    }
    void SkeletonAnimation::removeAllSkeletonData()
    {
        for (iteratorSkeletonData it = _allSkeletonDataCache.begin(); it != _allSkeletonDataCache.end(); ++it) {
            if (it->second._skeleton_data) spSkeletonData_dispose(it->second._skeleton_data);
        }

        _allSkeletonDataCache.clear();
    }
    bool SkeletonAnimation::isExistSkeletonDataInCache(const std::string& key_skeletonData)
    {
        iteratorSkeletonData it = _allSkeletonDataCache.find(key_skeletonData);
        if (it != _allSkeletonDataCache.end()) {
            return true;
        }

        return false;
    }
    //end
    std::map<std::string, SkeletonAnimation::SkeletonDataInCache> SkeletonAnimation::_allSkeletonDataCache;
```

在 SkeletonAnimation.h 中添加如下代码
``` c++
    static SkeletonAnimation* createFromCache(const std::string& key_skeletonData);
    static spSkeletonData* loadSkeletonDataToCache(const std::string& key_skeletonData, const std::string& skeletonJsonFile, const std::string& atlasFile, float scale = 1);
    static spSkeletonData* getSkeletonDataFromCache(const std::string& key_skeletonData);
    static bool removeSkeletonData(const std::string& key_skeletonData);
    static void removeAllSkeletonData();
    static bool isExistSkeletonDataInCache(const std::string& skeletonDataKeyName);

    private:
        struct SkeletonDataInCache {
            spSkeletonData* _skeleton_data; 
        };
        typedef std::map<std::string, SkeletonDataInCache>::iterator iteratorSkeletonData;
        static std::map<std::string, SkeletonDataInCache> _allSkeletonDataCache;
        //end
```

### **Binding to lua**
既然写了这么多了,就要将这些代码绑定到lua中去

找到自己工程的的libluacocos2d的工程
{% asset_img auto_binding_2_lua_1.png 绑定C++到lua %}
这里你可以自己写代码在 `lua_cocos2dx_spine_auto.cpp` 中,但是这不是一个程序员应该做的。
第二种做是:既然它的文件名有 `auto` 这个单词,一看就不是人写出来的,OK,去寻找答案。

到这个目录中去 `···/frameworks/cocos2d-x/tools/tolua/` 你会发现有一个`genbindings.py`的文件
你一运行可能报错,你去读他的 `README.md` ,发现他要你装一些python的库,那就按照说的安装吧
你可以 pip 命令也可以 自己下载zip 这个随意。
然后就是配置NDK,这个下载解压,配置 path 就完了,我就不多说了。

然后你运行可能还会报错

那就打开 `genbindings.py` 你会发现他需要的是NDK **3.3-3.4** 然而自己的NDK经过查看 是 **3.5-3.6** 没关系,把它这个所有相关 **3.3  3.4** 全部改成 **3.5-3.6**的就OK了。

改完后运行 Prefect ^-^.

### **在lua中调用**
``` lua
    sp.SkeletonAnimation: createFromCache(key)
    sp.SkeletonAnimation: isExistSkeletonDataInCache(key)
    sp.SkeletonAnimation: loadSkeletonDataToCache(key,jsonFilePath,atlasFilePath,scale =1)      
    sp.SkeletonAnimation: getSkeletonDataFromCache(key)
    sp.SkeletonAnimation: removeSkeletonData(key)
    sp.SkeletonAnimation: removeAllSkeletonData()
```

这里面有一个问题是你会发现返回的`骨胳数据`拿不到,这个是cocos2dx在绑定的时候并没有将这个数据类型绑定lua去,我上面那么写就是为了以后留个接口,当然你也可以自己把那个返回值去掉。

好了今天就到这吧。
