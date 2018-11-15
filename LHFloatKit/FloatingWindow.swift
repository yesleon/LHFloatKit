//
//  FloatingWindow.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/14.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation
import QuartzCore

let floatingWindowAppearanceNeedsUpdate = NSNotification.Name("floatingWindowAppearanceNeedsUpdate")

extension UIViewController {
    
    @objc open var prefersFloatingWindowHidden: Bool {
        if let child = childForFloatingWindowHidden {
            return child.prefersFloatingWindowHidden
        } else {
            return false
        }
    }
    
    @objc open var childForFloatingWindowHidden: UIViewController? {
        return nil
    }
    
    @objc var safeAreaInsets: UIEdgeInsets {
        if let child = childForSafeArea {
            return child.safeAreaInsets
        } else {
            return view.safeAreaInsets
        }
    }
    
    @objc open var childForSafeArea: UIViewController? {
        return nil
    }
    
    @objc open func setNeedsFloatingWindowAppearanceUpdate() {
        NotificationCenter.default.post(name: floatingWindowAppearanceNeedsUpdate, object: nil)
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

extension UIApplication {
    
    var floatingWindow: FloatingWindow? {
        return windows.compactMap({ $0 as? FloatingWindow }).first
    }
    
    open var installsFloatingWindow: Bool {
        get {
            return floatingWindow != nil
        }
        set {
            if newValue {
                guard floatingWindow == nil else { return }
                let floatingVC = FloatingViewController()
                let window = FloatingWindow(floatingVC: floatingVC)
                window.floatingVC.button.addTarget(self, action: #selector(didPressFloatingWindowButton), for: .touchUpInside)
                window.persistAndShow()
                NotificationCenter.default.addObserver(self, selector: #selector(updateFloatingWindowAppearance), name: floatingWindowAppearanceNeedsUpdate, object: nil)
                
            } else {
                guard let window = floatingWindow else { return }
                NotificationCenter.default.removeObserver(self, name: floatingWindowAppearanceNeedsUpdate, object: nil)
                window.destroy()
            }
        }
    }
    
    @objc func updateFloatingWindowAppearance() {
        guard let window = floatingWindow else { return }
        window.tintColor = keyWindow?.tintColor
        guard var topVC = keyWindow?.topViewController else { return }
        if topVC.isBeingDismissed, let presentingViewController = topVC.presentingViewController {
            topVC = presentingViewController
        }
        window.floatingVC.connect(with: topVC)
    }
    
    @objc func didPressFloatingWindowButton(_ sender: UIButton) {
        guard let topVC = keyWindow?.topViewController else { return }
        if topVC.canHandleFloatingWindowEvents {
            topVC.handleFloatingWindowEvents(sender)
        }
    }
    
}

class FloatingWindow: UIWindow {
    
    var floatingVC: FloatingViewController! {
        return rootViewController as? FloatingViewController
    }

    convenience init(floatingVC: FloatingViewController) {
        self.init()
        rootViewController = floatingVC
        windowLevel = .normal + 1
        floatingVC.savedWindow = self
        backgroundColor = .clear
    }
    
    func persistAndShow() {
        floatingVC.savedWindow = self
        isHidden = false
    }
    
    func destroy() {
        floatingVC.savedWindow = nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if floatingVC.presentedViewController == nil {
            return floatingVC.button.point(inside: convert(point, to: floatingVC.button), with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
}

class FloatingViewController: UIViewController {
    
    var savedWindow: FloatingWindow?
    
    var localSafeAreaInsets: UIEdgeInsets?
    
    override var safeAreaInsets: UIEdgeInsets {
        return localSafeAreaInsets ?? super.safeAreaInsets
    }
    
    lazy var buttonBottomConstraint: NSLayoutConstraint = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -safeAreaInsets.bottom)
    lazy var buttonLeadingConstraint: NSLayoutConstraint = button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -safeAreaInsets.left)
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("asdf", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var updateButtonConstraintsHandler: (TimeInterval) -> Void = { _ in self.view.setNeedsUpdateConstraints() }
    
    override func loadView() {
        super.loadView()
        view.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBottomConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        updateButtonConstraintsHandler(0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.updateButtonConstraintsHandler(context.transitionDuration)
        })
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        buttonBottomConstraint.constant = -safeAreaInsets.bottom
        buttonLeadingConstraint.constant = -safeAreaInsets.left
    }
    
    func connect(with vc: UIViewController) {
        let animationHandler: (TimeInterval) -> Void = { duration in
            UIView.animate(withDuration: duration, animations: {
                self.view.alpha = vc.prefersFloatingWindowHidden ? 0 : 1
                self.localSafeAreaInsets = vc.safeAreaInsets
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            })
        }
        updateButtonConstraintsHandler = { duration in
            if let transitionCoordinator = vc.transitionCoordinator {
                transitionCoordinator.animateAlongsideTransition(in: self.savedWindow, animation: { context in
                    animationHandler(context.transitionDuration)
                })
            } else {
                animationHandler(duration)
            }
        }
        updateButtonConstraintsHandler(0)
    }
    
}
