//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

struct GiftServiceCoreClientConstants{
    static let BASE_URL_PATH = "http://localhost:8080/api"
    static let AUTHORIZATION_KEY = "api_key"
}

public class GiftServiceCoreClient : NSObject {

    var manager : Manager!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()

        self.observeNotification()
    }

    func observeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GiftServiceCoreClient.onSuccessfulLoginEvent(_:)), name: SuccessfullLoginEvent.name, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func onSuccessfulLoginEvent(notification: NSNotification) {
        let successfullLoginEvent = notification.object as! SuccessfullLoginEvent
        setAuthenticationHeader(successfullLoginEvent.token)
    }

    func setAuthenticationHeader(token : String) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
                GiftServiceCoreClientConstants.AUTHORIZATION_KEY: token,
                "Accept": "application/json"
        ]

        self.manager = Alamofire.Manager(configuration: configuration)
        self.allowUnsecureConnection()
    }

    //TODO: remove this once server is over TLS and .plist app transport security
    func allowUnsecureConnection() {
        self.manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?

            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)

                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }

            return (disposition, credential)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Get
    //-------------------------------------------------------------------------------------------
    public func ping() {
        manager.request(.GET, GiftServiceCoreClientConstants.BASE_URL_PATH+"/ping").validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Validation Successful")
                debugPrint(response)
            case .Failure(let error):
                print(error)
            }
        }
    }

    public func getUser() {
        manager.request(.GET, GiftServiceCoreClientConstants.BASE_URL_PATH+"/user/5742f7698d6a39092748fa50").validate().responseObject { (response: Response<User, NSError>) in
            switch response.result {
            case .Success:
                let user = response.result.value
                print(user)
            case .Failure(let error):
                print(error)
            }
        }
    }

}