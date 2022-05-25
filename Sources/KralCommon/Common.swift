//
//  Common.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/18.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

/// MARK: - 获取某个类的字符串类名
public extension NSObject {
    static var string: String {
        get {
            return String(describing: self)
        }
    }
}

/// MARK: - 延迟执行
public class Delay {
    
    typealias Task = (_ cancel : Bool) -> Void

    static func delayTask(_ time: TimeInterval, task: @escaping ()->()) {
       let _ = delay(time, task: task)
    }

    static func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }

    static func cancel(_ task: Task?) {
        task?(true)
    }
}

/// MARK: - 手机震动反馈
public func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    DispatchQueue.main.async {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
}

#endif
