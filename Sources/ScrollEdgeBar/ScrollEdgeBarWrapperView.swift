// ScrollEdgeBarWrapperView.swift
// ScrollEdgeBar
//
// Created by Jens Van Steen
// MIT License

import SwiftUI
import UIKit

@available(iOS 26.0, *)
struct ScrollEdgeBarWrapperView: View {
    let scrollView: UIScrollView
    let topBarContent: AnyView?
    let bottomBarContent: AnyView?
    
    var body: some View {
        let base = ScrollViewWrapper(scrollView: scrollView)
            .ignoresSafeArea(.all)
        
        applyBars(to: base)
    }
    
    @ViewBuilder
    private func applyBars<V: View>(to view: V) -> some View {
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
}

@available(iOS 26.0, *)
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
