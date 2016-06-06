//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class MainTabViewController : UITabBarController{

    //Injections
    private var homeViewController : UIViewController
    private var historyViewController : UIViewController
    private var settingsViewController : UIViewController

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(homeViewController : UIViewController,
                          historyViewController : UIViewController,
                          settingsViewController : UIViewController) {
        self.homeViewController = homeViewController
        self.historyViewController = historyViewController
        self.settingsViewController = settingsViewController

        super.init(nibName: nil, bundle: nil)
        
        self.setup()
        self.setViewControllers([self.getHomeTab(), self.getHistoryTab(), self.getSettingsTab()], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.tabBar.translucent = false
        UINavigationBar.appearance().translucent = false

        //TODO: add observer for badge count
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func getHomeTab() -> UIViewController {
        self.homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeTab")!.imageWithRenderingMode(.AlwaysOriginal), selectedImage:UIImage(named: "homeTabSelected")!.imageWithRenderingMode(.AlwaysOriginal))
        return self.embedInNavigationController(self.homeViewController)
    }

    private func getHistoryTab() -> UIViewController {
        self.historyViewController.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "homeTab")!.imageWithRenderingMode(.AlwaysOriginal), selectedImage:UIImage(named: "homeTabSelected")!.imageWithRenderingMode(.AlwaysOriginal))
        return self.embedInNavigationController(self.historyViewController)
    }

    private func getSettingsTab() -> UIViewController {
        self.settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "homeTab")!.imageWithRenderingMode(.AlwaysOriginal), selectedImage:UIImage(named: "homeTabSelected")!.imageWithRenderingMode(.AlwaysOriginal))
        return self.embedInNavigationController(self.settingsViewController)
    }

    private func embedInNavigationController(controller: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.translucent = false
        return navigationController
    }
}
