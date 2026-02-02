import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: ViewController())
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: "Demos", image: UIImage(systemName: "list.bullet"), tag: 0)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [nav]
        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }
}
