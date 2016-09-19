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
        self.tabBar.isTranslucent = false
        UINavigationBar.appearance().isTranslucent = false

        //TODO: add observer for badge count
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func getHomeTab() -> UIViewController {
        self.homeViewController.tabBarItem = UITabBarItem(title: "MainTabViewController.Main Tab".localized, image: UIImage(named: "giftTabIcon")!.withRenderingMode(.alwaysOriginal), selectedImage:UIImage(named: "giftTabIconActive")!.withRenderingMode(.alwaysOriginal))
        return self.homeViewController
    }

    private func getHistoryTab() -> UIViewController {
        self.historyViewController.tabBarItem = UITabBarItem(title: "MainTabViewController.History Tab".localized, image: UIImage(named: "historyTabIcon")!.withRenderingMode(.alwaysOriginal), selectedImage:UIImage(named: "historyTabIconActive")!.withRenderingMode(.alwaysOriginal))
        return self.embedInNavigationController(controller: self.historyViewController)
    }

    private func getSettingsTab() -> UIViewController {
        self.settingsViewController.tabBarItem = UITabBarItem(title: "MainTabViewController.Settings Tab".localized, image: UIImage(named: "profileTabIcon")!.withRenderingMode(.alwaysOriginal), selectedImage:UIImage(named: "profileTabIconActive")!.withRenderingMode(.alwaysOriginal))
        return self.embedInNavigationController(controller: self.settingsViewController)
    }

    private func embedInNavigationController(controller: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}
