//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    // Inections
    var appRoute : AppRoute
    var verificationCodeViewController : VerificationCodeViewController
    var authenticator : Authenticator

    //Views
    var loginView : LoginView!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          verificationCodeViewController : VerificationCodeViewController,
                          authenticator: Authenticator) {
        self.appRoute = appRoute
        self.verificationCodeViewController = verificationCodeViewController
        self.authenticator = authenticator
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your phone number"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",style: .Plain, target: self, action: #selector(nextTapped))
        
        self.loginView =  LoginView(frame: self.view!.frame)
        view.addSubview(loginView)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
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
