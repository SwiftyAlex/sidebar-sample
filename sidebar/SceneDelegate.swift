//
//  SceneDelegate.swift
//  sidebar
//
//  Created by Alex Logan on 08/12/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let splitViewController = UISplitViewController(style: .doubleColumn)
    let listViewController = FancyListViewController()
    var secondaryViewController: UIViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Make a window
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Configure the plitViewController
        splitViewController.view.backgroundColor = .clear
        splitViewController.primaryBackgroundStyle = .sidebar
        
        // Setup the list delegate
        self.listViewController.delegate = self
        
        // Populate the split view
        splitViewController.setViewController(listViewController, for: .primary)
        splitViewController.setViewController(viewController(for: .listenNow), for: .secondary)
        splitViewController.setViewController(FancyTabBarController(), for: .compact)
        
        // Show it
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
        }
        #endif
    }
    
    func viewController(for itemIdentifier: FancyListItemIdentifier) -> UIViewController {
        let secondaryViewController = PlaceholderViewController()
        secondaryViewController.content = "\(itemIdentifier)"
        self.secondaryViewController = secondaryViewController
        return UINavigationController(rootViewController: secondaryViewController)
    }
}

extension SceneDelegate: FancyListViewControllerDelegate {
    func fancyListViewControllerDidSelectItem(_ vc: FancyListViewController, itemIdentifier: FancyListItemIdentifier) {
        self.secondaryViewController = viewController(for: itemIdentifier)
        self.splitViewController.setViewController(secondaryViewController, for: .secondary)
    }
}
