//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

class VerificationCodeViewController : UIViewController, VerificationCodeViewDelegate {

    private let log = XCGLogger.defaultInstance()

    //Injected
    private var appRoute : AppRoute
    private var authenticator : Authenticator
    var launcher : Launcher //property injected

    //Views
    private var verificationCodeView : VerificationCodeView!

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
    }

    private func addCustomViews() {
        self.verificationCodeView =  VerificationCodeView(frame: self.view!.frame)
        self.verificationCodeView.delegate = self
        view.addSubview(verificationCodeView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.updateCustomViews()
    }

    private func updateCustomViews() {
        self.verificationCodeView.phoneNumber = self.phoneNumber.formateAsPhoneNumber
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------
    // MARK: - VerificationCodeViewDelegate
    //-------------------------------------------------------------------------------------------
    internal func didEnteredVerificationCode(verificationCode: Int) {
        authenticator.authenticate(self.phoneNumber, verificationCode: verificationCode, success: {
            self.log.debug("Successfully logged in")
            self.launcher.launch(nil)
            }) { (error) in
            self.log.error("Failed logging in: \(error)")
        }
    }

    func didTapRetry() {
        self.appRoute.dismiss(self, animated: true, completion: nil)
    }


}
