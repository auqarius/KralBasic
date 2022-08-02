//
//  PopupViewController.swift
//
//  Created by LiKai on 2022/7/26.
//  
//
#if canImport(UIKit)

import UIKit

public class PopupViewController: UIViewController {
    
    /// 气泡指向的 view
    var pointAtView: UIView!
    
    /// 气泡的显示内容
    var contentView: UIView!
        
    /// 推荐的位置，外部可按顺序设定一个优先级，如通没有设定，则将自动选定最合适的
    var recommandPositions: [MenuPosition] = []
    
    /// 背景配置
    var background: PopupBackground = PopupBubbleBackground(arrowSize: CGSize(width: 20, height: 20))
    
    /// 气泡的边缘最小间隙值
    var contentEdge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// 内容的最大尺寸，这个尺寸是用来控制最大值的，并不代表一定要是这个值，会根据计算的结果来确定，如果计算结果超过这个值了，那就用这个值
    var maxContentSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    
    /// 是否忽略 safeArea 进行计算显示
    var ignoreSafeArea: Bool = false
    
    /// 气泡的父 view
    fileprivate let popupView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(popupView)
        popupView.frame = CGRect.zero
        
        let rect = pointAtView.convert(pointAtView.bounds, to: view)
        
        var arrowPadding = UIEdgeInsets.zero
        if let bubbleBG = background as? PopupBubbleBackground {
            arrowPadding = UIEdgeInsets(top: bubbleBG.cornerRadius, left: bubbleBG.cornerRadius, bottom: bubbleBG.cornerRadius, right: bubbleBG.cornerRadius)
        } else if let bubbleBg = background as? PopupImageBackground {
            arrowPadding = bubbleBg.arrowPadding
        }
        
        
        let contentFrame = PopupFrameCaculator.caculateFor(aimRect: rect,
                                                           recommandPositions: recommandPositions,
                                                           minEdge: contentEdge,
                                                           contentSize: contentView.frame.size,
                                                           maxContentSize: maxContentSize,
                                                           arrowSize: background.arrowSize,
                                                           arrowInContentPadding: arrowPadding,
                                                           ignoreSafeArea: ignoreSafeArea)
        
        popupView.insertSubview(background.createBGView(contentFrame), at: 0)
        popupView.alpha = 0
        popupView.layer.anchorPoint = contentFrame.anchorPoint
        popupView.frame = contentFrame.wholeFrame
        popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        contentView.frame = contentFrame.contentInFrame
        popupView.addSubview(contentView)
        
        view.addTap {
            self.hide()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewAnimation(withDuration: 0.2) {
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
    public func hide() {
        viewAnimation(withDuration: 0.2) {
            self.popupView.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { finish in
            self.dismiss(animated: false)
        }
    }
    
}

#endif
