//
//  LHFloatWindow.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation


class LHFloatWindow: UIWindow {
    
    var floatVC: LHFloatViewController! {
        return rootViewController as? LHFloatViewController
    }
    
    convenience init(floatingVC: LHFloatViewController) {
        self.init()
        rootViewController = floatingVC
        windowLevel = .normal + 1
        floatingVC.floatWindow = self
        backgroundColor = .clear
    }
    
    func persistAndShow() {
        floatVC.floatWindow = self
        isHidden = false
    }
    
    func destroy() {
        floatVC.floatWindow = nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if floatVC.presentedViewController == nil {
            return floatVC.button.point(inside: convert(point, to: floatVC.button), with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    func updateAppearance(from window: UIWindow) {
        tintColor = window.tintColor
        guard var topVC = window.topViewController else { return }
        if topVC.isBeingDismissed, let presentingViewController = topVC.presentingViewController {
            topVC = presentingViewController
        }
        floatVC.connect(with: topVC)
    }
    
}
