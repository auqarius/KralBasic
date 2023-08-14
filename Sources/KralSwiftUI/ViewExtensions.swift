//
//  File.swift
//  
//
//  Created by Kral on 14/8/2023.
//

import SwiftUI

// 自定义位置圆角
@available(iOS 13.0, *)
public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

@available(iOS 13.0, *)
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

@available(iOS 13.0, *)
// A modifier that animates a font through various sizes.
struct AnimatableCustomFontModifier: ViewModifier, Animatable {
    var size: Double
    var weight: Font.Weight
    var color: Color

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

@available(iOS 13.0, *)
// To make that easier to use, I recommend wrapping
// it in a `View` extension, like this:
public extension View {
    func animatableFont(size: Double, weight: Font.Weight, textColor: Color) -> some View {
        self.modifier(AnimatableCustomFontModifier(size: size, weight: weight, color: textColor))
    }
}

@available(iOS 13.0, *)
public extension View {
    @MainActor func snapshot() -> UIImage? {
        if #available(iOS 16.0, *) {
            let renderer = ImageRenderer(content: self)
            renderer.scale = UIScreen.main.scale
            if let uiImage = renderer.uiImage {
                return uiImage
            }
        } else {
            let controller = UIHostingController(rootView: self)
            let view = controller.view
     
            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear
     
            let renderer = UIGraphicsImageRenderer(size: targetSize)
     
            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
        
        return nil
    }
}

@available(iOS 13, *)
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}
