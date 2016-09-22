//
//  Token.swift
//  gift
//
//  Created by Matan Lachmish on 26/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class Token : ModelBase, NSCoding {
    var accessToken : String?
    var user : User?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        accessToken   = json["accessToken"].string
        user    = User(json: json["user"])

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
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String?
        self.user = aDecoder.decodeObject(forKey: "user") as! User?
    }
    
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.user, forKey: "user")
    }
}
