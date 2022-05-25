//
//  ThreadSaveFormatter.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/20.
//  
//

import Foundation

/// 因为 formatter 的创建比较耗时，因此这里将第一次创建的 formatter 对象保存到线程中，使用的时候直接获取而不创建，提高效率
private enum ThreadLocalIdentifier {
    case DateFormatter(String)

    case DefaultNumberFormatter
    case LocaleNumberFormatter(Locale)

    var objcDictKey: String {
        switch self {
        case .DateFormatter(let format):
            return "SS\(self)\(format)"
        case .LocaleNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
    let storage = Thread.current.threadDictionary
    let k = identifier.objcDictKey

    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }

    return instance
}

public extension DateFormatter {
    static func `default`(_ format: String) -> DateFormatter {
        return threadLocalInstance(identifier: .DateFormatter(format), initialValue: {
            let df = DateFormatter()
            df.dateFormat = format
            return df
        }())
    }
}


public extension NumberFormatter {
    
    static var `default`: NumberFormatter {
        get {
            return threadLocalInstance(identifier: .DefaultNumberFormatter, initialValue: NumberFormatter())
        }
    }
    
    static func localDefault(_ locale: Locale = .current) -> NumberFormatter {
        return threadLocalInstance(identifier: .LocaleNumberFormatter(locale), initialValue: {
            let nf = NumberFormatter()
            nf.locale = locale
            return nf
        }())
    }
    
}

