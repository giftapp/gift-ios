//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookClient : NSObject {

    private let log = XCGLogger.defaultInstance()

    private let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func login(viewController fromViewController: UIViewController, completion: (error: Bool, facebookToken: String?) -> Void) {
        fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: fromViewController) { (result , error) in
            if error != nil {
                // Process error
                self.log.error("Failed to login with facebook")
                completion(error: true, facebookToken: nil)
            } else if (result.isCancelled) {
                // Cancelled
                self.log.debug("Aborted login with facebook")
                completion(error: true, facebookToken: nil)
            } else {
                // Logged in
                self.log.debug("Successfully login with facebook, token is: " + FBSDKAccessToken.currentAccessToken().tokenString)
                completion(error: false, facebookToken: FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
    }
}