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
    var editProfileViewController : EditProfileViewController
    var mainTabViewController : MainTabViewController
    var identity : Identity
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    internal dynamic init(appRoute : AppRoute,
                          welcomeViewController : WelcomeViewController,
                          loginViewController : LoginViewController,
                          editProfileViewController : EditProfileViewController,
                          mainTabViewController : MainTabViewController,
                          identity : Identity) {
        self.appRoute = appRoute
        self.welcomeViewController = welcomeViewController
        self.loginViewController = loginViewController
        self.editProfileViewController = editProfileViewController
        self.mainTabViewController = mainTabViewController
        self.identity = identity
        super.init()
    }
    
    func launch(launchOptions: [NSObject: AnyObject]?) {

        if (!self.identity.isLoggedIn()) {
            //Show login
            let navigationViewController = UINavigationController(rootViewController: self.loginViewController)
            navigationViewController.navigationBar.translucent = false;
            appRoute.showController(navigationViewController)
        } else {
            appRoute.showController(self.mainTabViewController)
            
            //Show edit if needed
            if (self.identity.user.needsEdit!) {
                let navigationViewController = UINavigationController(rootViewController: self.editProfileViewController)
                navigationViewController.navigationBar.translucent = false;
                self.appRoute.presentController(navigationViewController, animated: true, completion: nil)
            }
        }
        
        //Show welcome if needed
        let didDismissWelcomeViewController = self.userDefaults.boolForKey(WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController)
        
        if (!didDismissWelcomeViewController) {
            self.appRoute.presentController(self.welcomeViewController, animated: false, completion: nil)
        }
    }
}
