// ScrollEdgeBarController.swift
// ScrollEdgeBar
//
// Created by Jens Van Steen
// MIT License

import UIKit
import SwiftUI

/// A container that wraps a UIScrollView with iOS 26+ glass blur bars.
///
/// Use this to add sticky bars at the top and/or bottom of your scroll view that
/// seamlessly extend the navigation bar or tab bar blur.
///
/// Example:
/// ```swift
/// let edgeBar = ScrollEdgeBarController(scrollView: myScrollView)
///
/// let segmentedControl = UISegmentedControl(items: ["First", "Second"])
/// edgeBar.setTopBar(segmentedControl)
///
/// let toolbar = UIToolbar()
/// edgeBar.setBottomBar(toolbar)
///
/// addChild(edgeBar)
/// view.addSubview(edgeBar.view)
/// edgeBar.didMove(toParent: self)
/// ```
@available(iOS 26.0, *)
public final class ScrollEdgeBarController: UIViewController {

    // MARK: - Public Properties

    /// The wrapped scroll view
    public let scrollView: UIScrollView

    /// Estimated top bar height (used before layout to prevent flicker)
    public var estimatedTopBarHeight: CGFloat = 60

    /// Estimated bottom bar height (used before layout to prevent flicker)
    public var estimatedBottomBarHeight: CGFloat = 60

    // MARK: - Private Properties

    private var topBarView: UIView?
    private var bottomBarView: UIView?
    private var hostingController: UIHostingController<ScrollEdgeBarWrapperView>?
    private var didSetup = false

    // MARK: - Initialization

    /// Creates a new ScrollEdgeBarController wrapping the given scroll view.
    /// - Parameter scrollView: The UIScrollView to wrap with edge bars
    public init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API

    /// Sets the content for the top edge bar.
    /// - Parameter view: A UIView to display as the top bar
    public func setTopBar(_ view: UIView) {
        topBarView = view
        updateHostingControllerIfNeeded()
    }

    /// Sets the content for the bottom edge bar.
    /// - Parameter view: A UIView to display as the bottom bar
    public func setBottomBar(_ view: UIView) {
        bottomBarView = view
        updateHostingControllerIfNeeded()
    }

    /// Removes the top edge bar.
    public func removeTopBar() {
        topBarView = nil
        updateHostingControllerIfNeeded()
    }

    /// Removes the bottom edge bar.
    public func removeBottomBar() {
        bottomBarView = nil
        updateHostingControllerIfNeeded()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        scrollView.alpha = 0
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !didSetup else { return }
        didSetup = true

        setupHostingController()
    }

    // MARK: - Private Methods

    private func makeBarContent(_ uiView: UIView?) -> AnyView? {
        guard let uiView else { return nil }
        return AnyView(BarViewWrapper(barView: uiView))
    }

    private func setupHostingController() {
        scrollView.removeFromSuperview()

        let wrapperView = ScrollEdgeBarWrapperView(
            scrollView: scrollView,
            topBarContent: makeBarContent(topBarView),
            bottomBarContent: makeBarContent(bottomBarView)
        )

        let hosting = UIHostingController(rootView: wrapperView)
        hosting.view.backgroundColor = .clear

        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hosting.didMove(toParent: self)
        hostingController = hosting

        hosting.view.layoutIfNeeded()

        // Apply estimated insets immediately so there's no blank frame
        scrollView.contentInset = UIEdgeInsets(top: estimatedTopBarHeight, left: 0, bottom: estimatedBottomBarHeight, right: 0)
        scrollView.verticalScrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPoint(x: 0, y: -estimatedTopBarHeight)
        scrollView.alpha = 1

        // Correct with real insets once SwiftUI has rendered the bars
        DispatchQueue.main.async {
            self.applyInsets()
        }
    }

    private func updateHostingControllerIfNeeded() {
        guard didSetup else { return }

        let wrapperView = ScrollEdgeBarWrapperView(
            scrollView: scrollView,
            topBarContent: makeBarContent(topBarView),
            bottomBarContent: makeBarContent(bottomBarView)
        )

        hostingController?.rootView = wrapperView

        DispatchQueue.main.async {
            self.applyInsets()
        }
    }

    private func applyInsets() {
        let (topInset, bottomInset) = findEdgeBarInsets()

        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -topInset)
    }

    private func findEdgeBarInsets() -> (top: CGFloat, bottom: CGFloat) {
        guard let rootView = navigationController?.view ?? view.window?.rootViewController?.view else {
            return (estimatedTopBarHeight, estimatedBottomBarHeight)
        }

        var topInset: CGFloat = estimatedTopBarHeight
        var bottomInset: CGFloat = estimatedBottomBarHeight

        let screenHeight = view.bounds.height

        findEdgeBarViews(in: rootView) { barView in
            let frameInWindow = barView.convert(barView.bounds, to: nil)

            if frameInWindow.origin.y < screenHeight / 2 {
                topInset = frameInWindow.maxY
            }

            if frameInWindow.maxY > screenHeight / 2 {
                bottomInset = screenHeight - frameInWindow.minY
            }
        }

        return (topInset, bottomInset)
    }

    private func findEdgeBarViews(in view: UIView, handler: (UIView) -> Void) {
        for interaction in view.interactions {
            let className = String(describing: type(of: interaction))
            if className.contains("ScrollPocketBarInteraction") {
                handler(view)
                return
            }
        }

        for subview in view.subviews {
            findEdgeBarViews(in: subview, handler: handler)
        }
    }
}

// MARK: - BarViewWrapper

@available(iOS 26.0, *)
struct BarViewWrapper: UIViewRepresentable {
    let barView: UIView

    func makeUIView(context: Context) -> UIView {
        let container = UIView()

        barView.removeFromSuperview()
        barView.isHidden = false
        barView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(barView)

        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: container.topAnchor),
            barView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            barView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIView.layoutFittingExpandedSize.width
        let size = barView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: width, height: size.height)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
