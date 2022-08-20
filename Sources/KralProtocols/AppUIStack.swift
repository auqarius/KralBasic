//
//  AppUIStack.swift
//
//  Created by LiKai on 2022/5/18.
//  
//
/*
 
 在开发中如果不刻意考虑页面框架和跳转逻辑，很容易导致结构混乱，页面跳转冲突
 因此在开发过程中使用一个统一的类来管理整个项目的页面框架结构和跳转
 可以让开发者能在开发过程中集中于并时刻思考整个页面的架构
 可以有效避免结构混乱，页面跳转冲突
 
 AppUIStack 将此类抽象出来成为一个协议，完成一些基础的功能
 并且在遵循了此协议的类中，可以直接进行页面框架结构和跳转的管理
 
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
 
 */
#if canImport(UIKit)

import Foundation
import UIKit

public protocol AppUIStack {
    
    /// 获取当前 keyWindow，iPad 多窗口也可以正确获取
    static var keyWindow: UIWindow? { get }
    
    /// 当前正在显示的 VC
    static var currentVC: UIViewController? { get }
    
    /// 当前状态下应该显示 rootViewController，makeKeyWindow 和 remakeKeyWindow 需要
    static var rootViewController: UIViewController? { get }
    
    /// 配置 window，设置 rootViewController，window 设置为 key
    static func makeKeyWindow(_ window: UIWindow)
    
    /// 获取当前 keyWindow，重新设置 rootViewController
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - options: 动画类型
    static func remakeKeyWindow(duration: TimeInterval, options: UIView.AnimationOptions)
    
}

public extension AppUIStack {
    
    /// 获取当前 keyWindow，iPad 多窗口也可以正确获取
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 配置 window，设置 rootViewController，window 设置为 key
    static func makeKeyWindow(_ window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    /// 获取当前 keyWindow，重新设置 rootViewController
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - options: 动画类型
    static func remakeKeyWindow(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        guard let window = keyWindow else {
            return
        }
        window.rootViewController = rootViewController

        UIView.transition(with: window, duration: duration, options: options, animations: {})
    }
}

#endif
