//
//  ViewControllerExtension.swift
//
//  Created by LiKai on 2022/5/19.
//  
//
#if canImport(UIKit)

import Foundation
import UIKit
import MessageUI
import ObjectiveC.runtime


extension UIViewController {
    
    /// 从 storyboard 创建 viewController，需要在 SB 中 vc 的 identifier 是 vc 的类名
    /// - Parameter name: storyboard 的名字，不传则为 vc 的类名
    /// - Returns: 返回创建好的实例
    public static func loadFromSB(_ name: String? = nil) -> Self {
        return UIStoryboard(name: name ?? string, bundle: Bundle.main).instantiateViewController(withIdentifier: string) as! Self
    }
    
}

// MARK: - Email Send

private var kMailSentBlockIdentifier = "kMailSentBlockIdentifier"

public extension UIViewController {
    
    enum MailSendStatus: Int {
        case cancelled = 0
        case saved = 1
        case sent = 2
        case failed = 3
    }
    
    fileprivate var mailSentBlock: ((MailSendStatus, Error?) -> ())? {
        set {
            objc_setAssociatedObject(self, &kMailSentBlockIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kMailSentBlockIdentifier) as? (MailSendStatus, Error?) -> ())
        }
    }
    
    /// 发送 Email
    /// - Parameter address: Email 地址
    /// - Returns: 是否成功
    func sendEmailTo(_ address: String, mailSentBlock: @escaping (MailSendStatus, Error?) -> ()) -> Bool {
        guard MFMailComposeViewController.canSendMail() else {
            UIPasteboard.general.string = address
            return false
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([address])
        present(mail, animated: true)
        
        self.mailSentBlock = mailSentBlock
        
        return true
    }
    
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if let mailSentBlock = mailSentBlock {
            mailSentBlock(MailSendStatus(rawValue: result.rawValue)!, error)
        }
    }
    
}

#endif
