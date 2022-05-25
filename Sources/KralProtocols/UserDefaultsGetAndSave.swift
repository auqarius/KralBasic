//
//  UserDefaultsGetAndSave.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/18.
//  
//

/*
 
 简化 UserDefaults 的使用，建议按照样例进行使用
 第一，依然使用 UserDefaults，减少记忆负担
 第二，使用 enum 作为 key，可以避免重复 key
 
 样例中的二次封装，不仅可以操作类似 Bool String Int Date 等基础类型
 还可以操作其他自定义类型，中间过程可以自己进行转换
 
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
 
 */

import Foundation

public protocol UserDefaultsGetAndSave {
    var key: String { get }
    
    func remove()
    
    func save(_ value: Any)
    
    func save(_ value: String)
    
    func save(_ value: Int)
    
    func save(_ value: Float)
    
    func save(_ value: Double)
    
    func save(_ value: Bool)
    
    func value() -> Any?
    
    func string() -> String?
    
    func int() -> Int
    
    func float() -> Float
    
    func double() -> Double
    
    func bool() -> Bool
}

public extension UserDefaultsGetAndSave {
    func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func save(_ value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func save(_ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func save(_ value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func save(_ value: Float) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func save(_ value: Double) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func save(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func value() -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func string() -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    func int() -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func float() -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    func double() -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    
    func bool() -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
