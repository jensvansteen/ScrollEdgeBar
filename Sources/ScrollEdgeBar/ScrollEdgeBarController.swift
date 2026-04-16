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
    private var lastTopInset: CGFloat = 0
    private var lastBottomInset: CGFloat = 0
    private var displayLink: CADisplayLink?

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

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopDisplayLink()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didSetup {
            startDisplayLink()
        }
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

        // Apply initial insets immediately so there's no blank frame.
        // Use estimated bar heights when bars are present, otherwise fall back to safe area.
        let initialTop = topBarView != nil ? estimatedTopBarHeight : view.safeAreaInsets.top
        let initialBottom = bottomBarView != nil ? estimatedBottomBarHeight : view.safeAreaInsets.bottom
        scrollView.contentInset = UIEdgeInsets(top: initialTop, left: 0, bottom: initialBottom, right: 0)
        scrollView.verticalScrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPoint(x: 0, y: -initialTop)
        scrollView.alpha = 1

        // Correct with real insets once SwiftUI has rendered the bars
        DispatchQueue.main.async {
            self.applyInsets()
            self.startDisplayLink()
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
        let (topInset, bottomInset) = measureEdgeBarInsets()

        lastTopInset = topInset
        lastBottomInset = bottomInset

        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -topInset)
    }

    private func startDisplayLink() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func displayLinkFired() {
        let (topInset, bottomInset) = measureEdgeBarInsets()

        guard topInset != lastTopInset || bottomInset != lastBottomInset else { return }

        lastTopInset = topInset
        lastBottomInset = bottomInset

        let newInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.scrollView.contentInset = newInsets
            self.scrollView.verticalScrollIndicatorInsets = newInsets
        }
    }

    /// Reads the insets by converting the known bar view frames to window coordinates.
    private func measureEdgeBarInsets() -> (top: CGFloat, bottom: CGFloat) {
        let windowHeight = view.window?.bounds.height ?? view.bounds.height

        let topInset: CGFloat
        if let topBarView {
            if topBarView.window != nil {
                let frame = topBarView.convert(topBarView.bounds, to: nil)
                topInset = frame.maxY > 0 ? frame.maxY : estimatedTopBarHeight
            } else {
                topInset = estimatedTopBarHeight
            }
        } else {
            // No top bar — respect the system safe area so content clears the navigation bar
            topInset = view.safeAreaInsets.top
        }

        let bottomInset: CGFloat
        if let bottomBarView {
            if bottomBarView.window != nil {
                let frame = bottomBarView.convert(bottomBarView.bounds, to: nil)
                bottomInset = frame.minY < windowHeight ? windowHeight - frame.minY : estimatedBottomBarHeight
            } else {
                bottomInset = estimatedBottomBarHeight
            }
        } else {
            // No bottom bar — respect the system safe area so content clears the tab bar / home indicator
            bottomInset = view.safeAreaInsets.bottom
        }

        return (topInset, bottomInset)
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
