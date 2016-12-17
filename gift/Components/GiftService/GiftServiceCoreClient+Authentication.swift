//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient Authentication extension
extension GiftServiceCoreClient {

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
                  success: @escaping (_ tokenDTO : TokenDTO) -> Void,
                  failure: @escaping (_ error: Error) -> Void)  {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/authentication/token"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "phoneNumber", value: phoneNumber)
        parameters.addIfNotOptional(key: "verificationCode", value: verificationCode)

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let tokenDTO = TokenDTO(json: JSON(value))
                        success(tokenDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

}
