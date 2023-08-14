//
//  PopupFrameCaculator.swift
//
//  Created by LiKai on 2022/7/26.
//  
//
#if canImport(UIKit)

import UIKit

/// Menu 显示的位置
public enum MenuPosition {
    case left, right, top, bottom
}

/// 显示的 position 和 frame
public struct ShowPositionFrame {
    public var position: MenuPosition
    public var contentFrame: CGRect
    public var arrowFrame: CGRect
    
    // 箭头指向的点
    public var pointAtPoint: CGPoint {
        get {
            switch position {
            case .left:
                return CGPoint(x: arrowFrame.maxX, y: arrowFrame.midY)
            case .right:
                return CGPoint(x: arrowFrame.minX, y: arrowFrame.midY)
            case .top:
                return CGPoint(x: arrowFrame.midX, y: arrowFrame.maxY)
            case .bottom:
                return CGPoint(x: arrowFrame.midX, y: arrowFrame.minY)
            }
        }
    }
    
    // 放大缩小的锚点
    // 是按照比例来说的，从 0 - 1
    public var anchorPoint: CGPoint {
        get {
            switch position {
            case .left:
                return CGPoint(x: 1, y: arrowInFrame.midY/wholeFrame.height)
            case .right:
                return CGPoint(x: 0, y: arrowInFrame.midY/wholeFrame.height)
            case .top:
                return CGPoint(x: arrowInFrame.midX/wholeFrame.width, y: 1)
            case .bottom:
                return CGPoint(x: arrowInFrame.midX/wholeFrame.width, y: 0)
            }
        }
    }
    
    // 内容在气泡里面的相对位置和大小
    public var contentInFrame: CGRect {
        get {
            return CGRect(x: contentFrame.minX - wholeFrame.minX,
                          y: contentFrame.minY - wholeFrame.minY,
                          width: contentFrame.width,
                          height: contentFrame.height)
        }
    }
    
    // 箭头在气泡里面的相对位置和大小
    public var arrowInFrame: CGRect {
        get {
            return CGRect(x: arrowFrame.minX - wholeFrame.minX,
                          y: arrowFrame.minY - wholeFrame.minY,
                          width: arrowFrame.width,
                          height: arrowFrame.height)
        }
    }
    
