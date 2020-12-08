//
//  FancyTabBarController.swift
//  sidebar
//
//  Created by Alex Logan on 08/12/2020.
//

import Foundation
import UIKit

class FancyTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: [UIViewController] = []
        
        for index in 0..<TabBarItem.allCases.count {
            let item = TabBarItem.allCases[index]
            let placeholderViewController = PlaceholderViewController()
            placeholderViewController.content = item.title
            placeholderViewController.tabBarItem = UITabBarItem(title: item.title, image: UIImage(systemName: item.imageName), tag: index)
            viewControllers.append(placeholderViewController)
        }
        
        self.setViewControllers(viewControllers, animated: false)
    }
}
