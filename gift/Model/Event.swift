//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event: ModelBase, NSCoding {
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

    //-------------------------------------------------------------------------------------------
    // MARK: - NSCoding
    //-------------------------------------------------------------------------------------------
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id             = aDecoder.decodeObject(forKey: "id") as! String?
        self.createdAt      = aDecoder.decodeObject(forKey: "createdAt") as! Date?
        self.updatedAt      = aDecoder.decodeObject(forKey: "updatedAt") as! Date?

        self.date           = aDecoder.decodeObject(forKey: "firstName") as! Date?
        self.contact1       = aDecoder.decodeObject(forKey: "contact1") as! String?
        self.contact2       = aDecoder.decodeObject(forKey: "contact2") as! String?
        self.venueId        = aDecoder.decodeObject(forKey: "venueId") as! String?
        self.usersId        = aDecoder.decodeObject(forKey: "usersId") as! Array?
    }

    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")

        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.contact1, forKey: "contact1")
        aCoder.encode(self.contact2, forKey: "contact2")
        aCoder.encode(self.venueId, forKey: "venueId")
        aCoder.encode(self.usersId, forKey: "usersId")
    }
}
