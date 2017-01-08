//
// Created by Matan Lachmish on 06/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation

class FileService: NSObject {

    //Injected
    private var giftServiceCoreClient: GiftServiceCoreClient

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient: GiftServiceCoreClient) {
        self.giftServiceCoreClient = giftServiceCoreClient
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func uploadImage(imageData :Data,
                     success: @escaping (_ imageUrl : String) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.uploadImage(imageData: imageData, success: success, failure: failure)
    }

    func uploadVideo(videoData :Data,
                          success: @escaping (_ videoUrl : String) -> Void,
                          failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.uploadVideo(videoData: videoData, success: success, failure: failure)
    }

}
