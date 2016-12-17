    //
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

internal struct GiftServiceCoreClientConstants{
    static let baseUrlPath = Configuration.sharedInstance.apiEndpoint
    static let authorizationKey = "Authorization"
    static let tokenPrefix = "bearer"

}

public class GiftServiceCoreClient: NSObject {

    //Injected
    private var identity : Identity
    
    //Private Properties
    internal var manager : SessionManager!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(identity : Identity) {
        self.identity = identity
        super.init()

        self.observeNotification()
        
        if (self.identity.isLoggedIn()) {
            self.updateAuthenticationHeaderFromIdentity()
        }

        //TODO: remove once have real ssl cert
        Alamofire.SessionManager.default.acceptInvalidSSLCerts()
    }

    func observeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(GiftServiceCoreClient.onIdentityUpdatedEvent(notification:)), name: NSNotification.Name(rawValue: IdentityUpdatedEvent.name), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func onIdentityUpdatedEvent(notification: Notification) {
        self.updateAuthenticationHeaderFromIdentity()
    }
    
    private func updateAuthenticationHeaderFromIdentity() {
        guard let accessToken = self.identity.token?.accessToken
            else {
            Logger.severe("Expected access token")
                return
            }
        
        manager = SessionManager.getManagerWithAuthenticationHeader(header: GiftServiceCoreClientConstants.authorizationKey, token: GiftServiceCoreClientConstants.tokenPrefix + accessToken)

        //TODO: remove once have real ssl cert
        manager.allowUnsecureConnection()
        manager.acceptInvalidSSLCerts()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get
    //-------------------------------------------------------------------------------------------
    func ping() {
        manager.request(GiftServiceCoreClientConstants.baseUrlPath+"/ping", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                debugPrint(response)
            case .failure(let error):
                print(error)
            }
        }
    }

}
