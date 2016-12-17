//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class Event: ModelBase {
    var date : Date?
    var contact1 : String?
    var contact2 : String?
    var venueId : String?
    var usersId : Array<String>?

    //Computed Properties
    var title: String? {
        return "\(contact1 ?? "") & \(contact2 ?? "")"
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    required init(eventDTO: EventDTO) {
        date        = eventDTO.date
        contact1    = eventDTO.contact1
        contact2    = eventDTO.contact2
        venueId     = eventDTO.venueId
        usersId     = eventDTO.usersId

        super.init(dtoBase: eventDTO)
    }

}