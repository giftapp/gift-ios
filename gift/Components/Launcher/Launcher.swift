//
// Created by Matan Lachmish on 27/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class Launcher : NSObject {
    
    //Injected
    private var appRoute : AppRoute
    private var welcomeViewController : WelcomeViewController
    private var loginViewController : LoginViewController
    private var editProfileViewController : EditProfileViewController
    private var mainTabViewController : MainTabViewController
    private var identity : Identity
    
    //Private Properties
    private let userDefaults = UserDefaults.standard
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
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
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func launch(launchOptions: [AnyHashable: Any]? = nil) {

        if (!self.identity.isLoggedIn()) {
            //Show login
            appRoute.showController(controller: self.loginViewController)
        } else {
            //Show main tab
            appRoute.showController(controller: self.mainTabViewController)
            
            //Show edit if needed
            if (self.identity.user!.needsEdit!) {
                appRoute.presentNavigationViewController(controller: editProfileViewController, animated: true)
            }
        }

        //Show welcome if needed
        let didDismissWelcomeViewController = self.userDefaults.bool(forKey: WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController)

        if (!didDismissWelcomeViewController) {
            self.appRoute.presentController(controller: self.welcomeViewController, animated: false, completion: nil)
        }
    }
}
