// ScrollEdgeBarWrapperView.swift
// ScrollEdgeBar
//
// Created by Jens Van Steen
// MIT License

import SwiftUI
import UIKit

struct ScrollEdgeBarWrapperView: View {
    let scrollView: UIScrollView
    let topBarContent: AnyView?
    let bottomBarContent: AnyView?
    let prefersGlassEffect: Bool

    var body: some View {
        let base = ScrollViewWrapper(scrollView: scrollView)
            .ignoresSafeArea(.all)

        applyBars(to: base)
    }

    @ViewBuilder
    private func applyBars<V: View>(to view: V) -> some View {
        if #available(iOS 26, *), prefersGlassEffect {
            applyGlassBars(to: view)
        } else {
            applyInsetBars(to: view)
        }
    }

    // iOS 26+: glass blur bars in the scroll pocket area
    @available(iOS 26, *)
    @ViewBuilder
    private func applyGlassBars<V: View>(to view: V) -> some View {
        switch (topBarContent, bottomBarContent) {
        case let (top?, bottom?):
            view
                .safeAreaBar(edge: .top) { top }
                .safeAreaBar(edge: .bottom) { bottom }
        case let (top?, nil):
            view
                .safeAreaBar(edge: .top) { top }
        case let (nil, bottom?):
            view
                .safeAreaBar(edge: .bottom) { bottom }
        case (nil, nil):
            view
        }
    }

    // iOS 15–25: plain bars using safeAreaInset (no blur)
    @ViewBuilder
    private func applyInsetBars<V: View>(to view: V) -> some View {
        switch (topBarContent, bottomBarContent) {
        case let (top?, bottom?):
            view
                .safeAreaInset(edge: .top, spacing: 0) { top }
                .safeAreaInset(edge: .bottom, spacing: 0) { bottom }
        case let (top?, nil):
            view
                .safeAreaInset(edge: .top, spacing: 0) { top }
        case let (nil, bottom?):
            view
                .safeAreaInset(edge: .bottom, spacing: 0) { bottom }
        case (nil, nil):
            view
        }
    }
}

struct ScrollViewWrapper: UIViewRepresentable {
    let scrollView: UIScrollView

    func makeUIView(context: Context) -> UIView {
        let container = UIView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.isDirectionalLockEnabled = true

        container.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        DispatchQueue.main.async {
            if let contentView = scrollView.subviews.first(where: { !($0 is UIImageView) }) {
                contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
                ])
            }
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