    // 整个气泡的位置和大小
    public var wholeFrame: CGRect {
        get {
            var x: CGFloat = contentFrame.minX
            var y: CGFloat = contentFrame.minY
            var width: CGFloat = contentFrame.width
            var height: CGFloat = contentFrame.height
            
            switch position {
            case .left:
                width += arrowFrame.width
                break
            case .right:
                x = arrowFrame.minX
                width += arrowFrame.width
                break
            case .top:
                height += arrowFrame.height
                break
            case .bottom:
                y = arrowFrame.minY
                height += arrowFrame.height
                break
            }
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    public init(position: MenuPosition, contentFrame: CGRect, arrowFrame: CGRect) {
        self.position = position
        self.contentFrame = contentFrame
        self.arrowFrame = arrowFrame
    }
}

/// 上下左右的 position 和 frame
fileprivate struct ShowPositionFrameGroup {
    var top: ShowPositionFrame?
    var left: ShowPositionFrame?
    var bottom: ShowPositionFrame?
    var right: ShowPositionFrame?
    
    var canShowCount: Int {
        get {
            var num = 0
            if top != nil {
                num += 1
            }
            if left != nil {
                num += 1
            }
            if right != nil {
                num += 1
            }
            if bottom != nil {
                num += 1
            }
            return num
        }
    }
    
    var theOne: ShowPositionFrame? {
        get {
            if canShowCount > 1 {
                return nil
            }
            if let top = top {
                return top
            }
            if let left = left {
                return left
            }
            if let right = right {
                return right
            }
            if let bottom = bottom {
                return bottom
            }
            return nil
        }
    }
}

/// 弹出气泡的位置计算器，位置的坐标系为 window
public class PopupFrameCaculator {
    
    /// 气泡指定向的 Rect
    fileprivate var aimRect: CGRect = .zero
    
    /// 气泡的优先显示位置，会按照数组中指定的顺序来看是否可以显示
    /// 默认为空，代表自动查找最合适位置
    fileprivate var menuRecommandPositions: [MenuPosition] = []
    
    /// 气泡距离屏幕上下左右的最小间距，顶部和底部是基于 safeArea 的间距
    fileprivate var contentViewMinEdge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    /// 内容的最大尺寸，这个尺寸是用来控制最大值的，并不代表一定要是这个值，会根据计算的结果来确定，如果计算结果超过这个值了，那就用这个值
    fileprivate var maxContentSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    
    /// 箭头的大小，这里指的是箭头向下的时候的大小，真正计算的时候会根据 position 自动转换对应的尺寸
    fileprivate var arrowSize: CGSize = CGSize(width: 20, height: 15)
    
    /// 箭头相对 content 的 padding，主要是如果 content 有 cornerRadius，则是需要给圆角留一部分空间的，箭头将不会达到圆角区域
    fileprivate var arrowInContentPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 内容的大小，内容会直接放在气泡内，不包括箭头
    fileprivate var contentSize: CGSize = CGSize.zero
    
    /// 是否在计算可显示区域的时候忽略掉 safeArea
    fileprivate var ignoreSafeArea: Bool = false
    
    /// 整体可显示区域的大小
    fileprivate var canShowRect: CGRect {
        get {
            let safeAreaTop = ignoreSafeArea ? 0 : UIScreen.main.statusBarHeight
            let safeAreaBottom = ignoreSafeArea ? 0 : UIScreen.main.safeAreaBottomHeight
            let canShowRect = CGRect(x: contentViewMinEdge.left,
                                     y: contentViewMinEdge.top + safeAreaTop,
                                     width: UIScreen.width - contentViewMinEdge.left - contentViewMinEdge.right,
                                     height: UIScreen.height - contentViewMinEdge.top - contentViewMinEdge.bottom - safeAreaTop - safeAreaBottom)
            return canShowRect
        }
    }
    
    /// 计算位置
    /// 计算原则：
    ///     1. 如果 menuRecommandPositions 不为空，则依次计算出指定 position 下可以刚好显示 contentSize 且不出显示区域的 frame。
    ///         1.1 frame 存在，则根据优先级确定 frame 与 position。
    ///         1.2 frame 不存在，进入自动选定逻辑。
    ///     2. 如果 menuRecommandPositions 为空，进入自动选定逻辑。
    ///     3. 自动选定逻辑，计算出所有 position 下可以刚好显示 contentSize 且不出屏幕的 frame。
    ///         3.1 如果 frame 不存在，说明都显示不下，则计算出所有 position 的可显示区域 frame，并找到最合适的 frame。
    ///             3.1.1 寻找是否有最合适的 frame，先查找满足 width/height > contentSize.width/contentSize.height 的 frame，这样可以保证仅在一个方向上滑动。
    ///             3.1.2 如果 3.1.1 结果存在则直接返回，并根据优先显示原则确定。
    ///             3.1.3 如果 3.1.1 结果不存在，则找到 frame.width*frame.height 最大的 position 和 frame.
    ///             3.1.4 为了让显示效果更好，在 3.1.3 的结果中，查找宽高差值最小的一个 frame 返回。如果差值都一样，则就都返回，并根据优先显示原则确定。
    ///         3.2 如果 frame 存在且唯一，则确定 frame 与 position。
    ///             3.2.1 如果 frame 不唯一，取箭头中心最小偏移值进行确定。
    ///                 3.2.1.1 箭头中心最小偏移值：position = top/bottom 取 |arrowFrame.centerX - frame.centerX|
    ///                 3.2.1.2 position = left/right 取 |arrowFrame.centerY - frame.centerY|
    ///             3.1.1 如果最小值的 position 唯一，则 frame 与 position 确定。
    ///             3.1.2 如果最小值的 position 不唯一，则根据优先显示原则进行 position 选定。
    ///     4. 优先显示原则，根据 position 优先级进行选定，优先级为：top, bottom, left/right.
    ///         4.1 left/right 的选择原则是看哪边剩余空间大
    ///             4.1.1 aimRect.minX <= screenWidth - aimRect.maxX: right
    ///             4.1.2 aimRect.minX > screenWidth - aimRect.maxX: left
    fileprivate func caculateFrame() -> ShowPositionFrame {
        if let positionFrame = recommandPositionFrame() {
            return positionFrame
        }
        
        return autoPositionFrameSet()
    }
    
    /// 根据 menuRecommandPositions 查找是否有对应的可显示位置与区域
    private func recommandPositionFrame() -> ShowPositionFrame? {
        for position in menuRecommandPositions {
            if let positionFrame = caculateFitFrameFor(position: position) {
                return positionFrame
            }
        }
        
        return nil
    }
    
    /// 自动选定逻辑
    private func autoPositionFrameSet() -> ShowPositionFrame {
        // 1. 找到所有合适的 frame
        var showPositionFrameGroup = allPositionFitFrame()
        
        // 2. 如果没有合适的，则找到最大的合适的 frame
        if showPositionFrameGroup.canShowCount == 0 {
            showPositionFrameGroup = findMostFitMaxFrame()
        }
        
        // 3. 如果唯一了，则返回指定的位置和 frame
        if let theOne = showPositionFrameGroup.theOne {
            return theOne
        }
        
        // 4. 如果不唯一，则先根据箭头中心最小偏移值
        showPositionFrameGroup = findArrowCenterMinDiffIn(showPositionFrameGroup)
        
        // 5. 如果唯一了，则返回指定的位置和 frame
        if let theOne = showPositionFrameGroup.theOne {
            return theOne
        }
        
        // 6. 如果不唯一，则根据优先显示原则进行显示
        return findPositionByPriority(showPositionFrameGroup)
    }
    
}

// MARK: - Fit Frame Caculate
extension PopupFrameCaculator {
    
    
    /// 获取所有位置可以显示下的 frame
    fileprivate func allPositionFitFrame() -> ShowPositionFrameGroup {
        return ShowPositionFrameGroup(top: caculateFitFrameFor(position: .top),
                                      left: caculateFitFrameFor(position: .left),
                                      bottom: caculateFitFrameFor(position: .bottom),
                                      right: caculateFitFrameFor(position: .right))
    }
    
    /// 计算某个位置的最合适 frame
    /// - Parameters:
    ///   - position: 位置
    ///   - allowBeyond: 是否允许超出，如果允许超出，将会在超出维度上选定最大值，则必有结果。否则如果没有完美的合适位置大小就会返回空。
    /// - Returns: 计算好的可以放得下的位置
    fileprivate func caculateFitFrameFor(position: MenuPosition, allowBeyond: Bool = false) -> ShowPositionFrame? {
        
        // 如果不允许超出，而且也没有合适的位置，则直接返回空
        if !allowBeyond && !contentCanFitFor(position: position) {
            return nil
        }
        
        var contentX: CGFloat = 0
        var contentY: CGFloat = 0
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        var arrowX: CGFloat = 0
        var arrowY: CGFloat = 0
        var arrowWidth: CGFloat = 0
        var arrowHeight: CGFloat = 0
        
        // 1. 横向计算
        // 配置 arrow 的宽和高，因为 arrowSize 是 top 情况下的尺寸，而 left/right 需要宽高互换
        let caculateHorizontalArrowSize: () -> () = {
            arrowWidth = self.arrowSize.height
            arrowHeight = self.arrowSize.width
        }
        
        //  根据可显示的最大值来判定结果的最终值
        //  然后根据 contentHeight 计算出来 contentY
        //  计算上一步的 contentY 是否会导致内容的底部和顶部超过显示区域
        //  如果超过了，则移动 contentY 刚好贴住底部和顶部
        //  这里不需要考虑移动后是否能显示完整，这个方法第一步已经确定了肯定可以放得下
        let caculateHorizontalContentFrame: (CGFloat, CGFloat) -> () = { maxWidth, maxHeight in
            contentWidth = min(maxWidth, self.contentSize.width, self.maxContentSize.width)
            contentHeight = min(maxHeight, self.contentSize.height, self.maxContentSize.height)
            
            contentY = self.aimRect.midY - contentHeight/2
            let overHeight = self.aimRect.midY + contentHeight/2 - self.canShowRect.maxY
            if overHeight > 0 {
                contentY = contentY - overHeight
            } else if contentY < self.canShowRect.minY {
                contentY = self.canShowRect.minY
            }
        }
        
        // 计算箭头的 Y 值，箭头的位置必须在 contentFrame 之内
        let caculateHorizontalArrowY: () -> () = {
            arrowY = self.aimRect.midY - arrowHeight/2
            
            arrowY = max(arrowY, contentY + self.arrowInContentPadding.top)
            arrowY = min(arrowY, contentY + contentHeight - self.arrowInContentPadding.bottom)
        }
        
        // 2. 纵向计算
        // 配置 arrow 的宽和高，因为 arrowSize 是 top 情况下的尺寸，因此刚好匹配
        let caculateVerticalArrowSize: () -> () = {
            arrowWidth = self.arrowSize.width
            arrowHeight = self.arrowSize.height
        }
        
        // 根据可显示的最大值来判定 contentWidth contentHeight 的最终值
        // 根据 contentWidth 计算出 contentX
        // 计算上一步的 contentX 是否会导致内容的左侧和右侧超过显示区域
        // 如果超过了，则移动 contentX 刚好贴住左侧和右侧
        // 这里不需要考虑移动后是否能显示完整，这个方法第一步已经确定了肯定可以放得下
        
        let caculateVerticalContentFrame: (CGFloat, CGFloat) -> () = { maxWidth, maxHeight in
            contentWidth = min(maxWidth, self.contentSize.width, self.maxContentSize.width)
            contentHeight = min(maxHeight, self.contentSize.height, self.maxContentSize.height)
            
            contentX = self.aimRect.midX - contentWidth/2
            let overWidth = self.aimRect.midX + contentWidth/2 - self.canShowRect.maxX
            if overWidth > 0 {
                contentX = contentX - overWidth
            } else if contentX < self.canShowRect.minX {
                contentX = self.canShowRect.minX
            }
        }
        
        // 计算箭头的 X 值，箭头的位置必须在 contentFrame 之内
        let caculateVerticalArrowX: () -> () = {
            arrowX = self.aimRect.midX - arrowWidth/2
            
            arrowX = max(arrowX, contentX + self.arrowInContentPadding.left)
            arrowX = min(arrowX, contentX + contentWidth - self.arrowInContentPadding.right)
        }
        
        // 计算各个方向的 x y 的值
        switch position {
        case .left:
            caculateHorizontalArrowSize()
            arrowX = aimRect.minX - arrowWidth
            
            let maxWidth = arrowX - canShowRect.minX
            let maxHeight = canShowRect.height
            
            caculateHorizontalContentFrame(maxWidth, maxHeight)
            contentX = arrowX - contentWidth
            
            caculateHorizontalArrowY()
            
            break
        case .right:
            caculateHorizontalArrowSize()
            arrowX = self.aimRect.maxX
            
            let maxWidth = canShowRect.maxX - arrowX - arrowWidth
            let maxHeight = canShowRect.height
            
            caculateHorizontalContentFrame(maxWidth, maxHeight)
            contentX = arrowX + arrowWidth
            
            caculateHorizontalArrowY()
            break
        case .top:
            caculateVerticalArrowSize()
            arrowY = self.aimRect.minY - arrowHeight
            
            let maxWidth = canShowRect.width
            let maxHeight = arrowY - canShowRect.minY

            caculateVerticalContentFrame(maxWidth, maxHeight)
            contentY = arrowY - contentHeight
            
            caculateVerticalArrowX()
            break
        case .bottom:
            caculateVerticalArrowSize()
            arrowY = self.aimRect.maxY
            
            let maxWidth = canShowRect.width
            let maxHeight = canShowRect.maxY - arrowY - arrowHeight

            caculateVerticalContentFrame(maxWidth, maxHeight)
            contentY = self.aimRect.maxY + arrowHeight
            
            caculateVerticalArrowX()
            break
        }
        
        let arrowFrame = CGRect(x: arrowX, y: arrowY, width: arrowWidth, height: arrowHeight)
        let contentFrame = CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight)
        return ShowPositionFrame(position: position, contentFrame: contentFrame, arrowFrame: arrowFrame)
    }
    
    /// 某个位置是否可以显示的下
    private func contentCanFitFor(position: MenuPosition) -> Bool {
        
        // 1. 显示内容比可显示内容的 width/height 大，就是显示不下
        if contentSize.height > canShowRect.height ||
            contentSize.width > canShowRect.width {
            return false
        }
        
        // 2. 横向纵向检测: （箭头在 left right 是横向的，所以其实还是用 arrowSize.height 来计算）
        //      2.1 气泡如果纵向（top/bottom）则检测气泡高度+箭头高度+aimRect高度 <= 可显示内容高度
        //      2.2 气泡如果横向（left/right）则检测气泡宽度+箭头高度+aimRect宽度 <= 可显示内容宽度
        let isVertical = (position == .top || position == .bottom)
        let verticalHeightCanFit = aimRect.height + contentSize.height + arrowSize.height <= canShowRect.height
        let horizontalWidthCanFit = aimRect.width + contentSize.width + arrowSize.height <= canShowRect.width

        if isVertical && !verticalHeightCanFit {
            return false
        }
        if !isVertical && !horizontalWidthCanFit {
            return false
        }
        
        // 3. 每个位置的剩余空间检测（箭头在 left right 是横向的，所以其实还是用 arrowSize.height 来计算）
        //      3.1 left: 检测 aimRect 的左侧是否可以放得下内容宽度+箭头高度
        //      3.2 right: 检测 aimRect 的右侧是否可以放得下内容宽度+箭头高度
        //      3.3 top: 检测 aimRect 的上方是否可以放得下内容高度+箭头高度
        //      3.4 bottom: 检测 aimRect 的下方是否可以放得下内容高度+箭头高度
        switch position {
        case .left:
            return aimRect.minX - arrowSize.height - contentSize.width >= canShowRect.minX
        case .right:
            return aimRect.maxX + arrowSize.height + contentSize.width <= canShowRect.maxX
        case .top:
            return aimRect.minY - arrowSize.height - contentSize.height >= canShowRect.minY
        case .bottom:
            return aimRect.maxY + arrowSize.height + contentSize.height <= canShowRect.maxY
        }
    }
    
}


// MARK: - Max Fit Frame Caculate
extension PopupFrameCaculator {
    
