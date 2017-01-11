//
// Created by Matan Lachmish on 11/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation

enum ToastFlavor {
    case text
    case video
}

class Toast: ModelBase {
    var userId : String?
    var eventId : String?
    var toastFlavor : ToastFlavor?
    var giftPresenters : String?
    var videoUrl : String?
    var imageUrl : String?
    var text : String?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    init(userId : String?,
         eventId : String?,
         toastFlavor : ToastFlavor?,
         giftPresenters : String?,
         videoUrl : String?,
         imageUrl : String?,
         text : String?,
         id: String?,
         createdAt: Date?,
         updatedAt: Date?) {
        self.userId         = userId
        self.eventId        = eventId
        self.toastFlavor    =  toastFlavor
        self.giftPresenters = giftPresenters
        self.videoUrl       = videoUrl
        self.imageUrl       = imageUrl
        self.text           = text

        super.init(id: id, createdAt: createdAt, updatedAt: updatedAt)
    }

}
