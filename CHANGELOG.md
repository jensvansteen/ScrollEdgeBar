# Changelog

## 1.1.0

### Changed
- `ScrollEdgeBarController` is now `open` to allow subclassing
- `setTopBar(_:)`, `setBottomBar(_:)`, `removeTopBar()`, `removeBottomBar()`, and lifecycle overrides are now `open`
- `makeBarContent(for:)` is now `open` so subclasses can provide custom SwiftUI bar content

### Fixed
- On iOS 26, explicitly registers the scroll view with the parent view controller via `setContentScrollView(_:for:)` to ensure correct navigation bar scroll tracking in custom containment hierarchies

## 1.0.0

### Added
- `ScrollEdgeBarController` — wraps any `UIScrollView` with sticky top and/or bottom bars
- iOS 26+: bars use the system glass blur effect via `safeAreaBar`, seamlessly extending the navigation bar or tab bar
- iOS 16–25: bars are displayed using `safeAreaInset` (same layout, no blur effect)
- `prefersGlassEffect` initializer parameter (default `true`) to opt out of the glass blur effect on iOS 26 and use plain bars instead
- `setTopBar(_:)`, `setBottomBar(_:)`, `removeTopBar()`, `removeBottomBar()` public API
- `estimatedTopBarHeight` / `estimatedBottomBarHeight` to prevent flicker before layout
- SPM and CocoaPods support
