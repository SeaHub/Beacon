# Beacon
![Supporter](http://on9ydhp18.bkt.clouddn.com/pics/20170618205508_dQZ1ek_Supporter.jpeg) ![Architecture](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_W94axV_Architecture.jpeg) ![Backend](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_TGf2e2_Backend.jpeg) ![Dependency](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_xF0g8n_Dependency.jpeg) ![License](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_zFUvyr_License.jpeg) ![Platform](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_TCtNzu_Platform.jpeg) ![IDE](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_VQWET8_IDE.jpeg) ![Language](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_UXtbau_Language.jpeg) ![Device](http://on9ydhp18.bkt.clouddn.com/pics/20170618205432_OFpf5X_Device.jpeg)

Beacon - The production of Echo team in the Best Developer Competition of iQiYi.

[中文文档](https://github.com/SeaHub/Beacon/blob/master/README-zh.md)

[Backend Document（后端文档）Here](https://github.com/Desgard/Beacon-Flask)

![App-1](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_9KMtre_App-1.jpeg)

![App-2](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_B39Rn6_App-2.jpeg)

![App-3](http://on9ydhp18.bkt.clouddn.com/pics/20170618194831_ahGZds_App-3.jpeg)

## Feature Overview

### Page Feature
- [x] Sliding smoothly on Home Page（Supporting drawing card from the middle and playing video randomly）
- [x] Beautiful favorite and history page with sense of depth
- [x] Video Player with full-screen, muting, light-closing functions, besides, volume and brightness can be set by swiping the screen on the phone.


### Function Feature

- [x] Shaking in the video page may transform the player into full-screen state quickly
- [x] Double-Clicked the video page may close light quickly
- [x] Use 3D Touch outside the app may play a video randomly
- [x] Local notification will be received when the data updates (every 24 hours)
- [x] Reload button will be shown on the home page while network breaking

### Development Feature

- [x] Use `UNNotification` to realize local notification
- [x] Use `YYCache` to realize memory-cache and disk-cache
- [x] Use `Keychain` to realize the unique UUID saving and getting. UUID is useful in the app, which is used to call the api of favorite and history function
- [x] Use `UITableView` + `UIView Animation` to realize animations in the app

## Join developing

## Project Specification

* Use `EC` which stands for `Echo` as prefix file name to maintain the proper namespace
* Use `debugLog` instead of `NSLog` when debugging
* Use `_` as prefix with private methods
* Use a tab standing for 4 space, the tail bracket and the lower camel case naming specification
* Use `ECBeacon-Prefix.pch` as pre compile header, which imports `ECUtil` and `ECConstant`
  * Please code common functions in `ECUtil` with proper comment
  * Please code common constant in `ECConstant` with proper comment
* Please code Unit Tests in `CacheTests`、`CacheAPITests`、`NetworkTests`  when codes involving network or cache added


## Preparation for development

1. Get the IOSPlayerLib provided by iQiYi, and place it in ~/Beacon/Beacon folder, as the photo shows below

   ![SettingA](http://on9ydhp18.bkt.clouddn.com/pics/20170618204439_BndnaO_Project-Setting-A.jpeg)

2. Excute `pod install` command on the shell

3. Open `Beacon.xcworkspace` , click navigator section and open `Pods Target`

4. Set the value `NO` to the `Project - Pods - Target - Build Active Architecture Only`, as the photo shows below

   ![SettingB](http://on9ydhp18.bkt.clouddn.com/pics/20170618204439_xUKMft_Project-Setting-B.jpeg)

5. Common + B to link and build the project, and join development with us！


### Directory Structure

- View + Main.storyboard：Views of app
- Model：Models of app
- Controller：Controller of app
- Others
  - Category：Some extension method to the apple
  - Tools
    - UNNotification：Wrapper of UNNotification, use it to send local notification
    - Cache：Wrapper of Cache, use it to save and get from cache
    - Util：Commond tools, please code common functions in `ECUtil` with proper comment
    - Keychain：Wrapper of Keychain，use it to save and get from keychain
  - Network：Wrapper of network api
  - BeaconTests
    - CacheTests：Unit test of lower cache api
    - CacheAPITests：Unit test of higher cache api
    - NetworkTests：Unit test of network api

### Third Party Library used in the app

* QYPlayer：Use on the player
* IQActivityIndicatorView：Use to indicate 'Loading'
* CCDraggableCard：Use to layout the home page
* Masonry：Use to layout views
* SDWebImage：Use to load photos
* YYCache：Use to cache datas on both memory and disk
* AFNetworking：Use to send request and get response on the net

Thanks to all the selfless authors above!

## GNU General Public License v3.0

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
