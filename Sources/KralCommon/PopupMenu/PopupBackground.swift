//
//  PopupBackground.swift
//
//  Created by LiKai on 2022/7/29.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

/// 气泡的背景协议
public protocol PopupBackground {
    var arrowSize: CGSize { set get }
    func createBGView(_ frame: ShowPositionFrame) -> UIView
}

/// 绘制气泡背景，提供参数，通过贝塞尔曲线画出背景
public struct PopupBubbleBackground: PopupBackground {
    
    public var arrowSize: CGSize
    
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor = .white
    public var fillColor: UIColor = .lightGray
    public var shadowOpacity: Float = 0
    public var shadowRadius: CGFloat = 0
    public var shadowOffset: CGSize = .zero
    
    public func createBGView(_ frame: ShowPositionFrame) -> UIView {
        return BubbleCreator.createView(frame, cornerRadius: cornerRadius, lineWidth: borderWidth, lineColor: borderColor, fillColor: fillColor, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, shadowOffset: shadowOffset)
    }
    
    public static var `default`: PopupBackground {
        get {
            return PopupBubbleBackground(arrowSize: CGSize(width: 20, height: 10), cornerRadius: 15, fillColor: UIColor(hex: "#4C4C4C").alpha(0.85))
        }
    }
    
}

/// 图片背景，提供背景图片，箭头图片，背景图片将被拉伸，需要外部设定拉伸参数
public struct PopupImageBackground: PopupBackground {
        
    public var backgroundImage: UIImage?
    
    public var arrowImage: UIImage?
    
    public var arrowSize: CGSize
    
    public var arrowPadding: UIEdgeInsets = .zero
    
    public func createBGView(_ frame: ShowPositionFrame) -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: frame.wholeFrame.size))
        view.backgroundColor = .clear
        
        let contentImageView = UIImageView(image: backgroundImage)
        contentImageView.frame = frame.contentInFrame
        view.addSubview(contentImageView)
        
        var correctArrowImage = arrowImage
        switch frame.position {
        case .top:
            break
        case .bottom:
            correctArrowImage = arrowImage?.rotate(.down)
            break
        case .left:
            correctArrowImage = arrowImage?.rotate(.left)
            break
        case .right:
            correctArrowImage = arrowImage?.rotate(.right)
            break
        }
        
        let arrowImageView = UIImageView(image: correctArrowImage)
        arrowImageView.frame = frame.arrowInFrame
        view.addSubview(arrowImageView)
        
        return view
    }
}

#endif
