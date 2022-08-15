//
//  BezierPath.swift
//
//  Created by LiKai on 2022/7/28.
//  
//
#if canImport(UIKit)

/**
 
 贝塞尔曲线画图类
 
 用法：
 
 let bezierPath = BezierPath()

 bezierPath.addLine
 bezierPath.addRound
 bezierPath.addCurve
 ...
 
 let layer = bezierPath.createLayer
 
 */

import Foundation
import UIKit

public class BezierPath {
    
    /// 内部路线
    fileprivate var routes: [BezierPathRoute] = []
    
    /// 创建为 UIBezierPath
    public var toUIBezierPath: UIBezierPath {
        get {
            return routes.toUIBezierPath
        }
    }
    
    public init() {}
    
    /// 创建 Layer
    public func createLayer(frame: CGRect, lineWidth: CGFloat = 0, lineColor: UIColor = .white, fillColor: UIColor = .white, shadowOpacity: Float = 0, shadowRadius: CGFloat = 0, shadowOffset: CGSize = .zero) -> CAShapeLayer {
        return toUIBezierPath.createLayer(frame: frame,
                                          lineWidth: lineWidth,
                                          lineColor: lineColor,
                                          fillColor: fillColor,
                                          shadowOpacity: shadowOpacity,
                                          shadowRadius: shadowRadius,
                                          shadowOffset: shadowOffset)
    }
    
    /// 清除路线
    public func clear() {
        routes.removeAll()
    }
    
    /// 添加直线
    /// - Parameters:
    ///   - start: 开始点
    ///   - end: 结束点
    public func addLine(start: CGPoint, end: CGPoint) {
        routes.append(BezierPathRoute.line(start: start, end: end))
    }
    
    /// 添加圆、圆弧
    /// 角度在圆的位置右：0，下：pi/2, 左: pi, 上: -pi/2
    /// 
    /// - Parameters:
    ///   - center: 圆心
    ///   - radius: 半径
    ///   - startAngle: 开始角度
    ///   - endAngle: 结束角度
    public func addRound(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        routes.append(BezierPathRoute.round(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle))
    }
    
    /// 添加曲线
    /// - Parameters:
    ///   - start: 开始点
    ///   - end: 结束点
    ///   - controlPoint1: 控制点1
    ///   - controlPoint2: 控制点2
    public func addCurve(start: CGPoint, end: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        routes.append(BezierPathRoute.curve(start: start, end: end, controlPoint1: controlPoint1, controlPoint2: controlPoint2))
    }
    
}

/// 圆的上下左右的角度
public extension CGFloat {
    /// 圆的正上方的弧度
    static var roundTop: CGFloat {
        get {
            return  -pi/2
        }
    }
    
    /// 圆的正右方的弧度
    static var roundRight: CGFloat {
        get {
            return 0
        }
    }
    
    /// 圆的正左方的弧度
    static var roundLeft: CGFloat {
        get {
            return pi
        }
    }
    
    /// 圆的正下方的弧度
    static var roundBottom: CGFloat {
        get {
            return pi/2
        }
    }
}

fileprivate class BezierPathRoute {
    
    enum BezierPathType {
        // 直线
        case line
        // 圆
        case round
        // 贝塞尔曲线
        case curve
    }
    
    var type: BezierPathType = .line
    
    var startPoint: CGPoint = CGPoint.zero
    
    var endPoint: CGPoint = CGPoint.zero
    
    var centerPoint: CGPoint = CGPoint.zero
    
    var radius: CGFloat = 0
    
    var startAngle: CGFloat = 0
    
    var endAngle: CGFloat = 0
    
    var controlPoint1: CGPoint = CGPoint.zero
    
    var controlPoint2: CGPoint = CGPoint.zero
    
    static func line(start: CGPoint, end: CGPoint) -> BezierPathRoute {
        let path = BezierPathRoute()
        path.type = .line
        path.startPoint = start
        path.endPoint = end
        return path
    }
    
    static func round(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> BezierPathRoute {
        let path = BezierPathRoute()
        path.type = .round
        path.centerPoint = center
        path.radius = radius
        path.startAngle = startAngle
        path.endAngle = endAngle
        return path
    }
    
    static func curve(start: CGPoint, end: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) -> BezierPathRoute {
        let path = BezierPathRoute()
        path.type = .curve
        path.startPoint = start
        path.endPoint = end
        path.controlPoint1 = controlPoint1
        path.controlPoint2 = controlPoint2
        return path
    }
    
    
}

extension Array where Element == BezierPathRoute {
    fileprivate var toUIBezierPath: UIBezierPath {
        get {
            let bezierPath = UIBezierPath()
            
            var index = 0
            for path in self {
                if index == 0 {
                    bezierPath.move(to: path.startPoint)
                }
                path.addToPath(bezierPath)
                index += 1
            }
            
            return bezierPath
        }
    }
}

extension BezierPathRoute {
    fileprivate func addToPath(_ path: UIBezierPath) {
        switch type {
        case .line:
            addLineToPath(path)
            break
        case .round:
            addRoundToPath(path)
            break
        case .curve:
            addCurveToPath(path)
            break
        }
    }
    
    private func addLineToPath(_ path: UIBezierPath) {
        path.addLine(to: endPoint)
    }
    
    private func addRoundToPath(_ path: UIBezierPath) {
        path.addArc(withCenter: centerPoint,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
    }
    
    private func addCurveToPath(_ path: UIBezierPath) {
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
}

extension UIBezierPath {
    fileprivate func createLayer(frame: CGRect, lineWidth: CGFloat = 0, lineColor: UIColor = .white, fillColor: UIColor = .white, shadowOpacity: Float = 0, shadowRadius: CGFloat = 0, shadowOffset: CGSize = .zero) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.path = cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.shadowOpacity = shadowOpacity
        shapeLayer.shadowRadius = shadowRadius
        shapeLayer.shadowOffset = shadowOffset

        fill()
        close()
        stroke()
        
        return shapeLayer
    }
}

#endif
