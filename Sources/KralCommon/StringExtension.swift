//
//  StringExtension.swift
//
//  Created by LiKai on 2022/5/19.
//  
//

import Foundation
import CommonCrypto

public extension String {
    var float: Float {
        if let number = NumberFormatter.default.number(from: self) {
            return number.floatValue
        }
        return 0.0
    }
    
    var int: Int {
        if let number = NumberFormatter.default.number(from: self) {
            return number.intValue
        }
        return 0
    }
    
    var double: Double {
        let nf = NumberFormatter.localDefault()
        if let number = nf.number(from: self) {
            return number.doubleValue
        }
        return 0.0
    }
    
    var bool: Bool {
        let trimmed = self.trimmed().lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return false
    }
    
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        return DateFormatter.default(format).date(from: self)
    }
    
    func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return DateFormatter.default(format).date(from: self)
    }
}

public extension String {

    
    /// 查找字符串中位于两个字符串中间的子串
    /// 例如 "<a>word</a>".between("<a>", "</a>")  ->  "word"
    ///
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of:left), let rightRange = range(of: right, options: .backwards, range: nil, locale: nil), left != right && self[leftRange].endIndex != self[rightRange].startIndex
            else { return nil }

        return String(self[self[leftRange].endIndex..<self[rightRange].startIndex])

    }
    
    /// 驼峰化字符串，使用空格, "-", "_" 来区分的单词会被驼峰化，首字母小写
    /// 例如："hello world".camelize -> "helloWorld"
    /// "HelloWorld".camelize -> "helloWorld"
    /// "hello World everyone" -> "helloWorldEveryone"
    /// "hello_world" -> "helloWorld"
    /// "hello-world" -> "helloWorld"
    var camelize: String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.contains(" ") {
            let first = source.prefix(1)
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: "")) as String
            let rest = String(cammel.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased.prefix(1)
            let rest = String(source.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    /// 全首字母大写
    /// 例如： "hello world" -> "Hello World"
    func capitalize() -> String {
        return capitalized
    }
    
    /// 是否包含
    func contains(substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    /// 将单词之间的空格和换行（无论多少个）都换成一个空格
    func collapseWhitespace() -> String {
        let components = components(separatedBy: NSCharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    /// 替换字符串中出现的字符串为某个特定字符串
    /// 例如："hello_world-to_every-people".clean(with: " ", allOf: "-", "_")
    ///      -> hello world to every people
    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    /// 计算某个子串出现的次数
    func count(substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// 确认字符串是否以某个串开始，如果不是则添加，如果是则不进行操作
    func ensureLeft(prefix: String) -> String {
        if hasPrefix(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    /// 确认字符串是否以某个串结束，如果不是则添加，如果是则不进行操作
    func ensureRight(suffix: String) -> String {
        if hasSuffix(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    /// 查找某个字串在字符串中的位置
    func indexOf(substring: String) -> Int? {
        if let range = range(of: substring) {
            return distance(from: startIndex, to: self[range].startIndex)
        }
        return nil
    }
    
    /// 取所有以空格为区分的单词的首字母
    /// 例如 "hello World to Every people" -> "hWtEp"
    func initials() -> String {
        let words = components(separatedBy: " ")
        return words.reduce(""){$0 + $1.prefix(1)}
    }
    
    /// 取以空格为区分的首单词和尾单词的首字母
    /// 例如："hello World to Every People" -> "hP"
    func initialsFirstAndLast() -> String {
        let words = components(separatedBy: " ")
        return words.reduce("") { String(($0 == "" ? "" : $0.prefix(1)) + $1.prefix(1))}
        //return words.reduce("") { ($0 == "" ? "" : $0[0...0]) + $1[0...0]}
    }
    
    /// 是否是纯字母
    var isAlpha: Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    /// 是否是纯字母+数字组合
    var isAlphaNumeric: Bool {
        let alphaNumeric = NSCharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").count == 0
    }
    
    /// 是否是空字符串
    var isEmpty: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count == 0
    }
    
    /// 是否是纯数字
    var isNumeric: Bool {
        if let _ = NumberFormatter.default.number(from: self) {
            return true
        }
        return false
    }
    
    /// 将 elements 中的字符串用当前字符串拼接起来
    /// 例如：",".join(elements: [1,2,3]) -> "1,2,3"
    ///     ",".join(elements: []) -> ""
    func join<S: Sequence>(elements: S) -> String {
        return elements.map { (ele) -> String in
            return (ele as? String) ?? ""
        }.joined(separator: self)
    }
    
    /// 获取字符串中的所有的行
    var lines: [String] {
        return components(separatedBy: NSCharacterSet.newlines)
    }
    
    /// 将当前字符串重复 n 此
    func times(_ n: Int) -> String {
        return String(repeating: self, count: n)
    }
    
    /// 给字符串左右添加 n 个 string
    func pad(_ n: Int, _ string: String = " ") -> String {
        return "".join(elements: [string.times(n), self, string.times(n)])
    }
    
    /// 给字符串左侧添加 n 个 string
    func padLeft(_ n: Int, _ string: String = " ") -> String {
        return "".join(elements: [string.times(n), self])
    }
    
    /// 给字符串右边添加 n 个 string
    func padRight(_ n: Int, _ string: String = " ") -> String {
        return "".join(elements: [self, string.times(n)])
    }
    
    /// 分割字符串
    func split(separator: Character) -> [String] {
        return split{$0 == separator}.map(String.init)
    }
    
    /// 去掉字符串中的标点符号
    func stripPunctuation() -> String {
        return components(separatedBy: .punctuationCharacters).joined(separator: "").components(separatedBy: " ").filter { element in
            return element != ""
        }.joined(separator: " ")
    }
    
    /// 移除字符串开始的时候的空格
    func trimmedLeft() -> String {
        
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted) {
            return String(self[self[range].startIndex..<endIndex])
        }
        return self
    }
    
    /// 移除字符串结束的时候的空格
    func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted, options: .backwards, range: nil) {
            return String(self[startIndex..<self[range].endIndex])
        }
        return self
    }
    
    /// 移除字符串开始和结束的时候的空格
    func trimmed() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    /// 获取某个区间内的子串
    /// 例如: "Hello World"[0..<2] = "He"
    subscript (range: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, range.lowerBound)), upper: min(count, max(0, range.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    /// 获取某个位置的子串
    /// 例如："Hello World"[3] -> "l"
    subscript(i: Int) -> Character {
        get {
            let index = index(startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    /// 将字符串按长度分割为子串
    /// 例如："Hello World".divide(3) -> ["Hel", "lo ", "Wor", "ld"]
    func divide(_ maxLength: Int) -> [String] {
        var texts = [String]()
        var longText = self
        while longText.count > maxLength {
            texts.append(longText[0..<maxLength])
            longText = longText[maxLength..<longText.count]
        }
        texts.append(longText)
        return texts
    }
    
    var sha256: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

