// ScrollEdgeBarSlotHostView.swift
// ScrollEdgeBar
//
// Created by Jens Van Steen
// MIT License

import UIKit

/// A stable UIKit host used as scroll-edge bar content.
///
/// `safeAreaBar` works best when the UIKit view identity it hosts remains
/// stable. This container lets integrations such as React Native keep a fixed
/// bar view in SwiftUI while replacing or reparenting the actual content inside
/// that view.
public final class ScrollEdgeBarSlotHostView: UIView {
    /// The current view mounted inside the slot.
    public private(set) weak var contentView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    /// Replaces the hosted content view.
    ///
    /// The hosted view is sized to fill the slot using autoresizing masks so it
    /// remains compatible with views whose layout is driven externally.
    public func setContentView(_ view: UIView?) {
        if contentView === view { return }

        contentView?.removeFromSuperview()
        contentView = view

        guard let view else {
            invalidateIntrinsicContentSize()
            return
        }

        view.removeFromSuperview()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
        invalidateIntrinsicContentSize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = bounds
    }

    public override var intrinsicContentSize: CGSize {
        guard let contentView else { return super.intrinsicContentSize }

        if contentView.bounds.height > 0 {
            return CGSize(width: UIView.noIntrinsicMetric, height: contentView.bounds.height)
        }

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: UIView.noIntrinsicMetric, height: size.height)
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        return result === self ? nil : result
    }
}
