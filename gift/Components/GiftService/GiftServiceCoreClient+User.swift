//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient User extension
extension GiftServiceCoreClient {

    //-------------------------------------------------------------------------------------------
    // MARK: - Get
    //-------------------------------------------------------------------------------------------
    func getMe(success: @escaping (_ userDTO : UserDTO) -> Void,
               failure: @escaping (_ error: Error) -> Void) {

        manager.request(GiftServiceCoreClientConstants.baseUrlPath+"/user/", method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let userDTO = UserDTO(json: JSON(value))
                        success(userDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Post
    //-------------------------------------------------------------------------------------------
    func setFacebookAccount(facebookAccessToken :String,
                            success: @escaping (_ userDTO : UserDTO) -> Void,
                            failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/user/facebook"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "facebookAccessToken", value: facebookAccessToken)

        manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let userDTO = UserDTO(json: JSON(value))
                        success(userDTO)
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
                           success: @escaping (_ userDTO : UserDTO) -> Void,
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
                        let userDTO = UserDTO(json: JSON(value))
                        success(userDTO)
                    case .failure(let error):
                        Logger.error("Failed to update user profile \(error)")
                        failure(error)
                    }
                }
    }

}
