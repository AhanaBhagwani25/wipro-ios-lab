import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let profileNav = UINavigationController(rootViewController: ProfileFormViewController())
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)

        let directoryNav = UINavigationController(rootViewController: UserListViewController())
        directoryNav.tabBarItem = UITabBarItem(title: "Directory", image: UIImage(systemName: "list.bullet"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [profileNav, directoryNav]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
