//
//  PopupBubbleBackgroundDraw.swift
//
//  Created by LiKai on 2022/8/2.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

class BubbleCreator {
    
    static func createView(_ frame: ShowPositionFrame, cornerRadius: CGFloat, lineWidth: CGFloat, lineColor: UIColor, fillColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) -> UIView {
        let bezierPath = create(frame, cornerRadius: cornerRadius)
        let frame = CGRect(origin: .zero, size: frame.wholeFrame.size)
        let layer = bezierPath.createLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor, fillColor: fillColor, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, shadowOffset: shadowOffset)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.insertSublayer(layer, at: 0)
        return view
    }
    
}

extension BubbleCreator {
    
    fileprivate static func create(_ frame: ShowPositionFrame, cornerRadius: CGFloat = 6) -> BezierPath {
        switch frame.position {
        case .top:
            return createTop(frame, cornerRadius: cornerRadius)
        case .left:
            return createLeft(frame, cornerRadius: cornerRadius)
        case .right:
            return createRight(frame, cornerRadius: cornerRadius)
        case .bottom:
            return createBottom(frame, cornerRadius: cornerRadius)
        }
    }
    
    
    // 绘制气泡，顶部直线左边开始，瞬时转旋转一圈画
    
    /// 气泡在目标 view 顶上
    private static func createTop(_ frame: ShowPositionFrame, cornerRadius: CGFloat = 6) -> BezierPath {
        let bezierPath = BezierPath()

        bezierPath.addTopLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightTopCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addRightLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addBottomLineWithArrow(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftTopCorner(frame, cornerRadius: cornerRadius)
        
        return bezierPath
    }
    
    /// 气泡在目标 view 底部
    private static func createBottom(_ frame: ShowPositionFrame, cornerRadius: CGFloat = 6) -> BezierPath {
        let bezierPath = BezierPath()

        bezierPath.addTopLineWithArrow(frame, cornerRadius: cornerRadius)
        bezierPath.addRightTopCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addRightLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addBottomLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftTopCorner(frame, cornerRadius: cornerRadius)
        
        return bezierPath
    }
    
    /// 气泡在目标 view 左侧
    private static func createLeft(_ frame: ShowPositionFrame, cornerRadius: CGFloat = 6) -> BezierPath {
        let bezierPath = BezierPath()

        bezierPath.addTopLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightTopCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addRightLineWithArrow(frame, cornerRadius: cornerRadius)
        bezierPath.addRightBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addBottomLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftTopCorner(frame, cornerRadius: cornerRadius)
        
        return bezierPath
    }
    
    /// 气泡在目标 view 右侧
    private static func createRight(_ frame: ShowPositionFrame, cornerRadius: CGFloat = 6) -> BezierPath {
        let bezierPath = BezierPath()

        bezierPath.addTopLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightTopCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addRightLine(frame, cornerRadius: cornerRadius)
        bezierPath.addRightBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addBottomLine(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftBottomCorner(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftLineWithArrow(frame, cornerRadius: cornerRadius)
        bezierPath.addLeftTopCorner(frame, cornerRadius: cornerRadius)
        
        return bezierPath
    }
    
}

extension BezierPath {
    
    fileprivate func addTopLine(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addLine(start: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.minY),
                end: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.minY))
    }
    
    fileprivate func addTopLineWithArrow(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        let arrowFrame = frame.arrowInFrame
        
        // 顶部直线到箭头左侧
        addLine(start: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.minY),
                end: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY))
        