    /// 在最大显示 frame 中找出最合适的
    ///     1. 寻找是否有最合适的 frame，先查找满足 width/height > contentSize.width/contentSize.height 的 frame，这样可以保证仅在一个方向上滑动。
    ///     2. 如果第 1 步结果存在则直接返回，如果第 1 步结果不存在，则找到 frame.width*frame.height 最大的 position 和 frame.
    ///     3. 为了让显示效果更好，在第 2 步的结果中，查找宽高差值最小的一个 frame 返回。如果差值都一样，则就都返回。
    fileprivate func findMostFitMaxFrame() -> ShowPositionFrameGroup {
        // 1. 找到上下左右所有的最大区域 Frame
        let allPositionMaxFrame = allPositionMaxFrame()
        
        // 2. 寻找仅能在一个维度上滚动的 frame
        var fitPositionFrameGroup = caculateOnlyBeyondOneDigreeFrame(allPositionMaxFrame)
        
        // 3. 如果只有一个，则直接返回
        if fitPositionFrameGroup.canShowCount == 1 {
            return fitPositionFrameGroup
        }
        
        // 4. 如果没有仅能在一个维度上滚动的 frame，则用回前面所有的 frame 进行后面的计算
        if fitPositionFrameGroup.canShowCount == 0 {
            fitPositionFrameGroup = allPositionMaxFrame
        }
        
        // 5. 找到最合适的 frame 并返回
        return caculateFitnessPositionFrame(fitPositionFrameGroup)
    }
    
