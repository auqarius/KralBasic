//
//  PHAssetExtension.swift
//
//  Created by mac on 2021/11/9.
//

import UIKit
import Photos
import ObjectiveC

// Asset 类型：系统的 mediaType 不精确，无法判定是 gif 或者 livePhoto
enum AssetType {
    case image, video, gif, livePhoto, audio, netImage, netVideo, unknown
}

extension TimeInterval {
    func formatString(unitStyle: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = unitStyle
        return formatter.string(from: self) ?? ""
    }
}

/// PHImageRequestID 其实原本就是 Int32
extension Int32 {
    func cancelImageRequest() {
        PHImageManager.default().cancelImageRequest(self)
    }
}

extension PHAsset {
    
    // Asset 类型：系统的 mediaType 不精确，无法判定是 gif 或者 livePhoto
    var type: AssetType {
        get {
            switch mediaType {
            case .audio:
                return .audio
            case .video:
                return .video
            case .image:
                do {
                    if let fileName = value(forKey: "filename") as? String,
                       fileName.hasSuffix("GIF") {
                        return .gif
                    }
                    
                    if mediaSubtypes == .photoLive || mediaSubtypes.rawValue == 10 {
                        return .livePhoto
                    }
                    return.image
                }
            default:
                return .unknown
            }
        
        }
    }
    
    // 视频的时长
    var durationText: String? {
        get {
            if mediaType != .video {
                return nil
            }
            
            return duration.formatString(unitStyle: .positional)
        }
    }
    
    /// 获取图片
    /// - Parameters:
    ///   - size: 图片大小
    ///   - progress: 进度
    ///   - completion: 完成回调，一般会触发两次，第一次是压缩的图片，第二次是对应尺码的原图
    /// - Returns: 请求的 ID，取消请求的时候需要
    func resquestOrigianlImage(size: CGSize? = nil, progress: ((Double) -> ())? = nil, completion: @escaping (UIImage?, Bool) -> ()) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        option.progressHandler = { p, error, stop, info in
            if let progress = progress {
                progress(p)
            }
        }
        
        var aimSize: CGSize!
        if let size = size {
            aimSize = size
        } else {
            if pixelWidth >= 2100 {
                let radio = CGFloat(pixelWidth) / CGFloat(pixelHeight)
                aimSize = CGSize(width: 2000, height: 2000/radio)
            } else {
                aimSize = CGSize(width: pixelWidth, height: pixelHeight)
            }
        }
        
        return PHImageManager.default().requestImage(for: self, targetSize: aimSize, contentMode: .aspectFill, options: option) { image, info in
            let degraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
            completion(image, degraded)
        }
    }
    
    /// 根据 Id 获取一个图片对象
    /// - Parameter localIdentifier: id
    /// - Returns: 图片对象
    static func from(localIdentifier: String) -> PHAsset? {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        return result.firstObject
    }
    
    /// 所有的图片对象
    /// - Parameters:
    ///   - ascending: 排序
    ///   - limitCount: 最大数量限制
    ///   - assetTypes: 包含类型
    /// - Returns: 获取结果
    static func allAssets(ascending: Bool = true, limitCount: Int32 = INT_MAX, assetTypes: [AssetType] = [.image, .video, .gif, .livePhoto]) -> [PHAsset] {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
        let result = PHAsset.fetchAssets(with: option)
        
        var assets = [PHAsset]()
        
        result.enumerateObjects { asset, index, stop in
            if index >= limitCount {
                stop.pointee = true
            }
            if assetTypes.contains(asset.type) {
                assets.append(asset)
            }
        }
        
        return assets
    }
}


// MARK: - 适用于 cell 中重用的加载方法

fileprivate var kLastRequestId = "kLastRequestId"
fileprivate var kAssetIdentifier = "kAssetIdentifier"

extension UIView {
    
    fileprivate var lastRequestId: Int32? {
        get {
            return (objc_getAssociatedObject(self, &kLastRequestId) as? Int32)
        }
        set {
            objc_setAssociatedObject(self, &kLastRequestId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    fileprivate var assetIdentifier: String? {
        get {
            return (objc_getAssociatedObject(self, &kAssetIdentifier) as? String)
        }
        set {
            objc_setAssociatedObject(self, &kAssetIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
     func loadImageFromAsset(asset: PHAsset?, size: CGSize?, completed: @escaping (UIImage?) -> ()) {
        guard let asset = asset else {
            completed(nil)
            return
        }
        
        if let lastRequestId = lastRequestId,
            lastRequestId > PHInvalidImageRequestID {
            lastRequestId.cancelImageRequest()
        }
        
        assetIdentifier = asset.localIdentifier
        
        let aimSize = size ?? frame.size.scaled
        let _ = asset.resquestOrigianlImage(size: aimSize) { image, degraded in
            if self.assetIdentifier == asset.localIdentifier {
                completed(image)
            }

            if !degraded {
                self.lastRequestId = -1
            }
        }
    }
    
}

extension UITableViewCell {
    func loadImageFrom(asset: PHAsset?, size: CGSize? = nil, forImageView imageView: UIImageView) {
        loadImageFromAsset(asset: asset, size: size) { image in
            imageView.image = image
        }
    }
}

extension UICollectionViewCell {
    func loadImageFrom(asset: PHAsset?, size: CGSize? = nil, forImageView imageView: UIImageView) {
        loadImageFromAsset(asset: asset, size: size) { image in
            imageView.image = image
        }
    }
}
