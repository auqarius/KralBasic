//
//  Alert.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/18.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit

// MARK: - Alert
public func alert(viewController: UIViewController, title: String = "", message: String = "", confirmTitle: String = "", otherTitles: [String] = [], cancelTitle: String = "", confirm: @escaping () -> (), otherSelected: ((String) -> ())? = nil, cancel:  (() -> ())? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        if confirmTitle.count > 0 {
            alert.addAction(UIAlertAction.init(title: confirmTitle, style: .default, handler: { (action: UIAlertAction) in
                confirm()
            }))
        }
        
        if otherTitles.count > 0 {
            for title in otherTitles {
                if title.count > 0 {
                    alert.addAction(UIAlertAction.init(title: title, style: .default, handler: { (action: UIAlertAction) in
                        if let otherSelected = otherSelected {
                            otherSelected(action.title!)
                        }
                    }))
                }
            }
        }
        
        if cancelTitle.count > 0 {
            alert.addAction(UIAlertAction.init(title: cancelTitle, style: .default, handler: { (action: UIAlertAction) in
                if let cancel = cancel {
                    cancel()
                }
            }))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

func actionSheet(viewController: UIViewController, sourceView: UIView? = nil, title: String? = nil, message: String? = nil, titles: [String] = [], destructiveTitles: [String] = [], cancelTitle: String = "", confirm: @escaping (String) -> (), cancel:  (() -> ())? = nil) {
    DispatchQueue.main.async {
        let actionSheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.popoverPresentationController?.sourceRect = sourceView?.bounds ?? CGRect.zero
        for title in titles {
            if title.count > 0 {
                actionSheet.addAction(UIAlertAction.init(title: title, style: .default, handler: { (action: UIAlertAction) in
                    confirm(title)
                }))
            }
        }
        
        for destructiveTitle in destructiveTitles {
            if destructiveTitle.count > 0 {
                actionSheet.addAction(UIAlertAction.init(title: destructiveTitle, style: .destructive, handler: { (action: UIAlertAction) in
                    confirm(destructiveTitle)
                }))
            }
        }
        
        if cancelTitle.count > 0 {
            actionSheet.addAction(UIAlertAction.init(title: cancelTitle, style: .cancel, handler: { (action: UIAlertAction) in
                if let cancel = cancel {
                    cancel()
                }
            }))
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

func alertWithInput(from vc: UIViewController, title: String, msg: String, placeholder: String, cancelTitle: String = "Cancel", confirmTitle: String = "Confirm", completion: @escaping (String) -> ()) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
    alert.addTextField { (textField) in
        textField.placeholder = placeholder
        textField.isSecureTextEntry = true
    }
    
    alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action: UIAlertAction) in
        
    }))
    
    alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { (action: UIAlertAction) in
        if let text = alert.textFields?[0].text,
           text.count > 0 {
            completion(text)
        }
    }))
    
    vc.present(alert, animated: true, completion: nil)
}

#endif