    /// 计算并返回只有一个维度超过最大值的 frame，保证仅在一个维度滚动
    private func caculateOnlyBeyondOneDigreeFrame(_ frameGroup: ShowPositionFrameGroup) -> ShowPositionFrameGroup {
        
        var fitPositionFrameGroup = ShowPositionFrameGroup()

        let isMaxPositionFrameFit: (ShowPositionFrame?) -> (ShowPositionFrame?) = { positionFrame in
            guard let maxFrame = positionFrame?.contentFrame else {
                return nil
            }
            if maxFrame.width >= self.contentSize.width ||
                maxFrame.height >= self.contentSize.height {
                return positionFrame
            }
            return nil
        }
        
        
        fitPositionFrameGroup.left = isMaxPositionFrameFit(frameGroup.left)
        fitPositionFrameGroup.top = isMaxPositionFrameFit(frameGroup.top)
        fitPositionFrameGroup.bottom = isMaxPositionFrameFit(frameGroup.bottom)
        fitPositionFrameGroup.right = isMaxPositionFrameFit(frameGroup.right)
        
        return fitPositionFrameGroup;
    }
    
    /// 计算最合适的位置
    ///     1. 计算面积，对比，找到面积最大的。
    ///     2. 如果有多个面积最大的，计算宽高差值最小的。
    ///
    private func caculateFitnessPositionFrame(_ frameGroup: ShowPositionFrameGroup) -> ShowPositionFrameGroup {
        
        var fitPositionFrameGroup = ShowPositionFrameGroup()
        
        // 1. 计算面积最大的区域
        let caculateContentArea: (ShowPositionFrame?) -> (CGFloat) = { positionFrame in
            guard let maxFrame = positionFrame?.contentFrame else {
                return 0
            }
            
            return maxFrame.width * maxFrame.height
        }
        
        // 2. 上下左右计算一番
        let leftArea = caculateContentArea(frameGroup.left)
        let rightArea = caculateContentArea(frameGroup.right)
        let topArea = caculateContentArea(frameGroup.top)
        let bottomArea = caculateContentArea(frameGroup.bottom)
        
        // 3. 找到最大的面积值
        let maxArea = max(leftArea, rightArea, topArea, bottomArea)
        
        // 4. 上下左右对比一番，面积一样的都放进来
        if leftArea == maxArea {
            fitPositionFrameGroup.left = frameGroup.left
        }
        if rightArea == maxArea {
            fitPositionFrameGroup.right = frameGroup.right
        }
        if topArea == maxArea {
            fitPositionFrameGroup.top = frameGroup.top
        }
        if bottomArea == maxArea {
            fitPositionFrameGroup.bottom = frameGroup.bottom
        }
        
        // 5. 如果仅有一个了，则直接返回（不可能没有，肯定有最大值）
        if fitPositionFrameGroup.canShowCount == 1 {
            return fitPositionFrameGroup;
        }
        
        // 6. 计算宽高差值
        let caculateContentWHDiff: (ShowPositionFrame?) -> (CGFloat) = { positionFrame in
            guard let maxFrame = positionFrame?.contentFrame else {
                return .greatestFiniteMagnitude
            }
            
            return abs(maxFrame.width - maxFrame.height)
        }
        
        // 7. 上下左右计算一下
        let leftWHDiff = caculateContentWHDiff(fitPositionFrameGroup.left)
        let rightWHDiff = caculateContentWHDiff(fitPositionFrameGroup.right)
        let topWHDiff = caculateContentWHDiff(fitPositionFrameGroup.top)
        let bottomWHDiff = caculateContentWHDiff(fitPositionFrameGroup.bottom)
        
        // 8. 获取最小差值
        let minWHDiff = min(leftWHDiff, rightWHDiff, topWHDiff, bottomWHDiff)
        
        // 9. 上下左右对比一番，差值不是最小的直接设置为 nil
        if leftWHDiff != minWHDiff {
            fitPositionFrameGroup.left = nil
        }
        if rightWHDiff != minWHDiff {
            fitPositionFrameGroup.right = nil
        }
        if topWHDiff != minWHDiff {
            fitPositionFrameGroup.top = nil
        }
        if bottomWHDiff != minWHDiff {
            fitPositionFrameGroup.bottom = nil
        }
        
        return fitPositionFrameGroup;
    }
    
