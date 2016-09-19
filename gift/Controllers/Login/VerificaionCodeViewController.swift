//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import PMAlertController

class VerificationCodeViewController : UIViewController, VerificationCodeViewDelegate {

    //Injected
    private var appRoute : AppRoute
    private var authenticator : Authenticator
    var launcher : Launcher //Property injected

    //Views
    private var verificationCodeView : VerificationCodeView!
    private var activityIndicatorView: ActivityIndicatorView!

    //Public properties
    var phoneNumber : String!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute, authenticator: Authenticator, launcher : Launcher) {
        self.appRoute = appRoute
        self.authenticator = authenticator
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
        self.setConstraints()
    }

    private func addCustomViews() {
        self.verificationCodeView = VerificationCodeView(frame: self.view!.frame)
        self.verificationCodeView.delegate = self
        view.addSubview(verificationCodeView)

        self.activityIndicatorView = ActivityIndicatorView()
        view.addSubview(activityIndicatorView)
    }

    private func setConstraints() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.width.equalTo(ActivityIndicatorSize.Medium)
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
        let alertVC = PMAlertController(title: "VerificationCodeViewController.Alert failed verifying code.Title".localized, description: "", image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Global.Try again".localized, style: .cancel, action: nil))
        self.present(alertVC, animated: true, completion: { () in
            self.verificationCodeView.clearVerificationCode()
        })
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - VerificationCodeViewDelegate
    //-------------------------------------------------------------------------------------------
    internal func didEnteredVerificationCode(verificationCode: Int) {
        activityIndicatorView.startAnimation()

        authenticator.authenticate(phoneNumber: self.phoneNumber, verificationCode: verificationCode, success: {
            Logger.debug("Successfully logged in")
            self.activityIndicatorView.stopAnimation()
            self.launcher.launch()
            }) { (error) in
            Logger.error("Failed logging in: \(error)")
            self.activityIndicatorView.stopAnimation()
            self.alertFailedVerifyingCode()
        }
    }

    func didTapRetry() {
        self.appRoute.dismiss(controller: self, animated: true, completion: nil)
    }


}
