//
//  Alamofire+NonSecureConnection.swift
//  gift
//
//  Created by Matan Lachmish on 06/06/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

//TODO: remove this once server is over TLS and .plist app transport security

import Foundation
import Alamofire

extension Manager {
    
    func allowUnsecureConnection() {
        self.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = self.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
}