//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, LoginViewDelegate {

    // Inections
    private var appRoute : AppRoute
    private var verificationCodeViewController : VerificationCodeViewController
    private var authenticator : Authenticator

    //Views
    private var loginView : LoginView!

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
        if loginView == nil {
            loginView = LoginView()
            loginView.delegate = self
            self.view = loginView
        }
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
        let tryAgainAction = AlertViewAction(title: "Global.Try again".localized, style: .cancel, action: nil)
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "LoginViewController.Alert failed sending verification code.Title".localized, description: "LoginViewController.Alert failed sending verification code.Description".localized, image: nil, actions: [tryAgainAction])
        self.present(alertViewController, animated: true, completion: nil)
    }

    private func alertCheckNumberBeforeSendingSendingVerificationCode() {
        //TODO: validate input
        let phoneNumber = self.loginView.phoneNumber
        
        let cancelAction = AlertViewAction(title: "Global.Cancel".localized, style: .cancel, action: nil)
        let sendAction = AlertViewAction(title: "LoginViewController.Send".localized, style: .regular, action: { () in
            self.sendPhoneNumberForVerification(phoneNumber: phoneNumber)
        })
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: String.localizedStringWithFormat("LoginViewController.Alert check number before sending verification code.Title".localized, phoneNumber.formateAsPhoneNumber), description: "LoginViewController.Alert check number before sending verification code.Description".localized, image: nil, actions: [cancelAction, sendAction])

        self.present(alertViewController, animated: true, completion: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapContinue() {
        alertCheckNumberBeforeSendingSendingVerificationCode()
    }

}
