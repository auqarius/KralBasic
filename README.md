# KralBasic

[![Swift-5.0](https://img.shields.io/badge/Swift-5.0-brightgreen)]()
[![Swift Package Manager - 1.0.0](https://img.shields.io/badge/Swift%20Package%20Manager-1.0.0-orange)]()



这个包是个人在多个项目的积累后频繁使用的代码库，基本每个项目都要把这些代码复制到新项目中。这实属有些麻烦，因此创建这个包来帮助自己把这些代码统一管理。

期待有缘人一起共同进步，有想法的朋友欢迎提交 issue、PR。

## 使用


```
.package(url: "https://github.com/auqarius/KralBasic.git", from: "4.0.0")

// 如果你在国内，你的 xcode 访问 github 基本不通，可以使用国内镜像库

.package(url: "https://gitee.com/krallee/KralBasic", from: "4.0.0")
```


## Common

基础代码使用，直接可以使用的一些代码。

#### Alert

简单的 Alert ActionSheet 调用方法

### Color 

颜色处理方法，包括 hex，亮度调整等功能，附加一个创建纯色图片的功能

### Common

一些简单到不值得被放到单独文件的代码。

* 获取类名字符串
* 延迟执行
* 震动反馈

### DateExtension 

Date 的扩展，包含一些快速获取方法，计算方法，字符串-日期转换方法，使用了 ThreadSaveFormatter 和 Objc 中的 HBDate 来处理字符串日期转换过程中的时间过长问题。

### Device

设备信息获取，包括屏幕宽度，系统信息等。

**依赖于 DeviceKit**

### HTMLStringHandle

解码 HTML 代码

### Navc

一个自定义的 UINavigationController 类，可以自定义相关 appearance.

### Regex

正则匹配

### StringExtension

String 扩展，添加了类型转换，字符串处理等方法，简化了 Swift 中的 substring 获取方法。

### ThreadSaveFormatter

Formatter 的创建比较耗时，因此这里将第一次创建的 formatter 对象保存到线程中，使用的时候直接获取而不创建，提高效率。

### UILabelExtension

UILabel 扩展，添加了富文本，文本点击，内容宽度/高度计算等方法。

### UITextFieldExtension

UITextField 扩展，添加了左右 padding 的支持。

### ViewControllerExtension

UIViewController 扩展，添加了从 storyboard 快速创建和弹出发送邮件页面的方法。

### ViewExtension

UIView 扩展，添加了 UIView 动画，xib 快速加载，添加 tap 事件，绘制渐变背景等方法。

## Objc

某些代码可能无法用 Swift 实现，因此这个 target 是用来保存 OC 代码的，不对外进行暴露，内部 target 添加 Objc 的依赖来对外部进行暴露。

## Protocols

需要根据自己的需求进行使用的协议类，提供一个功能的解决方案，但是到具体项目依然要根据选择来使用。

### App

 App 信息，App 跳转等，需要的时候可以使用
 
 ```
 Example:
 
 class App: AppInfos {
    
     static var appStoreId: String {
         get {
             return "1234567"
         }
     }
 
 }
 
 Use:
 
 App.appName   App.appVersion
 
 App.toAppSotre()
 
 App.toAppStoreWriteReview()
 
 App.showReviewInApp()
 ```
 
 ### AppUIStack
 
在开发中如果不刻意考虑页面框架和跳转逻辑，很容易导致结构混乱，页面跳转冲突。因此在开发过程中使用一个统一的类来管理整个项目的页面框架结构和跳转。可以让开发者能在开发过程中集中于并时刻思考整个页面的架构。可以有效避免结构混乱，页面跳转冲突。
 
AppUIStack 将此类抽象出来成为一个协议，完成一些基础的功能。并且在遵循了此协议的类中，可以直接进行页面框架结构和跳转的管理
 
```
 Example:
 
 class VCRouter: AppUIStack {
     
     static var currentVC: UIViewController? {
         get {
             // 获取当前 vc 的方法，具体根据项目结构来
         }
     }
     
     static var rootViewController: UIViewController? {
         get {
             // 获取 rootViewController 的方法
             // 这个主要是为满足在不同 App 状态/用户状态下，App 可能展示不一样的内容的
             // 主要根据具体业务来
         }
     }
     
     /// 其他页面结构/跳转方法
 }
 
 Use:
 
 VCRoter.makeKetWindow(window)
```

### NotificationPostAndRegister

简化本地通知的使用，建议按照样例方式进行使用。

第一使用的依然是 NotificationCenter 类，减少记忆负担；

第二使用 enum 来管理所有的本地通知，可以保证不重复。
 
 ```
 Example:
 
 extension NotificationCenter {
    
    enum App: String, NotificationPostAndRegister {
        
        case didLogin = "didLogin"
 
        var name: NSNotification.Name {
            get {
                return NSNotification.Name(rawValue: rawValue)
            }
        }
 
    }
 
 }
 
 Use:
 
 NotificationCenter.App.didLogin.post("Kral")
 
 NotificationCenter.App.didLogin.register(self, selector: @selector(didLogin))
 
 NotificationCenter.App.didLogin.remove(self)
 ```
 
### UserDefaultsGetAndSave

 简化 UserDefaults 的使用，建议按照样例进行使用。
 
 第一，依然使用 UserDefaults，减少记忆负担；
 
 第二，使用 enum 作为 key，可以避免重复 key.
 
 样例中的二次封装，不仅可以操作类似 Bool String Int Date 等基础类型。还可以操作其他自定义类型，中间过程可以自己进行转换。
 
 ```
 Example:

 extension UserDefaults {
 
     enum UDKeys: String, UserDefaultsGetAndSave {
         case isFirstOpen = "App_isFirstOpen"
         case someCacheValue = "comeCacheValue"
         
         var key: String {
             get {
                 return rawValue
             }
         }
     }
     
     var isFirstOpen: Bool {
         get {
             return UDKeys.isFirstOpen.bool()
         }
         set {
             UDKeys.isFirstOpen.save(newValue)
         }
     }
     
 }

 Use:
 
 UserDefaults.isFirstOpen = true

 if UserDefaults.isFirstOpen {
     
 }
 ```

## KralBasicTests

单元测试类，后续将会针对每个类的属性/方法进行单元测试代码的编写，保证代码质量。


## Todo

⬜️ 单元测试

✅ 设备信息获取 - Device

⬜️ 多语言支持

⬜️ 绘图（贝塞尔曲线）

⬜️ 文件管理

⬜️ HUD

⬜️ Mac 支持


