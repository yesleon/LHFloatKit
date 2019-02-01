//
//  LHFloatViewController.swift
//  LHFloatKit
//
//  Created by 許立衡 on 2018/11/15.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation


class LHFloatViewController: UIViewController {
    
    var floatWindow: LHFloatWindow?
    var containerView: LHFloatContainerView {
        return view as! LHFloatContainerView
    }
    
    lazy var buttonBottomConstraint: NSLayoutConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.button.bottomAnchor, multiplier: 1)
    lazy var buttonTrailingConstraint: NSLayoutConstraint = view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.button.trailingAnchor, multiplier: 1)
    lazy var buttonTopConstraint = view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.button.topAnchor, multiplier: 1)
    
    lazy var button = AddButton()
    
    weak var connectedViewController: UIViewController? {
        didSet {
            if let vc = connectedViewController {
                updateButtonConstraints(from: vc)
            }
        }
    }
    
    override func loadView() {
        view = LHFloatContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBottomConstraint.isActive = true
        buttonTrailingConstraint.isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            if let vc = self.connectedViewController {
                self.updateButtonConstraints(from: vc)
            }
        })
    }
    
    func updateButtonConstraints(from vc: UIViewController) {
        containerView.setSafeArea(fromSafeAreaProvider: vc.safeAreaProvider)
        if vc.prefersFloatingActionButtonHidden {
            buttonBottomConstraint.isActive = false
            buttonTopConstraint.isActive = true
        } else {
            buttonTopConstraint.isActive = false
            buttonBottomConstraint.isActive = true
        }
        containerView.alpha = vc.prefersFloatingActionButtonHidden ? 0 : 1
        containerView.layoutIfNeeded()
    }
    
}
