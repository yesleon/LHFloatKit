//
//  UIViewController+.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation


let floatButtonAppearanceNeedsUpdate = NSNotification.Name("FloatingWindowAppearanceNeedsUpdate")

extension UIViewController {
    
    @objc open var prefersFloatingWindowHidden: Bool {
        if let child = childForFloatingWindowHidden {
            return child.prefersFloatingWindowHidden
        } else {
            return true
        }
    }
    
    @objc open var childForFloatingWindowHidden: UIViewController? {
        return nil
    }
    
    var safeAreaProvider: UIView {
        return childForSafeArea?.view ?? self.view
    }
    
    @objc open var childForSafeArea: UIViewController? {
        return nil
    }
    
    @objc open func setNeedsFloatingWindowAppearanceUpdate() {
        NotificationCenter.default.post(name: floatButtonAppearanceNeedsUpdate, object: nil)
    }
    
    @objc open var childForFloatingWindowEvents: UIViewController? {
        return nil
    }
    
    @objc open var canHandleFloatingWindowEvents: Bool {
        if let child = childForFloatingWindowEvents {
            return child.canHandleFloatingWindowEvents
        } else {
            return false
        }
    }
    
    @objc open func handleFloatingWindowEvents(_ sender: UIView) {
        if let child = childForFloatingWindowEvents {
            child.handleFloatingWindowEvents(sender)
        }
    }
    
}


extension UINavigationController {
    
    open override var childForFloatingWindowHidden: UIViewController? {
        return topViewController
    }
    
    open override var childForSafeArea: UIViewController? {
        return topViewController
    }
    
    override open var childForFloatingWindowEvents: UIViewController? {
        return topViewController
    }
    
}

extension UIPageViewController {
    
    open override var childForFloatingWindowHidden: UIViewController? {
        return viewControllers?.first
    }
    
    open override var childForSafeArea: UIViewController? {
        return viewControllers?.first
    }
    
    override open var childForFloatingWindowEvents: UIViewController? {
        return viewControllers?.first
    }
    
}

extension UITabBarController {
    
    open override var childForFloatingWindowHidden: UIViewController? {
        return selectedViewController
    }
    
    open override var childForSafeArea: UIViewController? {
        return selectedViewController
    }
    
    override open var childForFloatingWindowEvents: UIViewController? {
        return selectedViewController
    }
    
}
