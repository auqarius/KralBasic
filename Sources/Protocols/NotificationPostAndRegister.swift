//
//  NotificationPostAndRegister.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/18.
//  
//
//
/*
 
 简化本地通知的使用，建议按照样例方式进行使用
 第一使用的依然是 NotificationCenter 类，减少记忆负担
 第二使用 enum 来管理所有的本地通知，可以保证不重复
 
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
 
 */

import Foundation

protocol NotificationPostAndRegister {
    
    var name: NSNotification.Name { get }
    
    func register(observer: Any, selector: Selector)
    
    func post(object: Any?)
    
    func remove(observer: Any)
}

extension NotificationPostAndRegister {
    
    func register(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    func post(object: Any?) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    func remove(observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }
    
}