    /// 获取所有位置下最大的显示 frame
    private func allPositionMaxFrame() -> ShowPositionFrameGroup {
        return ShowPositionFrameGroup(top: caculateFitFrameFor(position: .top, allowBeyond: true),
                                      left: caculateFitFrameFor(position: .left, allowBeyond: true),
                                      bottom: caculateFitFrameFor(position: .bottom, allowBeyond: true),
                                      right: caculateFitFrameFor(position: .right, allowBeyond: true))
    }
    
}

// MARK: - Arrow Content Center Diff Caculate
extension PopupFrameCaculator {
    
    /// 根据箭头中心最小偏移值找出对应的 position frame
    fileprivate func findArrowCenterMinDiffIn(_ positionFrameGroup: ShowPositionFrameGroup) -> ShowPositionFrameGroup {
        
        var result = ShowPositionFrameGroup()
        
        let leftDiff = caculateArrowCenterDiff(positionFrameGroup.left)
        let rightDiff = caculateArrowCenterDiff(positionFrameGroup.right)
        let topDiff = caculateArrowCenterDiff(positionFrameGroup.top)
        let bottomDiff = caculateArrowCenterDiff(positionFrameGroup.bottom)
        
        let minDiff = min(leftDiff, rightDiff, topDiff, bottomDiff)
        
        if leftDiff == minDiff {
            result.left = positionFrameGroup.left
        }
        if rightDiff != minDiff {
            result.right = positionFrameGroup.right
        }
        if topDiff != minDiff {
            result.top = positionFrameGroup.top
        }
        if bottomDiff != minDiff {
            result.bottom = positionFrameGroup.bottom
        }
        
        return positionFrameGroup
    }
    
