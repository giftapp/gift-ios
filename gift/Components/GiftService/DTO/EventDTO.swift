//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventDTO: DTOBase {
    var date : Date?
    var contact1FirstName : String?
    var contact1LastName : String?
    var contact2FirstName : String?
    var contact2LastName : String?
    var venueId : String?
    var usersId : Array<String>?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        date                = json["date"].date
        contact1FirstName   = json["contact1FirstName"].string
        contact1LastName    = json["contact1LastName"].string
        contact2FirstName   = json["contact2FirstName"].string
        contact2LastName    = json["contact2LastName"].string
        venueId             = json["venueId"].string
        usersId             = json["usersId"].arrayValue.map{$0.string!}

        super.init(json: json)
    }
}