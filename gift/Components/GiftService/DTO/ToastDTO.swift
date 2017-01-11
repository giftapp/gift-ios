//
// Created by Matan Lachmish on 11/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class ToastDTO: DTOBase {
    var userId : String?
    var eventId : String?
    var toastFlavor : String?
    var giftPresenters : String?
    var videoUrl : String?
    var imageUrl : String?
    var text : String?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        userId          = json["userId"].string
        eventId         = json["eventId"].string
        toastFlavor     = json["toastFlavor"].string
        giftPresenters  = json["giftPresenters"].string
        videoUrl        = json["videoUrl"].string
        imageUrl        = json["imageUrl"].string
        text            = json["text"].string

        super.init(json: json)
    }
}