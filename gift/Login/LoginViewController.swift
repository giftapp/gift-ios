//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController : UIViewController, LoginViewDelegate {

    var facebookClient : FacebookClient

    var loginView : LoginView!

    // MARK: Lifecycle

    public dynamic init(facebookClient: FacebookClient) {
        self.facebookClient = facebookClient;
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginView =  LoginView(frame: self.view!.frame)
        self.loginView.delegate = self
        view.addSubview(loginView)

    }

    // MARK: LoginViewDelegate

    func didTapLoginWithFacebook() {
        self.facebookClient.login(viewController: self) {(error , facebookToken) in
            if error {
                //Handle error
            } else {
                // Logged login
            }
        }
    }


}
