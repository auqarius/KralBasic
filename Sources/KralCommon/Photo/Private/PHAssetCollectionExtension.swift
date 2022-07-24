//
//  PHAssetCollectionExtension.swift
//  KralCommons
//
//  Created by mac on 2021/11/9.
//

import Foundation
import Photos

extension PHAssetCollection {
    
    /// 获取本相册下所有的照片
    /// - Parameters:
    ///   - ascending: 排序方式
    ///   - limitCount: 最大数量限制
    ///   - assetTypes: 需要获取的类型
    /// - Returns: 获取结果
    func allAssets(ascending: Bool = true, limitCount: Int32 = INT_MAX, assetTypes: [AssetType] = [.image, .video, .gif, .livePhoto]) -> [PHAsset] {
        var assets = [PHAsset]()
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
        
        let result = PHAsset.fetchAssets(in: self, options: option)
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
    
    /// 获取所有的相册
    static func allCollections() -> [PHAssetCollection] {
        let result1 = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let result2 = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        var collections = [PHAssetCollection]()
        result1.enumerateObjects { collection, _, _ in
            collections.append(collection)
        }
        result2.enumerateObjects { collection, _, _ in
            collections.append(collection)
        }
        
        return collections
    }
    
    /// 获取相册
    /// - Parameters:
    ///   - title: 标题
    ///   - autoCreate: 如果不存在是否自动创建
    /// - Returns: 获取结果
    static func get(title: String, autoCreate: Bool = true) -> PHAssetCollection? {
        
        // 本地是否有现成的
        if let existCollection = _get(title: title) {
            return existCollection
        }
        
        // 如果不自动创建则直接返回
        if !autoCreate {
            return nil
        }
        
        // 创建相册
        try? PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        }

        // 再次本地获取
        return _get(title: title)
    }
    
    /// 获取相册
    /// - Parameter title: 标题
    /// - Returns: 获取结果
    private static func _get(title: String) -> PHAssetCollection? {
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var resultCollectoin: PHAssetCollection?
        result.enumerateObjects { collection, index, stop in
            if collection.localizedTitle == title {
                resultCollectoin = collection
            }
        }
        return resultCollectoin
    }
    
}
