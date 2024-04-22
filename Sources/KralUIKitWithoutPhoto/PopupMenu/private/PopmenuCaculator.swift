//
//  PopmenuCaculator.swift
//
//  Created by LiKai on 2022/8/2.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

class PopupMenuCaculator {
    
    /// 根据最大显示行数和每行最大显示 item 个数计算 content 的最大值
    ///
    /// - Parameters:
    ///   - maxItemsOneRow: 每行的最大 item 数
    ///   - maxRows: 最大行数
    ///   - layout: collection 的 layout
    ///   - contentInset: collection 的 contentInset
    ///
    /// - Returns: 返回计算结果
    static func caculateMaxContentSize(maxItemsOneRow: Int = .max, maxRows: Int = .max, layout: UICollectionViewFlowLayout, contentInset: UIEdgeInsets) -> CGSize {
        let maxWidth = (layout.itemSize.width + layout.minimumInteritemSpacing)*CGFloat(maxItemsOneRow) + layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        let maxHeight = (layout.itemSize.height + layout.minimumLineSpacing)*CGFloat(maxRows) + layout.sectionInset.top + layout.sectionInset.bottom + contentInset.top + contentInset.bottom
        let maxContentSize = CGSize(width: maxWidth, height: maxHeight)
        
        return maxContentSize
    }
    
    /// 计算 collection 的显示大小
    /// 1. 确定 collection 的最大宽度
    /// 2. 根据最大宽度确定每行可以显示的 item 最大数量
    /// 3. 如果只有一行，则计算宽高并返回
    /// 4. 如果有多行，则计算单行满宽度 oneRowWidth，在 collection 最大宽度、oneRowWidth 之间选择最小值为宽度
    /// 5. 计算多行高度 height
    /// 6. 计算出来的宽度和高度必须小于 maxContetnSize。
    ///
    /// - Parameters:
    ///   - numberOfItems: item 的数量
    ///   - contentEdge: 气泡的上下左右边缘间隔值，用来确定最大显示值
    ///   - maxContentSize: 内容可以显示的最大值，与 contentEdge 进行联合计算比对，拿到可以显示的最大区域值
    ///   - layout: collection 的 layout
    ///   - contentInset: collection 的 contentInset
    /// - Returns: 返回计算的结果
    static func caculateCollectionSize(numberOfItems: Int, contentEdge: UIEdgeInsets, maxContentSize: CGSize, layout: UICollectionViewFlowLayout, contentInset: UIEdgeInsets) -> CGSize {
        let collectionMaxWidth = min(UIScreen.width - contentEdge.left - contentEdge.right, maxContentSize.width)
        let maxNumberOfItemsOneRow = maxNumberOfItemsOneRow(collectionMaxWidth: collectionMaxWidth, layout: layout, contentInset: contentInset)
        
        if maxNumberOfItemsOneRow == 0 {
            return maxContentSize
        }
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if numberOfItems < maxNumberOfItemsOneRow {
            width = (layout.itemSize.width + layout.minimumInteritemSpacing) * CGFloat(numberOfItems) - layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
            height = layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom + contentInset.top + contentInset.bottom
        } else {
            width = collectionMaxWidth
            
            let oneRowWidth = (layout.itemSize.width + layout.minimumInteritemSpacing) * CGFloat(maxNumberOfItemsOneRow) - layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
            width = min(width, oneRowWidth)
            
            var numberOfRows = numberOfItems/maxNumberOfItemsOneRow
            if numberOfItems%maxNumberOfItemsOneRow != 0 {
                numberOfRows += 1
            }
            height = (layout.itemSize.height + layout.minimumLineSpacing) * CGFloat(numberOfRows) - layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom + contentInset.top + contentInset.bottom
        }
        
        return CGSize(width: min(width, maxContentSize.width), height: min(height, maxContentSize.height))
    }
    
    /// 根据最大宽度确定每行可以显示的 item 最大数量
    /// 1. 计算出 item 可以显示的最大宽度
    /// 2. 如果 itemMaxWidth 比单个 itemSize.width 都小，将直接返回 1 个
    /// 3. 计算多个的宽度并与 itemMaxWidth 比较，超过了就返回
    ///
    /// - Parameters:
    ///   - collectionMaxWidth: collection 的最大宽度
    ///   - layout: collection 的 layout
    ///   - contentInset: collection 的 contentInset
    /// - Returns: 返回计算的结果
    static func maxNumberOfItemsOneRow(collectionMaxWidth: CGFloat, layout: UICollectionViewFlowLayout, contentInset: UIEdgeInsets) -> Int {
        
        let itemMaxWidth = collectionMaxWidth - (layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right) + layout.minimumInteritemSpacing
        
        if itemMaxWidth <= layout.itemSize.width {
            return 1
        }
        
        var n: CGFloat = 1
        var caculatedItemWidth: CGFloat = layout.itemSize.width
        while caculatedItemWidth < itemMaxWidth {
            n = n + 1
            caculatedItemWidth += (layout.itemSize.width + layout.minimumInteritemSpacing)
        }

        return Int(n - 1)
    }
}

#endif
