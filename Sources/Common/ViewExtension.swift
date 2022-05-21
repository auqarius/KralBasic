//
//  ViewExtension.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/18.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit
import ObjectiveC.runtime

/// 快速使用全项目都将要用到的弹簧动画
func bounceAnimation(withDuration duration: TimeInterval = 0.5,
                     delay: TimeInterval = 0,
                     usingSpringWithDamping dampingRatio: CGFloat = 0.65,
                     initialSpringVelocity velocity: CGFloat = 0,
                     options: UIView.AnimationOptions = .curveEaseInOut,
                     animations: @escaping () -> Swift.Void,
                     completion: ((Bool) -> Swift.Void)? = nil) {
    DispatchQueue.main.async {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: velocity,
                       options: options,
                       animations: {
                        animations()
        }, completion: completion)
    }
}

/// 快速使用全项目都将要用到的普通动画
func viewAnimation(withDuration duration: TimeInterval = 0.3,
                   delay: TimeInterval = 0,
                   options: UIView.AnimationOptions = [],
                   animations: @escaping () -> Swift.Void,
                   completion: ((Bool) -> Swift.Void)? = nil) {
    DispatchQueue.main.async {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: {
            animations()
        },
                       completion: completion)
    }
}


extension UIView {
    
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
          return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
    
}


// MARK: - Add Tap

private var kTappedIdentifier = "kTappedIdentifier"

extension UIView {
    
    func addTap(tapcount: Int = 1, tappedBlock: @escaping () -> ()) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.tappedBlock = tappedBlock
        tap.numberOfTapsRequired = tapcount
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    fileprivate var tappedBlock: (() -> ())? {
        set {
            objc_setAssociatedObject(self, &kTappedIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kTappedIdentifier) as? () -> ())
        }
    }
    
    @objc fileprivate func tapped() {
        if let tappedBlock = tappedBlock {
            tappedBlock()
        }
    }
    
}

#endif
