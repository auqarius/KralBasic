//
//  Regex.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/20.
//  
//
//  正则相关

import Foundation

public extension String {
    public var isEmail: Bool {
        get {
            let types: NSTextCheckingResult.CheckingType = [NSTextCheckingResult.CheckingType.link]
            let dataDetector = try! NSDataDetector(types: types.rawValue)
            
            let matches = dataDetector.matches(in: self, options: [], range: NSMakeRange(0, count))
            
            for match in matches {
                if let urlString = match.url?.absoluteString {
                    return urlString.contains("mailto:")
                }
            }
            
            return MyRegex.match(string: self, type: .email)
        }
    }
    
    public var isNumber: Bool {
        get {
            return MyRegex.match(string: self, type: .number)
        }
    }
    
    public var isPhone: Bool {
        get {
            let types: NSTextCheckingResult.CheckingType = [NSTextCheckingResult.CheckingType.phoneNumber]
            let dataDetector = try! NSDataDetector(types: types.rawValue)
            
            let matches = dataDetector.matches(in: self, options: [], range: NSMakeRange(0, count))
            
            var matched = false
            for match in matches {
                if match.phoneNumber != nil {
                    matched = true
                    break
                }
            }
            
            return MyRegex.match(string: self, type: .phone) && matched
        }
    }
    
    public var isIpAddress: Bool {
        get {
            return MyRegex.match(string: self, type: .ipaddress)
        }
    }
    
}

// MARK: - 正则匹配 Regex Match
public struct MyRegex {
    
    public enum MatchType: String {
        /// Email 校验正则表达式
        case email = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        /// 国内电话校验正则表达式
        case phone = "^1[0-9]{10}$"
        /// ip 地址校验正则表达式
        case ipaddress = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        /// 数字校验正则表达式
        case number = "^[0-9]*$"
    }
    
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    /// 检测输入字符串是否符合规则
    ///
    /// - Parameter input: 输入字符串
    /// - Returns: 是否符合规则
    func match(input: String) -> Bool {
        if let matches = matchString(input: input) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
    
    /// 检测某一个输入是否能匹配到
    ///
    /// - Parameter input: 输入
    /// - Returns: 匹配到的字符串
    func matchString(input: String) -> [NSTextCheckingResult]? {
        return regex?.matches(in: input,
                              options: [],
                              range: NSMakeRange(0, (input as NSString).length))
    }
    
    public static func match(string: String, type: MatchType) -> Bool {
        return MyRegex(type.rawValue).match(input: string)
    }
}
