//
//  AddButton.swift
//  StoryboardsStoryboardScene
//
//  Created by 許立衡 on 2018/11/13.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    
    var dragItemProvider: (() -> UIDragItem?)?
    
    private func initialize() {
        setImage(UIImage(named: "icons8-plus_2_math", in: bundle, compatibleWith: nil), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true
        addInteraction(dragInteraction)
        gestureRecognizers?.compactMap({
            $0 as? UILongPressGestureRecognizer
        }).first?.minimumPressDuration = 0.2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

}
extension AddButton: UIDragInteractionDelegate {
    
    public func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let dragItem = dragItemProvider?() {
            return [dragItem]
        } else {
            return []
        }
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let view = interaction.view else { return nil }
        let parameters = UIDragPreviewParameters()
        parameters.visiblePath = UIBezierPath(ovalIn: view.bounds.insetBy(dx: 3, dy: 3))
        let preview = UITargetedDragPreview(view: view, parameters: parameters)
        return preview
    }
    
}
