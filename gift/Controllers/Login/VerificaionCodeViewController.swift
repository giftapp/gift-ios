//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class VerificationCodeViewController : UIViewController, VerificationCodeViewDelegate {

    //Injected
    private var appRoute : AppRoute
    private var authenticationService : AuthenticationService
    var launcher : Launcher //Property injected

    //Views
    private var verificationCodeView : VerificationCodeView!

    //Public properties
    var phoneNumber : String!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute, authenticationService: AuthenticationService, launcher : Launcher) {
        self.appRoute = appRoute
        self.authenticationService = authenticationService
        self.launcher = launcher
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
        self.hideKeyboardWhenTappedAround()
    }

    private func addCustomViews() {
        if verificationCodeView == nil {
            verificationCodeView = VerificationCodeView()
            verificationCodeView.delegate = self
            self.view = verificationCodeView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateCustomViews()
    }

    private func updateCustomViews() {
        self.verificationCodeView.phoneNumber = self.phoneNumber.formateAsPhoneNumber
        self.verificationCodeView.clearVerificationCode()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func alertFailedVerifyingCode() {
        let tryAgainAction = AlertViewAction(title: "Global.Try again".localized, style: .cancel, action: nil)
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "VerificationCodeViewController.Alert failed verifying code.Title".localized, description: "", image: nil, actions: [tryAgainAction])
        self.present(alertViewController, animated: true, completion: { () in
            self.verificationCodeView.clearVerificationCode()
        })
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - VerificationCodeViewDelegate
    //-------------------------------------------------------------------------------------------
    internal func didEnteredVerificationCode(verificationCode: String) {
        verificationCodeView.activityAnimation(shouldAnimate: true)

        authenticationService.authenticate(phoneNumber: self.phoneNumber, verificationCode: verificationCode, success: {
            Logger.debug("Successfully logged in")
            self.verificationCodeView.activityAnimation(shouldAnimate: false)
            self.launcher.launch()
            }) { (error) in
            Logger.error("Failed logging in: \(error)")
            self.verificationCodeView.activityAnimation(shouldAnimate: false)
            self.alertFailedVerifyingCode()
        }
    }

    func didTapRetry() {
        self.appRoute.dismiss(controller: self, animated: true, completion: nil)
    }


}
