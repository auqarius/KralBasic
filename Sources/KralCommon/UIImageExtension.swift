//
//  File.swift
//  
//
//  Created by LiKai on 2022/8/2.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

extension UIImage {
    
    /// 创建一张纯色图片
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 旋转图片
    /// - Parameter orientation: 旋转方向，仅支持上下左右（镜像）
    public func rotate(_ orientation: Orientation) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }
}

#endif
