//
//  Photo.swift
//  KralCommons
//
//  Created by mac on 2021/11/4.
//

import UIKit
import Photos

public typealias SelectedImagesBlock = (_ orignalImage: UIImage?, _ editedImage: UIImage?, _ mediaURL: URL?) -> ()

public class Photo: NSObject {
        
    static let shared: Photo = Photo()
    
    var albums: [AlbumModel] = []
    
    var allowsEditing: Bool = true
    
    private override init() {
        super.init()
    }
    
    var selectedImagesBlock: SelectedImagesBlock?
        
    func showSelectActionSheet(with title: String, cameraTitle: String = "Camera", albumTitle: String = "Photo Library", cancelTitle: String = "Cancel", sourceView: UIView? = nil, from vc: UIViewController) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: cameraTitle, style: .default, handler: { (action: UIAlertAction) in
            self.openCamera(from: vc)
        }))
        actionSheet.addAction(UIAlertAction(title: albumTitle, style: .default, handler: { (action: UIAlertAction) in
            self.openPhotoLibrary(from: vc)
        }))
        actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.popoverPresentationController?.sourceRect = sourceView?.bounds ?? CGRect.zero
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera(from vc: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            alert(viewController: vc, title: "", message: "The device does not support the camera or the camera is not available", confirmTitle: "Confirm", cancelTitle: "", confirm: {
                
            }, cancel: nil)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        imagePicker.sourceType = .camera
        vc.present(imagePicker, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(from vc: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            alert(viewController: vc, title: "", message: "The device does not support photo library or photo library are not available", confirmTitle: "Confirm", cancelTitle: "", confirm: {
                
            }, cancel: nil)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        imagePicker.sourceType = .photoLibrary
        vc.present(imagePicker, animated: true, completion: nil)
    }
}

extension Photo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let orignalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        let mediaURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? UIImage

        if let selectedImagesBlock = selectedImagesBlock {
            selectedImagesBlock([orignalImage, editedImage, mediaURL])
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

public extension Photo {
    
    /// 显示图片选择，从相册或者拍照
    ///
    /// - Parameters:
    ///   - title: ActionSheet 标题
    ///   - maxNumberOfSelections: 最大添加图片数量
    ///   - finish: 选择图片完成
    class func showSelectionActionSheet(title: String, cameraTitle: String = "Camera", albumTitle: String = "Photo Library", cancelTitle: String = "Cancel", sourceView: UIView? = nil, from vc: UIViewController, allowsEditing: Bool = true, finish: SelectedImagesBlock?) {
        Photo.shared.selectedImagesBlock = finish
        Photo.shared.allowsEditing = allowsEditing
        Photo.shared.showSelectActionSheet(with: title,
                                           cameraTitle: cameraTitle,
                                           albumTitle: albumTitle,
                                           cancelTitle: albumTitle,
                                           sourceView: sourceView,
                                           from: vc)
    }
    
    /// 打开相机拍照
    class func openCamera(from vc: UIViewController, allowsEditing: Bool = true, finish: SelectedImagesBlock?) {
        Photo.shared.selectedImagesBlock = finish
        Photo.shared.allowsEditing = allowsEditing
        Photo.shared.openCamera(from: vc)
    }
    
    /// 打开相册
    class func openPhotoLibrary(from vc: UIViewController, allowsEditing: Bool = true, finish: SelectedImagesBlock?) {
        Photo.shared.selectedImagesBlock = finish
        Photo.shared.allowsEditing = allowsEditing
        Photo.shared.openPhotoLibrary(from: vc)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

public extension Photo {
    // Auth
    static var authGranted: Bool {
        get {
            let status = PHPhotoLibrary.authorizationStatus()
            if #available(iOS 14, *) {
                if status == .limited {
                    return true
                }
            } else {
                // Fallback on earlier versions
            }
            
            if status == .authorized {
                return true
            }
            
            return false
        }
    }
    
    static func requestAlbum(completion: @escaping (Bool) -> ()) {
        if authGranted {
            completion(true)
            return
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            completion(false)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.requestAlbum(completion: completion)
            }
        }
    }
}
