//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class GiftServiceCoreClient : NSObject {

    var manager : Manager
    let baseURLPath = "http://localhost:8080/api"

    //Mark: Lifecycle
    override init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let headers = [
                "api_key": "EAADK4zYkZAisBAC11tOKZAZCQCTBnSiyZAqkWaXQvZBrvZAlymRSlDRgPATsYLOBrpripup3a91LuXH5HJ7ylufPyzTTGg4Tv1lbMy5gJVhPnD2TWV7kZBlGSZAWzoAdNJLKahWSRaa1PysorWSnultLy1wOUGLFLVwY6ZBRPWCnuOMrPZBXv0INZAslxX7QbTPKqgZD",
                "Accept": "application/json"
        ]
        configuration.HTTPAdditionalHeaders = headers

        self.manager = Alamofire.Manager(configuration: configuration)

        //TODO: remove this once server is over TLS and .plist app transport security
        super.init()

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

    //Mark: GET
    public func ping() {
        manager.request(.GET, self.baseURLPath+"/ping").validate().responseJSON { response in
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
        manager.request(.GET, self.baseURLPath+"/user/5742f7698d6a39092748fa50").validate().responseObject { (response: Response<User, NSError>) in
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