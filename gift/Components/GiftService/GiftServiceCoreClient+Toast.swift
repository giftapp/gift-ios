//
// Created by Matan Lachmish on 04/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient Toast extension
extension GiftServiceCoreClient {

    //-------------------------------------------------------------------------------------------
    // MARK: - Get
    //-------------------------------------------------------------------------------------------
    func getToast(toastId: String,
                  success: @escaping (_ toastDTO: ToastDTO) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/toast" + "/\(toastId)"

        manager.request(urlString, method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let toastDTO = ToastDTO(json: JSON(value))
                        success(toastDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Post
    //-------------------------------------------------------------------------------------------
    func createToast(eventId: String,
                     toastFlavor: String,
                     giftPresenters: String,
                     videoUrl: String?,
                     imageUrl: String?,
                     text: String?,
                     success: @escaping (_ toastDTO : ToastDTO) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/toast/me"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "eventId", value: eventId)
        parameters.addIfNotOptional(key: "toastFlavor", value: toastFlavor)
        parameters.addIfNotOptional(key: "giftPresenters", value: giftPresenters)
        parameters.addIfNotOptional(key: "videoUrl", value: videoUrl)
        parameters.addIfNotOptional(key: "imageUrl", value: imageUrl)
        parameters.addIfNotOptional(key: "text", value: text)

        manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let toastDTO = ToastDTO(json: JSON(value))
                        success(toastDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

}
