//
//  Device.swift
//  MyHabits
//
//  Created by Kral on 21/3/21.
//  Copyright © 2021 Kral. All rights reserved.
//
#if canImport(UIKit)

import Foundation
import DeviceKit
import UIKit

// MARK: - UIScreen Extension
extension UIScreen {
    
    /// 状态栏高度
    var statusBarHeight: CGFloat {
        get {
            if UIDevice.isiPhoneFullScreen {
                return 44
            }
            if UIDevice.isiPad {
                return 44
            }
            return 20
        }
    }
    
    /// toolbar/tabbar 底部的 safeArea 高度
    /// 如果是全面屏 iPhone 那么这个高度就是 34 否则为 0
    /// 如果是全面屏 iPad 那么这个高度就是 24 否则为 0
    var safeAreaBottomHeight: CGFloat {
        get {
            if UIDevice.isiPhone {
                return UIDevice.isiPhoneFullScreen ? 34 : 0
            }
            if UIDevice.isiPad {
                return UIDevice.isiPadFullScreen ? 24 : 0
            }
            return 0
        }
    }

    /// 导航栏高度
    var navigationBarHeight: CGFloat {
        get {
            return 44
        }
    }

    /// tabbar 的内容高度
    var tabBarContentHeight: CGFloat = 49

    /// tabbar 的高度
    var tabBarHeight: CGFloat {
        get {
            return tabBarContentHeight + safeAreaBottomHeight
        }
    }

    /// toolbar 的内容高度
    var toolbarContentHeight: CGFloat = 49

    /// toolbar 的高度
    var toolBarHeight: CGFloat {
        get {
            return toolbarContentHeight + safeAreaBottomHeight
        }
    }
    
    /// 屏幕宽度
    static var deviceWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    /// 屏幕高度
    static var deviceHeight: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    
    /// App 显示区域宽度
    /// iPad 分屏下可能会和屏幕宽度不一致
    static var width: CGFloat {
        get {
            if UIDevice.isiPhone {
                return UIScreen.main.bounds.size.width
            } else {
                return UIApplication.shared.keyWindow?.bounds.width ?? UIScreen.main.bounds.size.width
            }
        }
    }
    
    /// App 显示区域高度
    /// iPad 分屏下可能会和屏幕高度不一致
    static var height: CGFloat {
        get {
            if UIDevice.isiPhone {
                return UIScreen.main.bounds.size.height
            } else {
                return UIApplication.shared.keyWindow?.bounds.height ?? UIScreen.main.bounds.size.height
            }
        }
    }
    
    /// 物理意义上的屏幕宽度，跟设备旋转没有关系
    static var logicWidth: CGFloat {
        get {
            return min(width, height)
        }
    }
    
    /// 物理意义上的屏幕高度，跟旋转设备没有关系
    static var logicHeight: CGFloat {
        get {
            return max(width, height)
        }
    }
    
    /// 是否是在分屏
    static var isSplitView: Bool {
        get {
            return width < deviceWidth
        }
    }
    
    /// 当前分屏状态
    static var splitMode: SplitMode {
        get {
            if !isSplitView {
                return .none
            }
            if width < (deviceWidth - 10)/2 {
                return .oneInThree
            } else if width == (deviceWidth - 10)/2 {
                return .half
            } else if width > (deviceWidth - 10)/2 && width < deviceWidth {
                return .twoInThree
            } else {
                return .none
            }
        }
    }
    
    /// 分屏状态枚举
    enum SplitMode {
        /// 一半
        case half
        /// 三分之一
        case oneInThree
        /// 三分之二
        case twoInThree
        /// 无分屏
        case none
    }
}

// MARK: - UIDevice Extension
extension UIDevice {
    
    /// 是否是横屏
    static var isLandScape: Bool {
        get {
            return UIDevice.current.orientation.isLandscape
        }
    }
    
    @objc static let isiPad = Device.current.isPad || (Device.current.isSimulator && Device.current.isPad)
    @objc static let isiPhone = Device.current.isPhone || (Device.current.isSimulator && Device.current.isPhone)
    
