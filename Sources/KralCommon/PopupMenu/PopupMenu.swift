//
//  PopupMenu.swift
//
//  Created by LiKai on 2022/8/2.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

public struct PopupMenuItem {
    public var id: String = UUID().uuidString
    public var iconImage: UIImage?
    public var title: String = ""
    public var textFont: UIFont = .systemFont(ofSize: 11.0)
    public var textColor: UIColor = .black
    public var textAlignment: NSTextAlignment = .center
    public var iconTintColor: UIColor?
    
    public init(id: String = UUID().uuidString, iconImage: UIImage?, title: String, textFont: UIFont, textColor: UIColor, textAlignment: NSTextAlignment, iconTintColor: UIColor?) {
        self.id = id
        self.iconImage = iconImage
        self.title = title
        self.textFont = textFont
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.iconTintColor = iconTintColor
    }
}

public class PopupMenu {
    
    /// 展示一个标准的 menu 气泡，如果想要详细的自定义，可以使用其他方法
    ///
    /// - Parameters:
    ///   - items: menu 的 item
    ///   - maxItemsOneRow: 每行的最大数量，默认为 4
    ///   - maxRows: 最大行数，默认为 4
    ///   - background: 背景，默认为绘图绘制
    ///   - recommandPositions: 气泡优先展示位置，默认为自动选定
    ///   - sourceView: 指向 view
    ///   - vc: 展示基础 vc
    ///   - itemSelected: 用户点击选中
    public class func showStandard(items: [PopupMenuItem], maxItemsOneRow: Int = 4, maxRows: Int = 4, background: PopupBackground = PopupBubbleBackground.default, recommandPositions: [MenuPosition] = [], sourceView: UIView, from vc: UIViewController, itemSelected: @escaping (PopupMenuItem) -> ()) {
        
        show(items: items, background: background, recommandPositions: recommandPositions, sourceView: sourceView, maxItemsOneRow: maxItemsOneRow, maxRows: maxRows, from: vc) { layout in
            layout.minimumLineSpacing = 4
            layout.minimumInteritemSpacing = 4
            layout.itemSize = CGSize(width: 60, height: 60)
        } collectionViewSettle: { collectionView in
            collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 8, right: 4)
        } itemSelected: { item in
            itemSelected(item)
        }
    }
    
    /// 展示一个 menu 气泡
    /// - Parameters:
    ///   - items: menu 的 items
    ///   - background: 气泡背景
    ///   - recommandPositions: 气泡优先展示位置
    ///   - sourceView: 指向 view
    ///   - contentEdge: 气泡距离屏幕的边距
    ///   - maxItemsOneRow: 一行最大的显示 item 数
    ///   - maxRows: 最大行数
    ///   - ignoreSafeArea: 气泡离屏幕是否忽略 safeArea
    ///   - vc: 展示的基础 vc
    ///   - layoutSettle: collectionView 的 layout 配置
    ///   - collectionViewSettle: collectionView 的配置
    ///   - itemSelected: 用户点击选中
    public class func show(items: [PopupMenuItem], background: PopupBackground, recommandPositions: [MenuPosition] = [], sourceView: UIView, contentEdge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), maxItemsOneRow: Int = .max, maxRows: Int = .max, ignoreSafeArea: Bool = false, from vc: UIViewController, layoutSettle: ((UICollectionViewFlowLayout) -> ())? = nil, collectionViewSettle: ((UICollectionView) -> ())? = nil, itemSelected: @escaping (PopupMenuItem) -> ()) {
        if items.count <= 0 {
            return
        }
        let menuView = PopupMenuView()
        menuView.items = items
        if let layoutSettle = layoutSettle {
            layoutSettle(menuView.layout)
        }
        if let collectionViewSettle = collectionViewSettle {
            collectionViewSettle(menuView.collectionView)
        }
        
        let maxContentSize = PopupMenuCaculator.caculateMaxContentSize(maxItemsOneRow: maxItemsOneRow, maxRows: maxRows, layout: menuView.layout, contentInset: menuView.collectionView.contentInset)
        
        let collectionSize = PopupMenuCaculator.caculateCollectionSize(numberOfItems: items.count, contentEdge: contentEdge, maxContentSize: maxContentSize, layout: menuView.layout, contentInset: menuView.collectionView.contentInset)

        menuView.frame = CGRect(origin: .zero, size: collectionSize)
        
        let popupvc = PopupViewController()
        popupvc.recommandPositions = recommandPositions
        popupvc.pointAtView = sourceView
        popupvc.contentView = menuView
        popupvc.contentEdge = contentEdge
        popupvc.ignoreSafeArea = ignoreSafeArea
        popupvc.maxContentSize = maxContentSize
        popupvc.modalPresentationStyle = .overFullScreen
        vc.present(popupvc, animated: false)
        
        menuView.clickedItem = { item in
            itemSelected(item)
            popupvc.hide()
        }
    }
    
    /// 展示一个 menu 气泡
    /// - Parameters:
    ///   - items: menu 的 items
    ///   - background: 气泡背景
    ///   - recommandPositions: 气泡优先展示位置
    ///   - sourceView: 指向 view
    ///   - contentEdge: 气泡距离屏幕的边距
    ///   - maxContentSize: 最大行数
    ///   - ignoreSafeArea: 气泡离屏幕是否忽略 safeArea
    ///   - vc: 展示的基础 vc
    ///   - layoutSettle: collectionView 的 layout 配置
    ///   - collectionViewSettle: collectionView 的配置
    ///   - itemSelected: 用户点击选中
    public class func show(items: [PopupMenuItem], background: PopupBackground, recommandPositions: [MenuPosition] = [], sourceView: UIView, contentEdge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), maxContentSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), ignoreSafeArea: Bool = false, from vc: UIViewController, layoutSettle: ((UICollectionViewFlowLayout) -> ())? = nil, collectionViewSettle: ((UICollectionView) -> ())? = nil, itemSelected: @escaping (PopupMenuItem) -> ()) {
        if items.count <= 0 {
            return
        }
        let menuView = PopupMenuView()
        menuView.items = items
        if let layoutSettle = layoutSettle {
            layoutSettle(menuView.layout)
        }
        if let collectionViewSettle = collectionViewSettle {
            collectionViewSettle(menuView.collectionView)
        }
        
        let collectionSize = PopupMenuCaculator.caculateCollectionSize(numberOfItems: items.count, contentEdge: contentEdge, maxContentSize: maxContentSize, layout: menuView.layout, contentInset: menuView.collectionView.contentInset)

        menuView.frame = CGRect(origin: .zero, size: collectionSize)
        
        let popupvc = PopupViewController()
        popupvc.recommandPositions = recommandPositions
        popupvc.pointAtView = sourceView
        popupvc.contentView = menuView
        popupvc.contentEdge = contentEdge
        popupvc.ignoreSafeArea = ignoreSafeArea
        popupvc.maxContentSize = maxContentSize
        popupvc.background = background
        popupvc.modalPresentationStyle = .overFullScreen
        vc.present(popupvc, animated: false)
        
        menuView.clickedItem = { item in
            itemSelected(item)
            popupvc.hide()
        }
    }
    
}

#endif
