//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import PMAlertController

class LoginViewController : UIViewController, LoginViewDelegate {

    private let log = XCGLogger.defaultInstance()

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

        self.addCustomViews()
    }

    private func addCustomViews() {
        self.loginView =  LoginView(frame: self.view!.frame)
        self.loginView.delegate = self
        view.addSubview(loginView)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func sendPhoneNumberForVerification(phoneNumber : String) {
        authenticator.verifyPhoneNumber(phoneNumber, success: {
            self.log.debug("Verification code sent")
        }) { (error) in
            self.log.error("Failed sending verification code: \(error)")
        }
    }

    private func alertSendingVerificationCode() {
        //TODO: validate input
        let phoneNumber = self.loginView.phoneNumber

        let alertVC = PMAlertController(title: String.localizedStringWithFormat("LoginViewController.Alert verification code.Title".localized, phoneNumber.formateAsPhoneNumber), description: "LoginViewController.Alert verification code.Description".localized, image: nil, style: .Alert)
        alertVC.addAction(PMAlertAction(title: "Global.Cancel".localized, style: .Cancel, action: nil))
        alertVC.addAction(PMAlertAction(title: "LoginViewController.Send".localized, style: .Default, action: { () in
            self.sendPhoneNumberForVerification(phoneNumber)

            //Prepare & Present verificationCodeViewController
            self.verificationCodeViewController.phoneNumber = phoneNumber
            self.appRoute.presentController(self.verificationCodeViewController, animated: true, completion:nil)
        }))

        self.presentViewController(alertVC, animated: true, completion: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapContinue() {
        alertSendingVerificationCode()
    }

}
