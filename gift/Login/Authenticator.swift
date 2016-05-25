//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class Authenticator : NSObject {

    var facebookClient : FacebookClient

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(facebookClient: FacebookClient) {
        self.facebookClient = facebookClient;
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func login(viewController fromViewController: UIViewController, completion: (error: Bool, accessToken: String?) -> Void) {
        self.facebookClient.login(viewController: fromViewController) {(error , facebookToken) in
            completion(error: error, accessToken: facebookToken)
        }
    }
}