    @objc static let isiPhone4 = isDevice(.iPhone4)
    @objc static let isiPhone55sSe = isOneOfDeviceIn([.iPhone5, .iPhone5s, .iPhoneSE, .iPhoneSE2])
    @objc static let isiPhone66s78 = isOneOfDeviceIn([.iPhone6, .iPhone6s, .iPhone7, .iPhone8])
    @objc static let isiPhone66s78p = isOneOfDeviceIn([.iPhone6Plus, .iPhone6s, .iPhone7Plus, .iPhone8Plus])
    @objc static let isiPhoneX = isDevice(.iPhoneX)
    @objc static let isiPhoneXR = isDevice(.iPhoneXR)
    @objc static let isiPhoneXS = isDevice(.iPhoneXS)
    @objc static let isiPhoneXSMax = isDevice(.iPhoneXSMax)
    @objc static let isiPhone11 = isDevice(.iPhone11)
    @objc static let isiPhone11Pro = isDevice(.iPhone11Pro)
    @objc static let isiPhone11ProMax = isDevice(.iPhone11ProMax)
    @objc static let isiPhone12 = isDevice(.iPhone12)
    @objc static let isiPhone12Mini = isDevice(.iPhone12Mini)
    @objc static let isiPhone12Pro = isDevice(.iPhone12Pro)
    @objc static let isiPhone12ProMax = isDevice(.iPhone12ProMax)
    @objc static let isiPhone13 = isDevice(.iPhone13)
    @objc static let isiPhone13Mini = isDevice(.iPhone13Mini)
    @objc static let isiPhone13Pro = isDevice(.iPhone13Pro)
    @objc static let isiPhone13ProMax = isDevice(.iPhone13ProMax)
    
    @objc static let isiPadPro12 = isOneOfDeviceIn([.iPadPro12Inch, .iPadPro12Inch2, .iPadPro12Inch3, .iPadPro12Inch4, .iPadPro12Inch5])
    @objc static let isiPadPro11 = isOneOfDeviceIn([.iPadPro11Inch, .iPadPro11Inch2, .iPadPro11Inch3])
    @objc static let isiPadPro10 = isOneOfDeviceIn([.iPadPro10Inch])
    @objc static let isiPadPro9 = isDevice(.iPadPro9Inch)
    
    @objc static let isiPadAir = isOneOfDeviceIn([.iPadAir, .iPadAir2, .iPadAir3, .iPadAir4])

    @objc static let isiPadMini = isOneOfDeviceIn([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6])
    
    @objc static let isNormaliPad = isOneOfDeviceIn([.iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPad7, .iPad8, .iPad9])

    // 全面屏手机(这里的判定是有顶部的传感器集合，也就是刘海)
    @objc static let isiPhoneFullScreen = isOneOfDeviceIn(Device.allDevicesWithSensorHousing)
    // iPad Pro 所有系列都有 iPad 全屏的特性
    @objc static let isiPadFullScreen = isOneOfDeviceIn(Device.allDevicesWithRoundedDisplayCorners)
    
    static let isiOS8AndLater = (Float(UIDevice.current.systemVersion)! >= Float(8.0))
    static let isiOS8Family = (Float(UIDevice.current.systemVersion)! >= Float(8.0)) && (Float(UIDevice.current.systemVersion)! < Float(9.0))
    static let isiOS9Family = (Float(UIDevice.current.systemVersion)! >= Float(9.0)) && (Float(UIDevice.current.systemVersion)! < Float(10.0))
    static let isiOS10Family = (Float(UIDevice.current.systemVersion)! >= Float(10.0)) && (Float(UIDevice.current.systemVersion)! < Float(11.0))
    static let isiOS11Family = (Float(UIDevice.current.systemVersion)! >= Float(11.0)) && (Float(UIDevice.current.systemVersion)! < Float(12.0))
    static let isiOS12Family = (Float(UIDevice.current.systemVersion)! >= Float(12.0)) && (Float(UIDevice.current.systemVersion)! < Float(13.0))
    static let isiOS13Family = (Float(UIDevice.current.systemVersion)! >= Float(13.0)) && (Float(UIDevice.current.systemVersion)! < Float(14.0))
    static let isiOS14Family = (Float(UIDevice.current.systemVersion)! >= Float(14.0)) && (Float(UIDevice.current.systemVersion)! < Float(15.0))
    static let isiOS15Family = (Float(UIDevice.current.systemVersion)! >= Float(15.0)) && (Float(UIDevice.current.systemVersion)! < Float(16.0))
    
    static var systemName: String {
        return UIDevice.current.systemName
    }
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var sysNameVersion: String {
        get {
            return systemName + " " + systemVersion
        }
    }
    
    static func isDevice(_ device: Device) -> Bool {
        return (Device.current == device) || (Device.current == .simulator(device))
    }
    
    static func isOneOfDeviceIn(_ devices: [Device]) -> Bool {
        for device in devices {
            if isDevice(device) {
                return true
            }
        }
        return false
    }

}

#endif
