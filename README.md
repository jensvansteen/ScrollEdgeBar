# ScrollEdgeBar

SwiftUI `safeAreaBar`-based scroll-edge bars, made easy to use from UIKit.

<!-- Add demo GIF or video here -->

---

## Why This Library Exists

As of iOS 26, there is no public UIKit API that allows custom views to blend with the blur of the navigation bar or tab bar. [`UIScrollEdgeElementContainerInteraction`](https://developer.apple.com/documentation/uikit/uiscrolledgeelementcontainerinteraction) exists but does not integrate with the system bar blur — it renders its own separate background, resulting in two distinct blur effects that don't fluently merge.

I originally wanted to bring this effect to React Native, but it wasn't even solved at the UIKit level. By investigating SwiftUI's internals, I found that SwiftUI coordinates between the scroll edge bar and the navigation/tab bar without requiring them to be in the same view hierarchy. Unable to recreate this in pure UIKit, I built this wrapper that bridges through SwiftUI to achieve the effect.

> **Note:** The library locates rendered bar frames by walking the view hierarchy. It does not call any private methods or import private frameworks, but it does rely on an internal implementation detail that could theoretically change in a future iOS release. I will actively monitor for changes, and hope Apple exposes a native UIKit API that makes this library unnecessary.

## Features

- **Seamless glass blur** — extends navigation bar and tab bar Liquid Glass (iOS 26+)
- **Graceful fallback** — uses `safeAreaInset` on iOS 16–25, same layout without the blur
- **Top & bottom bars** — attach a bar to either scroll edge, or both
- **UIKit-native** — works with any `UIScrollView`, `UITableView`, or `UICollectionView`
- **UIView-based content** — pass any `UIView` as bar content
- **Automatic insets** — content insets and scroll indicators managed for you

## Requirements

- iOS 16.0+
- Swift 6.2+
- Xcode 26.0+

## Installation

### Swift Package Manager

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jensvansteen/ScrollEdgeBar.git", from: "1.1.0")
]
```

Or via Xcode: **File → Add Package Dependencies** and enter the repository URL.

### CocoaPods

```ruby
pod 'ScrollEdgeBar', '~> 1.1'
```

## Usage

### Basic Setup

```swift
import ScrollEdgeBar

class MyViewController: UIViewController {

    private let tableView = UITableView()
    private var edgeBarController: ScrollEdgeBarController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up your scroll view as usual
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        // ... constraints, dataSource, etc.

        // Wrap it with ScrollEdgeBarController
        let controller = ScrollEdgeBarController(scrollView: tableView)

        let segmented = UISegmentedControl(items: ["First", "Second"])
        segmented.selectedSegmentIndex = 0
        controller.setTopBar(segmented)

        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        controller.didMove(toParent: self)
        edgeBarController = controller
    }
}
```

### Top and Bottom Bars

```swift
let controller = ScrollEdgeBarController(scrollView: scrollView)

controller.setTopBar(myFilterView)
controller.setBottomBar(myToolbarView)
```

### Removing Bars

```swift
controller.removeTopBar()
controller.removeBottomBar()
```

### Opting Out of Glass Effect

By default, the glass blur effect is used on iOS 26+. Pass `prefersGlassEffect: false` to use plain `safeAreaInset` bars on all OS versions:

```swift
let controller = ScrollEdgeBarController(scrollView: scrollView, prefersGlassEffect: false)
```

### Estimated Heights

Provide estimated bar heights to prevent a brief layout flicker on first appearance:

```swift
controller.estimatedTopBarHeight = 48
controller.estimatedBottomBarHeight = 44
```

## API Reference

| Member | Description |
|---|---|
| `init(scrollView:prefersGlassEffect:)` | Creates a controller wrapping the given scroll view. `prefersGlassEffect` defaults to `true` |
| `scrollView` | The wrapped scroll view (read-only) |
| `prefersGlassEffect` | When `true` (default), uses iOS 26 glass blur if available. Set to `false` for plain bars on all OS versions |
| `setTopBar(_:)` | Sets a `UIView` as the top edge bar |
| `setBottomBar(_:)` | Sets a `UIView` as the bottom edge bar |
| `removeTopBar()` | Removes the top bar |
| `removeBottomBar()` | Removes the bottom bar |
| `estimatedTopBarHeight` | Estimated top bar height used before layout (default: `60`) |
| `estimatedBottomBarHeight` | Estimated bottom bar height used before layout (default: `60`) |

## Examples

The [Example/](Example/) directory contains a full demo app. Open `Example/ScrollEdgeBarExampleApp/ScrollEdgeBarExampleApp.xcodeproj` in Xcode 26 to run it.

### App Store Listing

Segmented control as top bar above a ranked app list.

<video src="https://github.com/user-attachments/assets/0746b2cf-fd4b-43da-9e8e-802b95f6eccb" autoplay loop muted playsinline></video>

### App Store (No Glass)

Same screen with `prefersGlassEffect: false`, showing the plain `safeAreaInset` bar.

<video src="https://github.com/user-attachments/assets/4aa999a4-31f7-45c9-b9d4-0e74799af637" autoplay loop muted playsinline></video>

### Pull Requests

Horizontally scrolling filter chips with large title navigation.

<video src="https://github.com/user-attachments/assets/930b75f7-fdf3-422a-8d0d-231a40cab8d8" autoplay loop muted playsinline></video>

> **Note:** When a `safeAreaBar` is present alongside a large title navigation bar, SwiftUI applies the scroll edge blur effect to the navigation bar even when the content is at rest, causing it to appear blurry on first appearance. This is a known SwiftUI behavior ([FB21613303](https://developer.apple.com/forums/thread/812480)).

### PR Detail

Glass-effect review banner (top) and action buttons (bottom) using `UIGlassEffect`.

<video src="https://github.com/user-attachments/assets/3b1af859-7eb2-4ec3-88ca-b9f24739117f" autoplay loop muted playsinline></video>

### Transition Showcase

Large colored blocks demonstrating how the glass blur color transitions as you scroll.

<video src="https://github.com/user-attachments/assets/22a3e249-69b4-4243-95c3-854c8353db3f" autoplay loop muted playsinline></video>

### Toolbar

Bottom edge bar positioned above the system `UIToolbar`.

<video src="https://github.com/user-attachments/assets/efca03ec-b03b-414b-8138-303756ca6b86" autoplay loop muted playsinline></video>

### Search Bar

`UISearchController` in the navigation bar with a segmented control edge bar below it.

<video src="https://github.com/user-attachments/assets/cca987b5-3f8d-4674-88fa-17dd307f1cc6" autoplay loop muted playsinline></video>

### Calendar

Week day selector top bar with strong edge blur, simulating the Calendar app. The strength of the blur as content scrolls behind the bar is controlled via `UIScrollView.topEdgeEffect`:

```swift
scrollView.topEdgeEffect.style = .automatic // default
scrollView.topEdgeEffect.style = .soft
scrollView.topEdgeEffect.style = .hard      // strongest, matches Calendar app

// Also available for other edges
scrollView.bottomEdgeEffect.style = .hard
```

<video src="https://github.com/user-attachments/assets/6bf1840b-3ab7-443e-b214-8222a12a942b" autoplay loop muted playsinline></video>

## Author

Created by [Jens Van Steen](https://jensvansteen.com) · [GitHub](https://github.com/jensvansteen)

## License

MIT License. See [LICENSE](LICENSE) file.
