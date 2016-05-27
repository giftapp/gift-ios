//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class VerificationCodeViewController : UIViewController, VerificationCodeViewDelegate {

    //Injected
    var authenticator : Authenticator
    var launcher : Launcher

    var verificationCodeView : VerificationCodeView!

    var phoneNumber : String!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(authenticator: Authenticator, launcher : Launcher) {
        self.authenticator = authenticator;
        self.launcher = launcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Verification Code"
        
        self.verificationCodeView =  VerificationCodeView(frame: self.view!.frame)
        self.verificationCodeView.delegate = self
        view.addSubview(verificationCodeView)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------
    // MARK: - VerificationCodeViewDelegate
    //-------------------------------------------------------------------------------------------
    func didEnteredVerificationCode(verificationCode: Int) {
        authenticator.authenticate(self.phoneNumber, verificationCode: verificationCode, success: {
            print("Successfully logged in")
            self.launcher.launch(nil)
            }) { (error) in
                print(error)
        }
    }
    
}
