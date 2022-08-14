//
//  Navc.swift
//
//  Created by LiKai on 2022/5/21.
//  
//
#if canImport(UIKit)

import UIKit

protocol NavcNotifys {
    
    func didPop()
    
}

public class Navc: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    public var rootVC: UIViewController!
    
    public var navBarColor: UIColor = .white
    
    public var tintColor: UIColor = .black
    
    public  var backImageName: String = "chevron.left"
    
    public var navBarTranslucent: Bool = true
    
    fileprivate func makeNavBar() {
        if #available(iOS 13.0, *) {
            UINavigationBar.appearance().isTranslucent = navBarTranslucent
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = navBarColor
            appearance.shadowColor = navBarColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor]
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor];
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: navBarColor), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor];
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavBar()
        
        rootVC = viewControllers.first
        
        delegate = self
        
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    @objc func back() {
        popViewController(animated: true)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        rootVC = rootViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == rootVC {
            return
        }
        
        if let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
           !navigationController.viewControllers.contains(dismissedViewController),
           let notifyVC = dismissedViewController as? NavcNotifys {
            notifyVC.didPop()
        }
        
        viewController.navigationItem.hidesBackButton = true
        var leftItems = viewController.navigationItem.leftBarButtonItems ?? []
        for item in leftItems {
            if item.tag == 10086 {
                return
            }
        }
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: backImageName)
        }
        if image == nil {
            image = UIImage(named: backImageName)
        }
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        item.tag = 10086
        item.tintColor = tintColor
        leftItems.insert(item, at: 0)
        viewController.navigationItem.leftBarButtonItems = leftItems
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for vc in viewControllers {
            for item in (vc.navigationItem.leftBarButtonItems ?? []) {
                item.tintColor = tintColor
            }
            for item in (vc.navigationItem.rightBarButtonItems ?? []) {
                item.tintColor = tintColor
            }
        }
        makeNavBar()
    }
}

#endif
