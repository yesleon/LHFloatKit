//
//  UIApplication+.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation
import LHConvenientMethods

let bundle = Bundle(identifier: "com.narrativesaw.LHFloatKit")!

extension UIApplication {
    
    private var floatWindow: LHFloatWindow? {
        return windows.compactMap({ $0 as? LHFloatWindow }).first
    }
    
    @objc open var installsFloatWindow: Bool {
        get {
            return floatWindow != nil
        }
        set {
            if newValue {
                guard floatWindow == nil else { return }
                let floatingVC = LHFloatViewController()
                let window = LHFloatWindow(floatingVC: floatingVC)
                window.floatVC.button.addTarget(self, action: #selector(didPressFloatButton), for: .touchUpInside)
                window.floatVC.button.dragItemProvider = {
                     return self.keyWindow?.topViewController?.dragItemForFloatButton()
                }
                window.persistAndShow()
                NotificationCenter.default.addObserver(self, selector: #selector(updateFloatWindowAppearance), name: floatButtonAppearanceNeedsUpdate, object: nil)
                
            } else {
                guard let window = floatWindow else { return }
                NotificationCenter.default.removeObserver(self, name: floatButtonAppearanceNeedsUpdate, object: nil)
                window.destroy()
            }
        }
    }
    
    @objc private func updateFloatWindowAppearance() {
        if let keyWindow = keyWindow {
            floatWindow?.updateAppearance(from: keyWindow)
        }
    }
    
    @objc private func didPressFloatButton(_ sender: UIButton) {
        guard let topVC = keyWindow?.topViewController else { return }
        if topVC.canHandleFloatingWindowEvents {
            topVC.floatButtonDidPress(sender)
        }
    }
    
}
