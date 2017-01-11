//
// Created by Matan Lachmish on 04/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation

class ToastService: NSObject {

    //Injected
    private var giftServiceCoreClient: GiftServiceCoreClient
    private var modelFactory: ModelFactory

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient: GiftServiceCoreClient,
                          modelFactory: ModelFactory) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.modelFactory = modelFactory
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getToast(toastId: String,
                  success: @escaping (_ toast : Toast) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getToast(toastId: toastId,
                success: { (toastDTO) in
                    let toastFlavor = self.toastFlavorFrom(string: toastDTO.toastFlavor!)
                    let toast = self.modelFactory.createToastFrom(toastDTO: toastDTO, toastFlavor: toastFlavor)
                    success(toast)
                }, failure: failure)
    }

    func createToast(eventId: String,
                     toastFlavor: ToastFlavor,
                     giftPresenters: String,
                     videoUrl: String? = nil,
                     imageUrl: String? = nil,
                     text: String? = nil,
                     success: @escaping (_ toast : Toast) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {
        let toastFlavorString = stringFrom(toastFlavor: toastFlavor)
        giftServiceCoreClient.createToast(
                eventId: eventId,
                toastFlavor: toastFlavorString,
                giftPresenters: giftPresenters,
                videoUrl: videoUrl,
                imageUrl: imageUrl,
                text: text,
                success: { (toastDTO) in
                    let toastFlavor = self.toastFlavorFrom(string: toastDTO.toastFlavor!)
                    let toast = self.modelFactory.createToastFrom(toastDTO: toastDTO, toastFlavor: toastFlavor)
                    success(toast)
                }, failure: failure)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func toastFlavorFrom(string: String) -> ToastFlavor {
        var toastFlavor: ToastFlavor
        if string == "text" {
            toastFlavor = .text
        } else {
            toastFlavor = .video
        }
        return toastFlavor
    }
    
    private func stringFrom(toastFlavor: ToastFlavor) -> String {
        switch toastFlavor {
        case .text:
            return "text"
        case .video:
            return "video"
        }
    }
}
