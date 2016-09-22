//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private struct GiftServiceCoreClientConstants{
    static let baseUrlPath = "http://localhost:8080/api"
    static let authorizationKey = "api_key"
}

public class GiftServiceCoreClient : NSObject {

    //Injected
    private var identity : Identity
    
    //Private Properties
    private var manager : SessionManager!

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
        
        self.manager = SessionManager.getManagerWithAuthenticationHeader(header: GiftServiceCoreClientConstants.authorizationKey, token: accessToken)
        
        self.manager.allowUnsecureConnection()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Unauthorized
    //-------------------------------------------------------------------------------------------
    func verifyPhoneNumber(phoneNumber : String,
                           success: @escaping () -> Void,
                           failure: @escaping (_ error: Error) -> Void)  {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/authorize/phoneNumberChallenge"
        var parameters = Parameters()
        parameters.addIfNotOptional(key: "phoneNumber", value: phoneNumber)

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in
            switch response.result {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getToken(phoneNumber : String,
                  verificationCode : Int,
                  success: @escaping (_ token : Token) -> Void,
                  failure: @escaping (_ error: Error) -> Void)  {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/authorize/token"
        var parameters = Parameters()
        parameters.addIfNotOptional(key: "phoneNumber", value: phoneNumber)
        parameters.addIfNotOptional(key: "verificationCode", value: verificationCode)

        Alamofire.request(urlString, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let token = Token(json: JSON(value))
                success(token)
            case .failure(let error):
                failure(error)
            }
        }
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

    func getMe(success: @escaping (_ user : User) -> Void,
               failure: @escaping (_ error: Error) -> Void) {
        manager.request(GiftServiceCoreClientConstants.baseUrlPath+"/user/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let user = User(json: JSON(value))
                success(user)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Post
    //-------------------------------------------------------------------------------------------
    func setFacebookAccount(facebookAccessToken :String,
                            success: @escaping (_ user : User) -> Void,
                            failure: @escaping (_ error: Error) -> Void) {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/user/facebook"
        var parameters = Parameters()
        parameters.addIfNotOptional(key: "facebookAccessToken", value: facebookAccessToken)

        manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let user = User(json: JSON(value))
                success(user)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Put
    //-------------------------------------------------------------------------------------------
    func updateUserProfile(firstName: String?,
                           lastName: String?,
                           email: String?,
                           avatarUrl: String?,
                            success: @escaping (_ user : User) -> Void,
                            failure: @escaping (_ error: Error) -> Void) {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/user"
        var parameters = Parameters()
        parameters.addIfNotOptional(key: "firstName", value: firstName)
        parameters.addIfNotOptional(key: "lastName", value: lastName)
        parameters.addIfNotOptional(key: "email", value: email)
        parameters.addIfNotOptional(key: "avatarUrl", value: avatarUrl)

        manager.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                Logger.debug("Successfully updated user profile")
                let user = User(json: JSON(value))
                success(user)
            case .failure(let error):
                Logger.error("Failed to update user profile \(error)")
                failure(error)
            }
        }
    }

}
