//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class UserService: NSObject {

    //Injected
    private var giftServiceCoreClient: GiftServiceCoreClient
    private var modelFactory: ModelFactory

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient: GiftServiceCoreClient,
                          modelFactory: ModelFactory) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.modelFactory = modelFactory
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getMe(success: @escaping (_ user : User) -> Void,
               failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getMe(success: { (userDTO) in
            let user = self.modelFactory.createUserFrom(userDTO: userDTO)
            success(user)
        }, failure: failure)
    }

    func setFacebookAccount(facebookAccessToken :String,
                            success: @escaping (_ user : User) -> Void,
                            failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.setFacebookAccount(facebookAccessToken: facebookAccessToken,
                success: { (userDTO) in
                    let user = self.modelFactory.createUserFrom(userDTO: userDTO)
                    success(user)
                }, failure: failure)
    }

    func uploadImage(image :UIImage,
                     success: @escaping (_ imageUrl : String) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.uploadImage(image: image, success: success, failure: failure)
    }

    func updateUserProfile(firstName: String?,
                           lastName: String?,
                           email: String?,
                           avatarUrl: String?,
                           success: @escaping (_ user : User) -> Void,
                           failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.updateUserProfile(firstName: firstName, lastName: lastName, email: email, avatarUrl: avatarUrl,
                success: { (userDTO) in
                    let user = self.modelFactory.createUserFrom(userDTO: userDTO)
                    success(user)
                }, failure: failure)
    }

}
