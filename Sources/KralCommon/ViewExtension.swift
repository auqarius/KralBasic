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
public func bounceAnimation(withDuration duration: TimeInterval = 0.5,
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
public func viewAnimation(withDuration duration: TimeInterval = 0.3,
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


public extension UIView {
    
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
          return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
    
}


// MARK: - Add Tap

private var kTappedIdentifier = "kTappedIdentifier"

extension UIView {
    
    public func addTap(tapcount: Int = 1, tappedBlock: @escaping () -> ()) {
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

// MARK: - Gradient 渐变 view

/*
 
 use:
 
 someView.addGradient(cornerRadius: radius,
                         direction: .leftToRight,
                            colors: [.init(hex: "2BFFC2"),
                                   .init(hex: "2BD2FF"),
                                   .init(hex: "FA8BFF")],
                          locations: [0, 0.2, 1],
                               rect: rect)
 
 */

import QuartzCore

public enum GradientDirection {
    case rightToLeft, leftToRight, topToBottom, bottomToTop
    
    func setGradienLayer(_ layer: CAGradientLayer) {
        switch self {
        case .rightToLeft:
            layer.startPoint = CGPoint(x: 1, y: 0.5)
            layer.endPoint = CGPoint(x: 0, y: 0.5)
            break
        case .leftToRight:
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            break
        case .topToBottom:
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
            break
        case .bottomToTop:
            layer.startPoint = CGPoint(x: 0.5, y: 1)
            layer.endPoint = CGPoint(x: 0.5, y: 0)
            break
        }
    }
}

fileprivate func defaultLocations(_ count: Int) -> [NSNumber] {
    var current: Double = 0
    var locations = [NSNumber(value: current)]
    let distance = 1.0/Double(count - 1)
    for _ in 0..<(count - 2) {
        current += distance
        locations.append(NSNumber(value: current))
    }
    
    locations.append(NSNumber(value: 1))
    
    return locations
}

public class GradientLayer: CAGradientLayer {}

extension UIView {
    
    private func existGradientLayer() -> GradientLayer? {
        for sublayer in (layer.sublayers ?? []) {
            if let g_layer = sublayer as? GradientLayer {
                return g_layer
            }
        }
        
        return nil
    }
    
    public func addGradient(cornerRadius: CGFloat, direction: GradientDirection = .leftToRight, colors: [UIColor], locations: [Double]? = nil, rect: CGRect? = nil) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var gradientLayer = existGradientLayer()
        if gradientLayer == nil {
            gradientLayer = GradientLayer()
            layer.insertSublayer(gradientLayer!, at: 0)
        }
        
        gradientLayer?.frame = rect ?? bounds
        gradientLayer?.cornerRadius = cornerRadius
        gradientLayer?.colors = colors.map{$0.cgColor}
        if let locations = locations {
            gradientLayer?.locations = locations.map{NSNumber(value: $0)}
        } else {
            gradientLayer?.locations = defaultLocations(colors.count)
        }
        direction.setGradienLayer(gradientLayer!)
        CATransaction.commit()
    }
}

#endif
