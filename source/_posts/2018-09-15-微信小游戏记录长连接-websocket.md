---
title: 微信小游戏记录长连接(websocket)
comments: true
brief: 记录微信小游戏开发时的问题
layout: post
categories:
  - 微信小游戏
tags:
  - 微信小游戏
  - websocket
abbrlink: ba881459
date: 2018-09-15 10:55:43
permalink:
---
哎,距离上次写博客竟然一个月了,真是时间不等人呀,好了废话不多说,直接进入正题.
今天主要记录这几个问题:

- websocket 端口问题,
- http(短连接) 端口问题,

由于公司的云服务器都是使用的是阿里云,但是小游戏是腾讯的,腾讯云又推出了一堆有利于小游戏的服务,但是我们用不来了,那就自己去解决里面会遇到的问题,
<!-- more -->
## websocket 端口问题

在微信小游戏里面所有用户的逻辑服务器或者是资源服务器 都是需要在微信公众平台配置服务器信息,但是微信是只要求使用 wss 协议 而且还必须是443端口,这就会暴露出一个问题,因为 https 写协议也是 443 端口,, 这就会出现端口占用问题?

解决的方案 使用 nginx 反向代理功能, 主要的思路就是 让 nginx 占用443 端口,然后在由 nginx 去分发不同的请求.

这里也没有什么好讲的吧 ,, 主要是 nginx 的配置表需要配置正确, 就可以实现上述的功能,这里就去讲解一下那个配置表要配置的东西,

```
# 将 http 连接升级
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

# 这个 配置反向代理的地址
upstream websocket {
    server 127.0.0.1:3000;
}

server {
    # 开启 443 端口监听
    listen 443 ssl;
    ...
    # 配置证书  这个是需要你自己的ssl证书
    ssl_certificate *.crt
    ssl_certificate_key *.key

    # 这几个 也需要配置 , 这个我 还没有 特备的清楚具体的作用, 暂时就先不解释了
    ssl_session_timeout 5m;
    ssl_session_cache shared:SSL:50m;
    ssl_protocols TLSV1.1 TLSV1.2 SSLv2 SSLv3;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers  on;

    location /wss{
                proxy_pass https://websocket/;   # 代理到上面的地址去
                proxy_http_version 1.1;
                # 协议升级
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
        }
}
```

然后 运行 nginx -t 去检查语法是否有误

如果没有出现错误 ,,, 就 nginx -s reload // 重启

然后你就可以 使用 http https wss 协议了
wss://localhost/wss
https://localhost/
http://localhost/

## http 短连接端口问题

微信小游戏短连接是使用的是 https 协议 一般 https 的默认端口是 443 , 一般你在浏览器没有加端口,那是浏览器默认为443 ,,, 但是前面说了可以使用 nginx 来实现反向代理的问题, 如果是短连接的话 有个简单的 方法 ,, 经过我测试, 在微信后台配置其他端口在手机上是可以访问,所以 如果项目只是 短连接请求的话可以直接在后台配置你服务器开启的端口,这种方法只适用于 短连接,,, 长连接是不行, 长连接在 后台配置 会出现 在 微信开发工具上测试正常,到手机上测试会出现操作失败的错误,,,而且也连接不上.

好了,这篇文章就先这样. 我也不想 让文章的篇幅过长.