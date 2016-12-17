//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class AuthenticationService: NSObject {

    //Injected
    private var giftServiceCoreClient : GiftServiceCoreClient
    private var modelFactory : ModelFactory
    private var identity : Identity

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient : GiftServiceCoreClient, modelFactory : ModelFactory, identity : Identity) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.modelFactory = modelFactory
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
                    let user = self.modelFactory.createUserFrom(userDTO: tokenDTO.userDTO!)
                    let token = self.modelFactory.createTokenFrom(tokenDTO: tokenDTO, user: user)

                    //Create Identity
                    self.identity.setIdentity(user: token.user!, token: token)
                    success()
                }, failure: failure)
    }

}
