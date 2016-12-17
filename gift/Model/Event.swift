//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class Event: ModelBase {
    var date : Date?
    var contact1 : String?
    var contact2 : String?
    var venue : Venue?

    //Computed Properties
    var title: String? {
        return "\(contact1 ?? "") & \(contact2 ?? "")"
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(date: Date?, contact1: String?, contact2: String?, venue: Venue?, id: String?, createdAt: Date?, updatedAt: Date?) {
        self.date = date
        self.contact1 = contact1
        self.contact2 = contact2
        self.venue = venue

        super.init(id: id, createdAt: createdAt, updatedAt: updatedAt)
    }

}
