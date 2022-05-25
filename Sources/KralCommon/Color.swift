//
//  Color.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/21.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

public extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }

            assert(hexFormatted.count == 6, "Invalid hex code used.")

            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
    }
    
    var light: UIColor {
        get {
            return alpha(0.1)
        }
    }
    
    var dark: UIColor {
        get {
            return brightness(0.7)
        }
    }
    
    func brightness(_ brightness: CGFloat = 1) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness*brightness, alpha: alpha)
    }
    
    func hueWithOffset(_ offset: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hue = hue + offset/360
        if hue > 1 {
            hue = hue - 1
        }
        return UIColor(hue: hue, saturation: saturation, brightness: brightness*brightness, alpha: alpha)
    }
    
    func lightColor(_ light: CGFloat = 1) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        red = (2 - light) * red
        green = (2 - light) * green
        blue = (2 - light) * blue
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func darkColor(_ dark: CGFloat = 1) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        red = (dark) * red
        green = (dark) * green
        blue = (dark) * blue
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func alpha(_ alpha: CGFloat = 0.1) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func complementColor() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let shiftedHue = hueShift(hue: hue, s: 180)
        return UIColor(hue: shiftedHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    fileprivate func hueShift(hue: CGFloat, s: CGFloat) -> CGFloat {
        
        var result = hue*360 + s
        while result >= 360 {
            result -= 360
        }
        while result < 0 {
            result += 360
        }
        
        return result/360
    }
}

public extension UIImage {
    
    /// 创建一张纯色图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

#endif
