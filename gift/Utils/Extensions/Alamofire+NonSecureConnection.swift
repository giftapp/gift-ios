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

extension SessionManager {
    
    func allowUnsecureConnection() {
        self.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }

    func acceptInvalidSSLCerts() {
        print("trying to accept invalid certs")

        self.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?

            print("received challenge")

            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)

                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }

            return (disposition, credential)
        }
    }
}
