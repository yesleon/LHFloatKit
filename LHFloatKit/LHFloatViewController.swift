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
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icons8-plus_2_math", in: bundle, compatibleWith: nil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var updateButtonConstraintsHandler: (TimeInterval) -> Void = { _ in
        self.view.setNeedsUpdateConstraints()
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
        updateButtonConstraintsHandler(0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.updateButtonConstraintsHandler(context.transitionDuration)
        })
    }
    
    func connect(with vc: UIViewController) {
        let animationHandler: (TimeInterval) -> Void = { duration in
            self.containerView.setSafeArea(fromSafeAreaProvider: vc.safeAreaProvider)
            if vc.prefersFloatingWindowHidden {
                self.buttonBottomConstraint.isActive = false
                self.buttonTopConstraint.isActive = true
            } else {
                self.buttonBottomConstraint.isActive = true
                self.buttonTopConstraint.isActive = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.containerView.alpha = vc.prefersFloatingWindowHidden ? 0 : 1
                self.containerView.layoutIfNeeded()
            })
        }
        updateButtonConstraintsHandler = { duration in
            if let transitionCoordinator = vc.transitionCoordinator {
                transitionCoordinator.animateAlongsideTransition(in: self.floatWindow, animation: { context in
                    animationHandler(context.transitionDuration)
                })
            } else {
                animationHandler(duration)
            }
        }
        updateButtonConstraintsHandler(0)
    }
    
}
