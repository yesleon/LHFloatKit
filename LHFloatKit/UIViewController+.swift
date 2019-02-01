//
//  UIViewController+.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation


let floatingButtonAppearanceNeedsUpdate = NSNotification.Name("FloatingWindowAppearanceNeedsUpdate")

extension UIViewController {
    
    @objc open var prefersFloatingActionButtonHidden: Bool {
        if let child = childForFloatingActionButtonHidden {
            return child.prefersFloatingActionButtonHidden
        } else {
            return true
        }
    }
    
    @objc open var childForFloatingActionButtonHidden: UIViewController? {
        return nil
    }
    
    var safeAreaProvider: UIView {
        return childForSafeArea?.view ?? self.view
    }
    
    @objc open var childForSafeArea: UIViewController? {
        return nil
    }
    
    @objc open func setNeedsFloatingActionButtonAppearanceUpdate() {
        NotificationCenter.default.post(name: floatingButtonAppearanceNeedsUpdate, object: nil)
    }
    
    @objc open var childForFloatingActionButtonEvents: UIViewController? {
        return nil
    }
    
    @objc open var canHandleFloatingActionButtonEvents: Bool {
        if let child = childForFloatingActionButtonEvents {
            return child.canHandleFloatingActionButtonEvents
        } else {
            return false
        }
    }
    
    @objc open func floatingActionButtonDidPress(_ sender: UIButton) {
        if let child = childForFloatingActionButtonEvents {
            child.floatingActionButtonDidPress(sender)
        }
    }
    
    @objc open func dragItemForFloatingActionButton() -> UIDragItem? {
        return childForFloatingActionButtonEvents?.dragItemForFloatingActionButton()
    }
    
}


extension UINavigationController {
    
    open override var childForFloatingActionButtonHidden: UIViewController? {
        return topViewController
    }
    
    open override var childForSafeArea: UIViewController? {
        return topViewController
    }
    
    override open var childForFloatingActionButtonEvents: UIViewController? {
        return topViewController
    }
    
}

extension UIPageViewController {
    
    open override var childForFloatingActionButtonHidden: UIViewController? {
        return viewControllers?.first
    }
    
    open override var childForSafeArea: UIViewController? {
        return viewControllers?.first
    }
    
    override open var childForFloatingActionButtonEvents: UIViewController? {
        return viewControllers?.first
    }
    
}

extension UITabBarController {
    
    open override var childForFloatingActionButtonHidden: UIViewController? {
        return selectedViewController
    }
    
    open override var childForSafeArea: UIViewController? {
        return selectedViewController
    }
    
    override open var childForFloatingActionButtonEvents: UIViewController? {
        return selectedViewController
    }
    
}
