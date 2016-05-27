//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    // Inections
    var appRoute : AppRoute
    var welcomeViewController : WelcomeViewController
    var verificationCodeViewController : VerificationCodeViewController
    var authenticator : Authenticator

    var loginView : LoginView!
    
    var didPresentWelcomeViewController : Bool = false

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          welcomeViewController : WelcomeViewController,
                          verificationCodeViewController : VerificationCodeViewController,
                          authenticator: Authenticator) {
        self.appRoute = appRoute
        self.welcomeViewController = welcomeViewController
        self.verificationCodeViewController = verificationCodeViewController
        self.authenticator = authenticator;
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your phone number"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",style: .Plain, target: self, action: #selector(nextTapped))
        
        self.loginView =  LoginView(frame: self.view!.frame)
        view.addSubview(loginView)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.presentWelcomeViewController()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func presentWelcomeViewController() {
        if (self.didPresentWelcomeViewController) {
            return
        }
        
        self.appRoute.presentController(self.welcomeViewController, animated: true, completion: nil)
        self.didPresentWelcomeViewController = true
    }

    func nextTapped() {
        let phoneNumber = self.loginView.phoneNumber()
        authenticator.verifyPhoneNumber(phoneNumber!, success: {
            print("Verification code sent")
            }) { (error) in
                print(error)
        }
        
        self.verificationCodeViewController.phoneNumber = phoneNumber
        self.appRoute.pushViewController(verificationCodeViewController, animated: true)
    }

}
