//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventDTO: DTOBase {
    var date : Date?
    var contact1 : String?
    var contact2 : String?
    var venueId : String?
    var usersId : Array<String>?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        date        = json["date"].date
        contact1    = json["contact1"].string
        contact2    = json["contact2"].string
        venueId     = json["venueId"].string
        usersId     = json["usersId"].arrayValue.map{$0.string!}

        super.init(json: json)
    }
}