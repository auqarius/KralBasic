//
//  Common.swift
//
//  Created by LiKai on 2022/5/18.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

/// MARK: - 获取某个类的字符串类名
extension NSObject {
    public static var string: String {
        get {
            return String(describing: self)
        }
    }
}

/// MARK: - 延迟执行
public class Delay {
    
    public typealias Task = (_ cancel : Bool) -> Void

    public static func delayTask(_ time: TimeInterval, task: @escaping ()->()) {
       let _ = delay(time, task: task)
    }

    public static func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
        
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

    public static func cancel(_ task: Task?) {
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

struct SeedRandomGenerator: RandomNumberGenerator {
    
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return UInt64(drand48() * 0x1.0p64) ^ UInt64(drand48() * 0x1.0p16)
    }
}

public extension Array {
    
    /// 用一个 seed 来随机排序数组，seed 一定的情况下，结果一定
    /// - Parameter seed: 大于 0 则会随机，如果小于等于 0 则不随机
    mutating func shuffle(with seed: Int) {
        guard seed > 0 else {
            return
        }
        var srg = SeedRandomGenerator(seed: seed)
        shuffle(using: &srg)
    }
    
    /// 用一个 seed 来随机排序数组，seed 一定的情况下，结果一定
    /// - Parameter seed: 大于 0 则会随机，如果小于等于 0 则不随机
    func shuffled(with seed: Int) -> Array {
        guard seed > 0 else {
            return self
        }
        var srg = SeedRandomGenerator(seed: seed)
        return shuffled(using: &srg)
    }
    
}


#endif
