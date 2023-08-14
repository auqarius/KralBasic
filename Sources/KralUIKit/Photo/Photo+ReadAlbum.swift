//
//  Photo+SystemUI.swift

//
//  Created by mac on 2021/11/4.
//

import UIKit
import Photos

public class AlbumModel {
    var collection: PHAssetCollection?
    var title: String = "All Photos"
    var count: Int = 0
    var coverImage: UIImage?
    
    func requestData() {
        var assets: [PHAsset] = []
        assets = collection!.allAssets()
        if let title = collection!.localizedTitle {
            self.title = title
        }
        
        count = assets.count
        
        if let asset = assets.first {
            let _ = asset.resquestOrigianlImage(size: CGSize(width: 300, height: 300)) { image, degraded in
                self.coverImage = image
            }
        }
    }
    
    init(_ collection: PHAssetCollection? = nil) {
        self.collection = collection
        requestData()
    }
}

public extension Photo {
    
    func readAlbums() {
        albums = PHAssetCollection.allCollections().filter({ collection in
            if collection.assetCollectionSubtype.rawValue > 215 {
                return false
            }
            if collection.assetCollectionSubtype == .smartAlbumSlomoVideos {
                return false
            }
            if collection.assetCollectionSubtype == .smartAlbumVideos {
                return false
            }
            if collection.assetCollectionSubtype == .smartAlbumAllHidden {
                return false
            }
            return true
        }).map({ collection in
            return AlbumModel(collection)
        }).filter({ album in
            return album.count > 0
        }).sorted(by: { album1, album2 in
            return album1.count > album2.count
        })
    }
    
}