    /// 计算箭头和气泡的中心差值
    private func caculateArrowCenterDiff(_ positionFrame: ShowPositionFrame?) -> CGFloat {
        guard let positionFrame = positionFrame else {
            return .greatestFiniteMagnitude
        }

        if positionFrame.position == .left ||
            positionFrame.position == .right {
            return abs(positionFrame.contentFrame.midY - positionFrame.arrowFrame.midY)
        }
        if positionFrame.position == .top ||
            positionFrame.position == .bottom {
            return abs(positionFrame.contentFrame.midX - positionFrame.arrowFrame.midX)
        }
        
        return .greatestFiniteMagnitude
    }
    
}

// MARK: - Priority Position Frame Caculate
extension PopupFrameCaculator {
    
    /// 根据优先显示原则找到要显示的 position frame
    /// - Parameter positionFrames: 待查找列表，至少有两个内容
    /// - Returns: 找到的 position frame
    fileprivate func findPositionByPriority(_ positionFrameGroup: ShowPositionFrameGroup) -> ShowPositionFrame {
        
        // 0. 只有一个就可以直接返回了
        if let theOne = positionFrameGroup.theOne {
            return theOne
        }
        
        // 1. 根据 top bottom 的优先级先查找 frame
        if let top = positionFrameGroup.top {
            return top
        } else if let bottom = positionFrameGroup.bottom {
            return bottom
        }
        
        // 2. 走到这里，说明 positionFrameGroup 里 left 和 right 都有值。判定 left right 的显示，原则为看 aimRect 哪边剩余空间大。
        let leftSpace = aimRect.minX
        let rightSpace = UIScreen.width - aimRect.maxX
        if leftSpace <= rightSpace {
            return positionFrameGroup.right!
        } else {
            return positionFrameGroup.left!
        }
    }
    
}


public extension PopupFrameCaculator {
    
    static func caculateFor(aimRect: CGRect,
                            recommandPositions: [MenuPosition] = [],
                            minEdge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                            contentSize: CGSize,
                            maxContentSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                            arrowSize: CGSize,
                            arrowInContentPadding: UIEdgeInsets = UIEdgeInsets.zero,
                            ignoreSafeArea: Bool = false) -> ShowPositionFrame {
        let caculator = PopupFrameCaculator()
        caculator.aimRect = aimRect
        caculator.maxContentSize = maxContentSize
        caculator.menuRecommandPositions = recommandPositions
        caculator.arrowInContentPadding = arrowInContentPadding
        caculator.ignoreSafeArea = ignoreSafeArea
        caculator.contentViewMinEdge = minEdge
        caculator.arrowSize = arrowSize
        caculator.contentSize = contentSize
        
        return caculator.caculateFrame()
    }
    
}

#endif
