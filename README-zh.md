# Beacon
![Supporter](http://on9ydhp18.bkt.clouddn.com/pics/20170618205508_dQZ1ek_Supporter.jpeg) ![Architecture](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_W94axV_Architecture.jpeg) ![Backend](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_TGf2e2_Backend.jpeg) ![Dependency](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_xF0g8n_Dependency.jpeg) ![License](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_zFUvyr_License.jpeg) ![Platform](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_TCtNzu_Platform.jpeg) ![IDE](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_VQWET8_IDE.jpeg) ![Language](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_UXtbau_Language.jpeg) ![Device](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_OFpf5X_Device.jpeg)

## 简介

爱奇艺最强开发者大赛 Echo 团队参赛作品 - Beacon（iOS 中文文档） 

[English Document Here](https://github.com/SeaHub/Beacon)    

[后端文档（Backend Document）Here](https://github.com/Desgard/Beacon-Flask)

![App-1](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_9KMtre_App-1.jpeg)

![App-2](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_B39Rn6_App-2.jpeg)

![App-3](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_ahGZds_App-3.jpeg)

## 特性概览

### 页面特性
- [x] 带有滑动顺畅感的卡片首页（支持从中间抽出卡片，或点击中间卡片实现随机播放）
- [x] 带有层次感的收藏与历史页面
- [x] 带有全屏、静音、关灯、手势拖动、音量与亮度调整功能的播放器页面


### 功能小特性

- [x] 播放器页面摇一摇可快速全屏
- [x] 播放器页面双击可快速关灯
- [x] 应用外点击应用图标使用 3D Touch 可快速随机播放视频
- [x] 数据更新（24小时）时，会收到本地通知提醒
- [x] 非 WiFi、蜂窝数据下，首页自动显示重试按钮

### 开发特性

- [x] UNNotification 实现本地通知
- [x] YYCache 实现本地数据缓存
- [x] Keychain 实现唯一 UUID的存取，并利用该 UUID 实现收藏、历史等功能
- [x] UITableView + UIView Animation 实现主要动画

## 参与开发

### 项目规范

* 使用 EC 作为团队 Echo 的代表前缀，避免命名空间冲突
* 调试打印时请使用 debugLog 进行输出打印
* 使用 _ 作为私有方法的前缀修饰
* 使用 4 个空格代表一个 Tab，且使用尾括号、小驼峰式命名规范
* 预编译头文件：ECBeacon-Prefix.pch，其引用了 ECUtil 与 ECConstant 类
  * 通用函数请在 ECUtil 内编写并标明注释
  * 通用常量请在 ECConstant 内编写
* 涉及缓存、网络请求的方法，请于 CacheTests、CacheAPITests、NetworkTests 三个类中编写合理的单元测试方法，并保证通过

### 开发前的准备

1. 获取由爱奇艺官方提供的 [IOSPlayerLib](https://pan.baidu.com/s/1gfxfyc7) 播放器库，并放置 ~/Beacon/Beacon 目录下，如下图示

   ![SettingA](http://on9ydhp18.bkt.clouddn.com/pics/20170618204439_BndnaO_Project-Setting-A.jpeg)

2. 在 Podfile 目录执行 pod install 命令

3. 打开 Beacon.xcworkspace 文件，点击项目导航选项卡，打开 Pods Target

4. 点击 Project - Pods - Target 下的 Build Active Architecture Only，设置值为 NO，如下图示

   ![SettingB](http://on9ydhp18.bkt.clouddn.com/pics/20170618204439_xUKMft_Project-Setting-B.jpeg)

5. Commond + B 进行链接与编译后，即参与到我们的开发工作中！

### 目录结构

- View + Main.storyboard：负责整个应用界面层的构建
- Model：负责应用模型的构建
- Controller：负责应用控制器的构建
- Others
  - Category：对官方类的一些扩展
  - Tools
    - UNNotification：通知封装，若需使用本地通知可调用其中的函数
    - Cache：缓存封装，若需使用缓存可调用其中的函数
    - Util：通用工具，通用函数请在 ECUtil 内编写并标明注释
    - Keychain：Keychain 封装，若需使用 Keychain 可调用其中的函数
  - Network：网络层接口的封装
  - BeaconTests
    - CacheTests：缓存底层接口的单元测试
    - CacheAPITests：缓存上层接口的单元测试
    - NetworkTests：网络 API 接口的单元测试

### 使用到的第三方库

* QYPlayer：用于播放器
* IQActivityIndicatorView：用于提示"正在加载中"
* CCDraggableCard：用于首页布局
* Masonry：用于界面布局
* SDWebImage：用于图片加载
* YYCache：用于内存缓存与硬盘缓存
* AFNetworking：用于网络请求

十分感谢上述作者的无私奉献！

## GNU General Public License v3.0

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
