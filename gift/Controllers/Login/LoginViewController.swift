//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import PMAlertController

class LoginViewController : UIViewController, LoginViewDelegate {

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
        authenticator.verifyPhoneNumber(phoneNumber: phoneNumber, success: {
            Logger.debug("Verification code sent")
            //Prepare & Present verificationCodeViewController
            self.verificationCodeViewController.phoneNumber = phoneNumber
            self.present(self.verificationCodeViewController, animated: true, completion: nil)
        }) { (error) in
            Logger.error("Failed sending verification code: \(error)")
            self.alertFailedSendingVerificationCode()
        }
    }

    private func alertFailedSendingVerificationCode() {
        let alertVC = PMAlertController(title: "LoginViewController.Alert failed sending verification code.Title".localized, description: "LoginViewController.Alert failed sending verification code.Description".localized, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Global.Try again".localized, style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func alertCheckNumberBeforeSendingSendingVerificationCode() {
        //TODO: validate input
        let phoneNumber = self.loginView.phoneNumber

        let alertVC = PMAlertController(title: String.localizedStringWithFormat("LoginViewController.Alert check number before sending verification code.Title".localized, phoneNumber.formateAsPhoneNumber), description: "LoginViewController.Alert check number before sending verification code.Description".localized, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Global.Cancel".localized, style: .cancel, action: nil))
        alertVC.addAction(PMAlertAction(title: "LoginViewController.Send".localized, style: .default, action: { () in
            self.sendPhoneNumberForVerification(phoneNumber: phoneNumber)
        }))

        self.present(alertVC, animated: true, completion: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapContinue() {
        alertCheckNumberBeforeSendingSendingVerificationCode()
    }

}
