//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class Authenticator : NSObject {

    var giftServiceCoreClient : GiftServiceCoreClient
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient : GiftServiceCoreClient) {
        self.giftServiceCoreClient = giftServiceCoreClient
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func verifyPhoneNumber(phoneNumber : String,
                           success: () -> Void,
                           failure: (error: ErrorType) -> Void)  {
        self.giftServiceCoreClient.verifyPhoneNumber(phoneNumber, success: success, failure: failure)
    }
    
    func getToken(phoneNumber : String,
                  verificationCode : Int,
                  success: (token : Token) -> Void,
                  failure: (error: ErrorType) -> Void)  {
        
        self.giftServiceCoreClient.getToken(phoneNumber, verificationCode: verificationCode, success: {(token) in
            //Store in keychain
            
            let successfulLoginEvent = SuccessfullLoginEvent(token: token.accessToken!)
            NSNotificationCenter.defaultCenter().postNotificationName(SuccessfullLoginEvent.name, object: successfulLoginEvent)
            
            success(token: token)
            }
, failure: failure)
    }
}
