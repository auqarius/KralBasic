//
//  Photo+SaveAlbum.swift
//  KralCommons
//
//  Created by mac on 2021/11/4.
//

import UIKit
import Photos

public extension Photo {
    static func saveImage(_ image: UIImage, toAlbum: PHAssetCollection, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        let image = image
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                var savedAssetIdentifier: String? = nil
                PHPhotoLibrary.shared().performChanges({
                    savedAssetIdentifier = PHAssetChangeRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset?.localIdentifier
                }) { success, error in
                    if !success {
                        if let completionHandler = completionHandler {
                            completionHandler(success, error)
                        }
                        return
                    }
                    guard let savedAssetIdentifier = savedAssetIdentifier else {
                        if let completionHandler = completionHandler {
                            completionHandler(success, error)
                        }
                        return
                    }
                    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [savedAssetIdentifier], options: nil)
                    PHPhotoLibrary.shared().performChanges {
                        let _ = PHAssetCollectionChangeRequest(for: toAlbum, assets: assets)
                    } completionHandler: { suc, err in
                        if let completionHandler = completionHandler {
                            completionHandler(suc, err)
                        }
                    }
                }
            } else {
                if let completionHandler = completionHandler {
                    completionHandler(false, nil)
                }
            }
        }
    }

    static func saveVideoToAlbum(_ url: URL, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }, completionHandler: completionHandler)
            } else {
                if let completionHandler = completionHandler {
                    completionHandler(false, nil)
                }
            }
        }
    }
}
