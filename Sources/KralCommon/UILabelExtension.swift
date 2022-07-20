//
//  UILabelExtension.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/19.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

public struct TextLineType {
    static let delete = NSAttributedString.Key.strikethroughStyle
    static let underLine = NSAttributedString.Key.underlineStyle
    static let noLine = ""
}

public extension UILabel {
    
    /// 设置所有内容为删除线
    func textWithDeleteLine(text: String, textColor: UIColor = .lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left) {
        textWithDeleteLine(text: text, textColor: textColor, font: font, alignment: alignment,
                           deleteText: text, deleteTextColor: textColor, deleteFont: font)
    }
    
    /// 设置部分内容为删除线
    func textWithDeleteLine(text: String, textColor: UIColor = .lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left, deleteText: String, deleteTextColor: UIColor = UIColor.lightGray, deleteFont: UIFont = UIFont.systemFont(ofSize: 12.0)) {
        textWithAnyLine(text: text, textColor: textColor, font: font, alignment: alignment, lineText: deleteText, lineTextColor: deleteTextColor, lineTextFont: deleteFont, lineType: TextLineType.delete.rawValue)
    }
    
    /// 设置所有内容为下划线
    func textWithUnderLine(text: String, textColor: UIColor = .lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left) {
        textWithUnderLine(text: text, textColor: textColor, font: font, alignment: alignment, underLineText: text, underLineTextColor: textColor, underLineFont: font)
    }
    
    /// 设置部分内容为下划线
    func textWithUnderLine(text: String, textColor: UIColor = .lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left, underLineText: String, underLineTextColor: UIColor = UIColor.lightGray, underLineFont: UIFont = UIFont.systemFont(ofSize: 12.0)) {
        textWithAnyLine(text: text, textColor: textColor, font: font, alignment: alignment, lineText: underLineText, lineTextColor: underLineTextColor, lineTextFont: underLineFont, lineType: TextLineType.underLine.rawValue)
    }
    
    /// 设置部分内容为特定线
    func textWithAnyLine(text: String, textColor: UIColor = .lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left, lineText: String, lineTextColor: UIColor = UIColor.lightGray, lineTextFont: UIFont = UIFont.systemFont(ofSize: 12.0), lineType: String) {
        self.attributedText = NSMutableAttributedString(string: text)
         self.attributedText = text.toAttributeString(textColor: textColor,
                                                                font: font,
                                                                alignment: alignment,
                                                                lineText: lineText,
                                                                lineTextColor: lineTextColor,
                                                                lineTextFont: lineTextFont,
                                                                lineType: lineType)
    }
    
    /// 计算宽度
    func caculatedWidth() -> CGFloat {
        guard let text = text else { return 0 }
        return UILabel.caculateWidth(text: text, font: self.font, height: frame.size.height)
    }
    
    /// 计算宽度
    static func caculateWidth(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let text = NSString(string: text)
        let rect = text.boundingRect(with: CGSize(width: 0, height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Int(rect.width)
        return CGFloat(width)
    }
    
    /// 计算高度
    func caculateHeight() -> CGFloat {
        return UILabel.caculateHeight(text: self.text!, font: self.font, width: frame.size.width)
    }
    
    /// 计算高度
    static func caculateHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let text = NSString(string: text)
        let rect = text.boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let height = Int(rect.height)
        return CGFloat(height)
    }
    
}

public extension String {
    
    /// 将一段文字转化为全部带下划线的 NSAttributedString
    ///
    /// - Parameters:
    ///   - textColor: 文字颜色
    ///   - font: 文字字体
    ///   - alignment: 对齐方式
    /// - Returns: NSAttributedString
    func toUnderLine(textColor: UIColor = UIColor.lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left) -> NSAttributedString {
        return toAttributeString(textColor: textColor,
                                 font: font,
                                 alignment: alignment,
                                 lineText: self,
                                 lineTextColor: textColor,
                                 lineTextFont: font,
                                 lineType: TextLineType.underLine.rawValue)
    }
    
    /// 将一段文字转化为部分文字带特殊线的 NSAttributedString
    ///
    /// - Parameters:
    ///   - textColor: 文本颜色（所有）
    ///   - font: 文本字体（所有）
    ///   - alignment: 对齐方式
    ///   - lineText: 需要做特殊线的文本
    ///   - lineTextColor: 需要做特殊线的文本颜色
    ///   - lineTextFont: 需要做特殊线的文本字体
    ///   - lineType: 特殊线类型：下划线/删除线
    /// - Returns: NSAtttributedString
    func toAttributeString(textColor: UIColor = UIColor.lightGray, font: UIFont = UIFont.systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left, lineText: String, lineTextColor: UIColor = UIColor.lightGray, lineTextFont: UIFont = UIFont.systemFont(ofSize: 12.0), lineType: String) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString.init(string: self)
        let textRange = NSMakeRange(0, attrString.length)
        let lineRange = NSString(string: self).range(of: lineText)
        
        // setAll
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
        attrString.addAttribute(NSAttributedString.Key.font, value: font, range: textRange)
        
        // setLine
        if lineRange.location != NSNotFound {
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: lineTextColor, range: lineRange)
            attrString.addAttribute(NSAttributedString.Key.font, value: lineTextFont, range: lineRange)
            attrString.addAttribute(NSAttributedString.Key(rawValue: lineType), value: NSNumber(value: (0x01|0x0000)), range: lineRange)
        }
        
        // set alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        
        return attrString
    }
    
    
}

// MARK: rich text link tap
// NOTE !!!!!!
// This Mehotd: characterRange(forGlyphRange:in:) will return wrong value if attribute value is settled from storyboard.
// So you should set attributeText to label only in code.
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        let layoutManager = NSLayoutManager()
        layoutManager.allowsNonContiguousLayout = true
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: CGSize(width: label.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0.0

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        
        var actualRange = NSRange()
        layoutManager.characterRange(forGlyphRange: targetRange, actualGlyphRange: &actualRange)
        let textRect = layoutManager.boundingRect(forGlyphRange: actualRange, in: textContainer)
        
        return textRect.contains(locationOfTouchInLabel)
    }

}

private var tapKey = "tapKey";

private var actionsKey = "actionsKey";

extension UILabel {
    
    fileprivate var tap: UITapGestureRecognizer {
        set {
            objc_setAssociatedObject(self, &tapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let result = (objc_getAssociatedObject(self, &tapKey) as? UITapGestureRecognizer) {
                return result
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            self.tap = tap
            return tap
        }
    }
    
    fileprivate var actions: [String: Any] {
        set {
            objc_setAssociatedObject(self, &actionsKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let result = (objc_getAssociatedObject(self, &actionsKey) as? [String: Any]) {
                return result
            }
            let dic: [String: Any] = [String: Any]()
            self.actions = dic
            return dic
        }
    }
    
    public func addTap(_ tap: @escaping () -> (), forSubString subString: String) {
        actions[subString] = tap
        
        isUserInteractionEnabled = true
        addGestureRecognizer(self.tap)
    }
    
    @objc fileprivate func didTap(_ tap: UITapGestureRecognizer) {
        guard let text = self.text else {
            return
        }
        for action in actions {
            let range = NSString(string: text).range(of: action.key)
            if tap.didTapAttributedTextInLabel(label: self, inRange: range),
               let value = action.value as? () -> () {
                value()
                return
            }
        }
    }
}

#endif
