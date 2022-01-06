//
//  SceneDelegate.swift
//  keyboardMoveUpViewsTemplate
//
//  Created by Giovanne Bressam on 19/12/21.
//

import UIKit

// iOS system resources: https://developer.apple.com/design/resources/
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let mainScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: mainScene)
        
        // Tab bar
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        tabBarController.tabBar.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        tabBarController.tabBar.isTranslucent = false
	        
        // Controllers
        let normalVC = NormalViewController()
        normalVC.tabBarItem = UITabBarItem(title: "Normal", image: UIImage(systemName: "clear.fill"), tag: 0)
        let inheritingBaseVC = InheritingBaseViewController()
        inheritingBaseVC.tabBarItem = UITabBarItem(title: "Keyboard Extension", image: UIImage(systemName: "shift.fill"), tag: 1)
        
        // Append
        tabBarController.viewControllers = [normalVC, inheritingBaseVC]
        tabBarController.selectedIndex = 0
        
        //Show window
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

