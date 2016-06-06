//
//  Token.swift
//  gift
//
//  Created by Matan Lachmish on 26/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class Token : ModelBase, NSCoding {
    var accessToken : String?
    var user : User?
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }
    
    required init?(_ map: Map){
        super.init(map)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Mappable
    //-------------------------------------------------------------------------------------------
    override func mapping(map: Map) {
        super.mapping(map)
        
        accessToken <- map["accessToken"]
        user <- map["user"]
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - NSCoding
    //-------------------------------------------------------------------------------------------
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObjectForKey("id") as! String?
        self.createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate?
        self.updatedAt = aDecoder.decodeObjectForKey("updatedAt") as! NSDate?
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
        self.user = aDecoder.decodeObjectForKey("user") as! User?
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.createdAt, forKey: "createdAt")
        aCoder.encodeObject(self.updatedAt, forKey: "updatedAt")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
        aCoder.encodeObject(self.user, forKey: "user")
    }
}