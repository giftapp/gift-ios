//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class User : ModelBase, NSCoding {
    var firstName : String?
    var lastName : String?
    var email : String?
    var avatarURL : String?
    var needsEdit : Bool?
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        firstName   = json["firstName"].string
        lastName    = json["lastName"].string
        email       = json["email"].string
        avatarURL   = json["avatarURL"].string
        needsEdit   = json["needsEdit"].bool
        
        super.init(json: json)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - NSCoding
    //-------------------------------------------------------------------------------------------
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String?
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! Date?
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! Date?
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as! String?
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as! String?
        self.email = aDecoder.decodeObject(forKey: "email") as! String?
        self.avatarURL = aDecoder.decodeObject(forKey: "avatarURL") as! String?
        self.needsEdit = aDecoder.decodeObject(forKey: "needsEdit") as! Bool?
    }
    
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.avatarURL, forKey: "avatarURL")
        aCoder.encode(self.needsEdit, forKey: "needsEdit")
    }
}
