//
//  UITextFiledExtension.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/19.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

public extension UITextField {
    
    func setLeftPadding(_ left: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ right: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

#endif
