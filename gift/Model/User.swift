//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class User : ModelBase, NSCoding {
    var firstName : String?
    var lastName : String?
    var email : String?
    var avatarURL : String?
    var needsEdit : Bool?

    override init() {
        super.init()
    }
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)

        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        avatarURL <- map["avatarURL"]
        needsEdit <- map["needsEdit"]
    }

    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObjectForKey("id") as! String?
        self.createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate?
        self.updatedAt = aDecoder.decodeObjectForKey("updatedAt") as! NSDate?
        self.firstName = aDecoder.decodeObjectForKey("firstName") as! String?
        self.lastName = aDecoder.decodeObjectForKey("lastName") as! String?
        self.email = aDecoder.decodeObjectForKey("email") as! String?
        self.avatarURL = aDecoder.decodeObjectForKey("avatarURL") as! String?
        self.needsEdit = aDecoder.decodeObjectForKey("needsEdit") as! Bool?
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.createdAt, forKey: "createdAt")
        aCoder.encodeObject(self.updatedAt, forKey: "updatedAt")
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.avatarURL, forKey: "avatarURL")
        aCoder.encodeObject(self.needsEdit, forKey: "needsEdit")
    }
}
