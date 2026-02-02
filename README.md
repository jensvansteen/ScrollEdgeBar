# ScrollEdgeBar

SwiftUI safeAreaBar-based scroll-edge bars, made easy to use from UIKit (iOS 26+).

## Why This Library Exists

As of iOS 26, there is no public UIKit API that allows custom views to blend with the blur of the navigation bar or tab bar. [`UIScrollEdgeElementContainerInteraction`](https://developer.apple.com/documentation/uikit/uiscrolledgeelementcontainerinteraction) exists but does not integrate with the system bar blur. It renders its own separate background, resulting in two distinct blur effects that don't fluently merge.

I originally wanted to bring this effect to React Native (see [react-native-scroll-edge-bar](link)), but it wasn't even solved at the UIKit level. By investigating the internal workings of SwiftUI, I discovered that SwiftUI uses a private `ScrollPocketBarInteraction` to coordinate between the scroll edge bar and the navigation/bottom bar without requiring them to be in the same view hierarchy. Unable to recreate this coordination in pure UIKit, I built this wrapper that bridges through SwiftUI to achieve the effect.

**Caveat:** The library relies on finding this private interaction class to measure bar frames and set scroll view insets. It only searches for and measures these views; it does not invoke any private API. This means it could break in a future iOS release. I will actively monitor for changes and update accordingly, and I'm hoping Apple will expose a native UIKit API in a future version, making this library unnecessary.

## Overview

ScrollEdgeBar uses SwiftUI's `safeAreaBar` to create top and bottom scroll-edge bars that extend the system navigation and tab bar glass blur — wrapped for effortless use in UIKit.

### Features

- **Seamless glass blur** — Extends navigation bar / tab bar Liquid Glass
- **Top & bottom bars** — Attach bars to either scroll edge
- **UIKit integration** — Works with any `UIScrollView`, `UITableView`, or `UICollectionView`
- **UIView-based** — Pass any `UIView` as bar content
- **Automatic insets** — Handles content insets and scroll indicators

## Requirements

- iOS 26.0+
- Swift 6.2+
- Xcode 26.0+

## Installation

### Swift Package Manager

Add ScrollEdgeBar to your project:

1. File → Add Package Dependencies
2. Enter the repository URL

Or add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jensvansteen/ScrollEdgeBar.git", from: "1.0.0")
]
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

        // Create the edge bar controller
        let controller = ScrollEdgeBarController(scrollView: tableView)

        // Set a top bar
        let segmented = UISegmentedControl(items: ["First", "Second"])
        segmented.selectedSegmentIndex = 0
        controller.setTopBar(segmented)

        // Add as child view controller
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

// Top bar
controller.setTopBar(myFilterView)

// Bottom bar
controller.setBottomBar(myToolbarView)
```

### Removing Bars

```swift
controller.removeTopBar()
controller.removeBottomBar()
```

### Estimated Heights

To prevent layout flicker on first appearance, you can provide estimated bar heights:

```swift
controller.estimatedTopBarHeight = 48
controller.estimatedBottomBarHeight = 44
```

## API Reference

### ScrollEdgeBarController

| Method / Property | Description |
|---|---|
| `init(scrollView:)` | Creates a controller wrapping the given scroll view |
| `setTopBar(_:)` | Sets a `UIView` as the top edge bar |
| `setBottomBar(_:)` | Sets a `UIView` as the bottom edge bar |
| `removeTopBar()` | Removes the top bar |
| `removeBottomBar()` | Removes the bottom bar |
| `estimatedTopBarHeight` | Estimated top bar height (default: 60) |
| `estimatedBottomBarHeight` | Estimated bottom bar height (default: 60) |
| `scrollView` | The wrapped scroll view (read-only) |

## Example App

The [Example/](Example/) directory contains a full demo app showcasing different use cases:

| Screen | Description |
|---|---|
| **App Store Listing** | Segmented control as top bar above a ranked app list |
| **Pull Requests** | Horizontally scrolling filter chips with large title navigation |
| **PR Detail** | Glass-effect review banner (top) and glass action buttons (bottom) using `UIGlassEffect` |
| **Transition Showcase** | Large colored blocks demonstrating navigation bar glass color transitions |
| **Toolbar** | Bottom edge bar positioned above the system `UIToolbar` |
| **Search Bar** | `UISearchController` in the navigation bar with a segmented control edge bar below |
| **Tab Accessory** | `UITabAccessory` bottom accessory combined with a top edge bar |
| **Calendar** | Week day selector top bar with strong edge blur, simulating the Calendar app |

To run the example, open `Example/ScrollEdgeBarExampleApp/ScrollEdgeBarExampleApp.xcodeproj` in Xcode 26.

## Author

Created by [Jens Van Steen](https://jensvansteen.com) · [GitHub](https://github.com/jensvansteen)

## License

MIT License. See [LICENSE](LICENSE) file.
