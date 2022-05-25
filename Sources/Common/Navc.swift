//
//  Navc.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/21.
//  
//
#if canImport(UIKit)

import UIKit

class Navc: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    var rootVC: UIViewController!

    var navBarColor: UIColor = .white
    
    var tintColor: UIColor = .black
    
    var backImageName: String = "chevron.left"
    
    var navBarTranslucent: Bool = true

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

    override func viewDidLoad() {
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

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == rootVC {
            return
        }
        viewController.navigationItem.hidesBackButton = true
        var leftItems = viewController.navigationItem.leftBarButtonItems ?? []
        for item in leftItems {
            if item.tag == 10086 {
                return
            }
        }
        var image = UIImage(systemName: backImageName)
        if image == nil {
            image = UIImage(named: backImageName)
        }
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        item.tag = 10086
        item.tintColor = tintColor
        leftItems.insert(item, at: 0)
        viewController.navigationItem.leftBarButtonItems = leftItems
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
