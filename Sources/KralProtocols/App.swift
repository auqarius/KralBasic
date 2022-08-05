//
//  App.swift
//
//  Created by LiKai on 2022/5/21.
//  
//
/*
 
 App 信息，App 跳转等，需要的时候可以使用
 
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
 
 */
#if canImport(UIKit)

import Foundation
import StoreKit
import UIKit

public protocol AppInfos {
    /// App 在 App Store 的 id 需要自己来写
    static var appStoreId: String { get }
    
    /// App 的名字，会自动获取
    static var appName: String { get }
    
    /// App 的版本，会自动获取
    static var appVersion: String { get }
    
    /// 跳转 App Store 的 url
    static var toAppStoreUrlStr: String { get }
    
    /// 跳转 App Store 并开始编写评论的 url
    static var writeReviewUrlStr: String { get }
    
    /// 跳转 App Store
    static func toAppStore()
    
    /// 跳转 App Store 并开始编写评论
    static func toAppStoreWriteReview()
    
    /// 在 App 内部展示评论打星弹框
    static func showReviewInApp()
    
    /// 打开一个 URL，可以是 Stirng 也可以是 URL
    static func openUrl(_ url: Any)
}

public extension AppInfos {
    
    static var appName: String {
        get {
            return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
        }
    }
    
    static var appVersion: String {
        get {
            (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
        }
    }
    
    static var toAppStoreUrlStr: String {
        get {
            return "https://itunes.apple.com/app/id\(appStoreId)"
        }
    }
    
    static var writeReviewUrlStr: String {
        get {
            return "itms-apps://itunes.apple.com/app/id\(appStoreId)?action=write-review"
        }
    }
    
    static func toAppStore() {
        openUrl(toAppStoreUrlStr)
    }
    
    static func toAppStoreWriteReview() {
        openUrl(writeReviewUrlStr)
    }
    
    static func showReviewInApp() {
        if #available(iOS 13.0, *) {
            let activeScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            let windowScene = activeScenes.first { $0 is UIWindowScene }
            
            if let scene = windowScene as? UIWindowScene {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: scene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        } else {
            SKStoreReviewController.requestReview()
        }
        
    }
    
    static func openUrl(_ url: Any) {
        var realURL: URL?
        if let urlStr = url as? String,
               let tempUrl = URL(string: urlStr) {
                   realURL = tempUrl
               }
        if let tempUrl = url as? URL {
            realURL = tempUrl
        }
        
        if let availableURL = realURL {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(availableURL, options: [:]) { (completed) in
                    
                }
            } else {
                UIApplication.shared.open(availableURL)
            }
        }
    }
}

#endif
