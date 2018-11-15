//
//  LHFloatContainerView.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

class LHFloatContainerView: UIView {
    
    private lazy var customSafeAreaLayoutGuide: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        self.addLayoutGuide(layoutGuide)
        return layoutGuide
    }()
    
    lazy var leftConstraint = customSafeAreaLayoutGuide.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
    lazy var topConstraint = customSafeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 0)
    lazy var widthConstraint = customSafeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 0)
    lazy var heightConstraint = customSafeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 0)

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(containing: bounds, contained: customSafeAreaLayoutGuide.layoutFrame)
    }
    
    override var safeAreaLayoutGuide: UILayoutGuide {
        return customSafeAreaLayoutGuide
    }
    
    func setSafeArea(fromSafeAreaProvider provider: UIView) {
        provider.layoutIfNeeded()
        NSLayoutConstraint.activate([leftConstraint, topConstraint, widthConstraint, heightConstraint])
        let layoutFrame = provider.convert(provider.safeAreaLayoutGuide.layoutFrame, to: self)
        leftConstraint.constant = layoutFrame.minX
        topConstraint.constant = layoutFrame.minY
        widthConstraint.constant = layoutFrame.width
        heightConstraint.constant = layoutFrame.height
    }
    
}
