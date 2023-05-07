//
//  UserDefaultsGetAndSave.swift
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
 
         var userDefaults: UserDefaults {
             get {
                return UserDefaults.standard
             }
        }
     
     static var isFirstOpen: Bool {
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
    
    var userDefaults: UserDefaults { get }
    
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
        userDefaults.removeObject(forKey: key)
    }
    
    func save(_ value: Any) {
        userDefaults.set(value, forKey: key)
    }
    
    func save(_ value: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func save(_ value: Int) {
        userDefaults.set(value, forKey: key)
    }
    
    func save(_ value: Float) {
        userDefaults.set(value, forKey: key)
    }
    
    func save(_ value: Double) {
        userDefaults.set(value, forKey: key)
    }
    
    func save(_ value: Bool) {
        userDefaults.set(value, forKey: key)
    }
    
    func value() -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    func string() -> String? {
        return userDefaults.value(forKey: key) as? String
    }
    
    func int() -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    func float() -> Float {
        return userDefaults.float(forKey: key)
    }
    
    func double() -> Double {
        return userDefaults.double(forKey: key)
    }
    
    func bool() -> Bool {
        return userDefaults.bool(forKey: key)
    }
}
