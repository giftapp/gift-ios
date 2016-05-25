//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, LoginViewDelegate {

    var authenticator : Authenticator

    var loginView : LoginView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(authenticator: Authenticator) {
        self.authenticator = authenticator;
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

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapLoginWithFacebook() {
        self.authenticator.login(viewController: self) {(error , accessToekn) in
            if error {
                //Handle error
                return
            }

            // Handle login
            let successfulLoginEvent = SuccessfullLoginEvent(token: accessToekn!)
            NSNotificationCenter.defaultCenter().postNotificationName(SuccessfullLoginEvent.name, object: successfulLoginEvent)
        }
    }


}
