    //
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private struct GiftServiceCoreClientConstants{
    static let baseUrlPath = Configuration.sharedInstance.apiEndpoint
    static let authorizationKey = "Authorization"
    static let tokenPrefix = "bearer"

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
    // MARK: - Unauthorized
    //-------------------------------------------------------------------------------------------
    func verifyPhoneNumber(phoneNumber : String,
                           success: @escaping () -> Void,
                           failure: @escaping (_ error: Error) -> Void)  {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/authentication/phoneNumberChallenge"
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
                  verificationCode : String,
                  success: @escaping (_ token : Token) -> Void,
                  failure: @escaping (_ error: Error) -> Void)  {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/authentication/token"
        var parameters = Parameters()
        parameters.addIfNotOptional(key: "phoneNumber", value: phoneNumber)
        parameters.addIfNotOptional(key: "verificationCode", value: verificationCode)

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
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
    
    func uploadImage(image :UIImage,
                      success: @escaping (_ imageUrl : String) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/file"
        let imageData = UIImagePNGRepresentation(image.resizeWith(width: 128)!)!
        
        manager.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")},
                         usingThreshold:UInt64.init(),
                         to:urlString,
                         method:.post,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        let json = JSON(value)
                                        success(json["filePath"].stringValue)
                                    case .failure(let error):
                                        failure(error)
                                    }
                                }
                            case .failure(let encodingError):
                                failure(encodingError)
                            }
        })
        
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
        parameters.addIfNotOptional(key: "avatarURL", value: avatarUrl)

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
