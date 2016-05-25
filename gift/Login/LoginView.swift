//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

protocol LoginViewDelegate{
    func didTapLoginWithFacebook()
}

class LoginView : UIView {

    private var loginLabel: UILabel = UILabel()
    private var facebookLoginButton: UIButton = UIButton()

    var delegate: LoginViewDelegate! = nil

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCustomViews() {
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.text = "Login"
        self.addSubview(loginLabel)

        facebookLoginButton.setTitle("Login with facebook", forState: UIControlState.Normal)
        facebookLoginButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        facebookLoginButton.addTarget(self, action: #selector(LoginView.facebookLoginButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(facebookLoginButton)
    }

    func setConstraints() {
        loginLabel.sizeToFit()

        constrain(loginLabel, facebookLoginButton) { loginLabel, facebookLoginButton in
            loginLabel.centerX == loginLabel.superview!.centerX
            loginLabel.top == loginLabel.superview!.top + 30

            facebookLoginButton.center == facebookLoginButton.superview!.center
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func facebookLoginButtonTapped(sender:UIButton!) {
        delegate!.didTapLoginWithFacebook()
    }

}
