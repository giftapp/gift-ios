//
// Created by Matan Lachmish on 27/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class Launcher : NSObject {
    
    //Injected
    var appRoute : AppRoute
    var welcomeViewController : WelcomeViewController
    var loginViewController : LoginViewController
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    internal dynamic init(appRoute : AppRoute,
                          welcomeViewController : WelcomeViewController,
                          loginViewController : LoginViewController) {
        self.appRoute = appRoute
        self.welcomeViewController = welcomeViewController
        self.loginViewController = loginViewController
        super.init()
    }
    
    func launch(launchOptions: [NSObject: AnyObject]?) {
        
        //Show login
        let navigationViewController = UINavigationController(rootViewController: self.loginViewController)
        navigationViewController.navigationBar.translucent = false;
        appRoute.showController(navigationViewController)
        
        //Show welcome if needed
        let didDismissWelcomeViewController = self.userDefaults.boolForKey(WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController)
        
        if (!didDismissWelcomeViewController) {
            self.appRoute.presentController(self.welcomeViewController, animated: false, completion: nil)
            self.userDefaults.setBool(true, forKey: WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController)
        }
    }
}
