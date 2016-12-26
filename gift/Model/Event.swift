//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class Event: ModelBase {
    var date : Date?
    var contact1FirstName : String?
    var contact1LastName : String?
    var contact2FirstName : String?
    var contact2LastName : String?
    var venue : Venue?

    //Computed Properties
    var title: String? {
        return "\(contact1FirstName ?? "") \(contact1LastName ?? "") & \(contact2FirstName ?? "") \(contact2LastName ?? "")"
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(date: Date?, contact1FirstName: String?, contact1LastName: String?, contact2FirstName: String?, contact2LastName: String?, venue: Venue?, id: String?, createdAt: Date?, updatedAt: Date?) {
        self.date = date
        self.contact1FirstName = contact1FirstName
        self.contact1LastName = contact1LastName
        self.contact2FirstName = contact2FirstName
        self.contact2LastName = contact2LastName
        self.venue = venue

        super.init(id: id, createdAt: createdAt, updatedAt: updatedAt)
    }

}
