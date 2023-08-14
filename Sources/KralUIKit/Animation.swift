//
//  Animation.swift
//  
//
//  Created by LiKai on 2022/8/2.
//  
//

#if canImport(UIKit)

import Foundation
import UIKit

public class Animation {
    
    /// 快速使用全项目都将要用到的弹簧动画
    public static func bounce(withDuration duration: TimeInterval = 0.5, delay: TimeInterval = 0, usingSpringWithDamping dampingRatio: CGFloat = 0.65, initialSpringVelocity velocity: CGFloat = 0, options: UIView.AnimationOptions = .curveEaseInOut, animations: @escaping () -> (), completion: ((Bool) -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: dampingRatio,
                           initialSpringVelocity: velocity,
                           options: options,
                           animations: animations,
                           completion: completion)
        }
    }

    /// 快速使用全项目都将要用到的普通动画
    public static func animation(withDuration duration: TimeInterval = 0.3, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], animations: @escaping () -> (), completion: ((Bool) -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: options,
                           animations: animations,
                           completion: completion)
        }
    }
}

#endif
