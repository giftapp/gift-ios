//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class AuthenticationService: NSObject {

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

        giftServiceCoreClient.verifyPhoneNumber(phoneNumber: phoneNumber, success: success, failure: failure)
    }

    func authenticate(phoneNumber : String,
                      verificationCode : String,
                      success: @escaping () -> Void,
                      failure: @escaping (_ error: Error) -> Void)  {

        giftServiceCoreClient.getToken(phoneNumber: phoneNumber, verificationCode: verificationCode,
                success: { (tokenDTO) in
                    let token = Token(tokenDTO: tokenDTO)
                    //Create Identity
                    self.identity.setIdentity(user: token.user!, token: token)
                    success()
                }, failure: failure)
    }

}