        // 顶部箭头
        addLine(start: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY),
                end: CGPoint(x: arrowFrame.midX, y: arrowFrame.minY))
        addLine(start: CGPoint(x: arrowFrame.midX, y: arrowFrame.minY),
                end: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY))
        
        // 顶部箭头左边到最左侧直线
        addLine(start: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY),
                end: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.minY))
    }
    
    fileprivate func addBottomLine(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addLine(start: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.maxY),
                end: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.maxY))
    }
    
    fileprivate func addBottomLineWithArrow(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        let arrowFrame = frame.arrowInFrame
        
        // 底部直线到箭头右侧
        addLine(start: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.maxY),
                end: CGPoint(x: arrowFrame.maxX, y: contentFrame.maxY))
        
        // 底部箭头
        addLine(start: CGPoint(x: arrowFrame.maxX, y: arrowFrame.minY),
                end: CGPoint(x: arrowFrame.midX, y: arrowFrame.maxY))
        addLine(start: CGPoint(x: arrowFrame.midX, y: arrowFrame.maxY),
                end: CGPoint(x: arrowFrame.minX, y: arrowFrame.minY))
        
        // 底部箭头左边到最左侧直线
        addLine(start: CGPoint(x: arrowFrame.minX, y: contentFrame.maxY),
                end: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.maxY))
    }
    
    
    fileprivate func addLeftLine(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addLine(start: CGPoint(x: contentFrame.minX, y: contentFrame.maxY - cornerRadius),
                end: CGPoint(x: contentFrame.minX, y: contentFrame.minY + cornerRadius))
    }
    
    fileprivate func addLeftLineWithArrow(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        let arrowFrame = frame.arrowInFrame
        
        // 左侧直线底部到箭头底部
        addLine(start: CGPoint(x: contentFrame.minX, y: contentFrame.maxY - cornerRadius),
                end: CGPoint(x: contentFrame.minX, y: arrowFrame.maxY))
        
        // 左侧箭头
        addLine(start: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY),
                end: CGPoint(x: arrowFrame.minX, y: arrowFrame.midY))
        addLine(start: CGPoint(x: arrowFrame.minX, y: arrowFrame.midY),
                end: CGPoint(x: arrowFrame.maxX, y: arrowFrame.minY))
        
        // 左侧箭头顶部到顶部
        addLine(start: CGPoint(x: arrowFrame.maxX, y: arrowFrame.minY),
                end: CGPoint(x: contentFrame.minX, y: contentFrame.minY + cornerRadius))
    }
    
    fileprivate func addRightLine(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addLine(start: CGPoint(x: contentFrame.maxX, y: contentFrame.minY + cornerRadius),
                end: CGPoint(x: contentFrame.maxX, y: contentFrame.maxY - cornerRadius))
    }
    
    fileprivate func addRightLineWithArrow(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        let arrowFrame = frame.arrowInFrame
        
        // 右侧直线顶部到箭头顶部
        addLine(start: CGPoint(x: contentFrame.maxX, y: contentFrame.minY + cornerRadius),
                end: CGPoint(x: contentFrame.maxX, y: arrowFrame.minY))
        
        // 右侧箭头
        addLine(start: CGPoint(x: arrowFrame.minX, y: arrowFrame.minY),
                end: CGPoint(x: arrowFrame.maxX, y: arrowFrame.midY))
        addLine(start: CGPoint(x: arrowFrame.maxX, y: arrowFrame.midY),
                end: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY))
        
        // 右侧箭头底部到底部
        addLine(start: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY),
                end: CGPoint(x: contentFrame.maxX, y: contentFrame.maxY - cornerRadius))
    }
    
    fileprivate func addLeftTopCorner(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addRound(center: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.minY + cornerRadius),
                 radius: cornerRadius,
                 startAngle: .roundLeft,
                 endAngle: .roundTop)
    }
    
    fileprivate func addRightTopCorner(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addRound(center: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.minY + cornerRadius),
                 radius: cornerRadius,
                 startAngle: .roundTop,
                 endAngle: .roundRight)
    }
    
    fileprivate func addLeftBottomCorner(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addRound(center: CGPoint(x: contentFrame.minX + cornerRadius, y: contentFrame.maxY - cornerRadius),
                 radius: cornerRadius,
                 startAngle: .roundBottom,
                 endAngle: .roundLeft)
    }
    
    fileprivate func addRightBottomCorner(_ frame: ShowPositionFrame, cornerRadius: CGFloat) {
        let contentFrame = frame.contentInFrame
        addRound(center: CGPoint(x: contentFrame.maxX - cornerRadius, y: contentFrame.maxY - cornerRadius),
                 radius: cornerRadius,
                 startAngle: .roundRight,
                 endAngle: .roundBottom)
    }
}

#endif
