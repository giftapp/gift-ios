//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class Authenticator : NSObject {

    //Injected
    private var giftServiceCoreClient : GiftServiceCoreClient
    private var identity : Identity
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient : GiftServiceCoreClient, identity : Identity) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.identity = identity
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func verifyPhoneNumber(phoneNumber : String,
                           success: @escaping () -> Void,
                           failure: @escaping (_ error: Error) -> Void)  {
        self.giftServiceCoreClient.verifyPhoneNumber(phoneNumber: phoneNumber, success: success, failure: failure)
    }
    
    func authenticate(phoneNumber : String,
                      verificationCode : Int,
                      success: @escaping () -> Void,
                      failure: @escaping (_ error: Error) -> Void)  {
        
        self.giftServiceCoreClient.getToken(phoneNumber: phoneNumber, verificationCode: verificationCode, success: {(token) in
            //Create Identity
            self.identity.setIdentity(user: token.user!, token: token)
            
            success()
            }
, failure: failure)
    }
}
