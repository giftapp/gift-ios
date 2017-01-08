//
// Created by Matan Lachmish on 06/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient File extension
extension GiftServiceCoreClient {

    //-------------------------------------------------------------------------------------------
    // MARK: - Post
    //-------------------------------------------------------------------------------------------
    func uploadImage(imageData :Data,
                     success: @escaping (_ imageUrl : String) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {
        
        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/file/image"
        
        manager.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")},
                       usingThreshold:UInt64.init(),
                       to:urlString,
                       method:.post,
                       encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseData { response in
                                switch response.result {
                                case .success:
                                    let resourceURI = response.response?.allHeaderFields["Location"] as! String
                                    success(resourceURI)
                                case .failure(let error):
                                    failure(error)
                                }
                            }
                        case .failure(let encodingError):
                            failure(encodingError)
                        }
        })
        
    }

    func uploadVideo(videoData :Data,
                     success: @escaping (_ videoUrl : String) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/file/video"

        manager.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(videoData, withName: "file", fileName: "video.mov", mimeType: "video/mov")},
                usingThreshold:UInt64.init(),
                to:urlString,
                method:.post,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseData { response in
                            switch response.result {
                            case .success:
                                let resourceURI = response.response?.allHeaderFields["Location"] as! String
                                success(resourceURI)
                            case .failure(let error):
                                failure(error)
                            }
                        }
                    case .failure(let encodingError):
                        failure(encodingError)
                    }
                })

    }

}
