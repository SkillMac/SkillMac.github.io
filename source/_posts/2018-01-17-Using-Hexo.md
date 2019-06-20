---
title: Using-Hexo
categories: hexo
tags:
  - hexo
  - IT
comments: true
brief: 对Hexo的使用
abbrlink: 6743743b
date: 2018-01-17 20:07:49
permalink:
---
这篇文章只是我对 hexo 的一些功能的测试吧，可能后会常用到这些东西
## Requirements

## install Hexo 

```
{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}
```
<!-- more -->
{% blockquote %}
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque hendrerit lacus ut purus iaculis feugiat. Sed nec tempor elit, quis aliquam neque. Curabitur sed diam eget dolor fermentum semper at eu lorem.
{% endblockquote %}

{% blockquote David Levithan, -Wide Awake %}
Do not just seek happiness for yourself. Seek happiness for all. Through kindness. Through mercy.
{% endblockquote %}

{% blockquote @DevDocs https://twitter.com/devdocs/status/356095192085962752 %}
NEW: DevDocs now comes with syntax highlighting. http://devdocs.io
{% endblockquote %}

{% blockquote Seth Godin http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html Welcome to Island Marketing %}
Every interaction is both precious and an opportunity to delight.
{% endblockquote %}

```
{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}
```

{% codeblock %}
alert('Hello World!');
print('Hello World!')
{% endcodeblock %}

language -> OC
{% codeblock lang:objc %}
[rectangle setX: 10 y: 10 width: 20 height: 20];
{% endcodeblock %}

language -> python
{% codeblock lang:objc %}
print('Hello World!')
{% endcodeblock %}

### **附加说明**
{% codeblock Array.map %}
array.map(callback[, thisArg])
{% endcodeblock %}

### **反引号代码块**
` [language] [title] [url] [link text] code snippet `

language - >OC
``` objc
[rectangle setX: 10 y: 10 width: 20 height: 20];
```

### **插入Image图片**
```
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
{% asset_img fileName.* title}
```

{% asset_img 1.jpg wolf %}
{% asset_path test.lua %}
{% asset_link test.lua %}

### **引用文章**
```
{% post_path slug %}
{% post_link slug [title] %}
```


### **使用iframe**
```
{% iframe url [width] [height] %}
```

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=515143440&auto=0&height=66"></iframe>

<!-- {% iframe //music.163.com/outchain/player?type=2&id=515143440&auto=0&height=66 330 90 %} -->



<!-- {% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
{% img } -->



