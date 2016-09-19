//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookClient : NSObject {


    private let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func login(viewController fromViewController: UIViewController, completion: @escaping (_ error: Bool, _ facebookToken: String?) -> Void) {
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: fromViewController) { (result , error) in
            if error != nil {
                // Process error
                Logger.error("Failed to login with facebook")
                completion(true, nil)
            } else if (result?.isCancelled)! {
                // Cancelled
                Logger.debug("Aborted login with facebook")
                completion(true, nil)
            } else {
                // Logged in
                Logger.debug("Successfully login with facebook, token is: " + FBSDKAccessToken.current().tokenString)
                completion(false, FBSDKAccessToken.current().tokenString)
            }
        }
    }
}
