//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDTO : DTOBase {
    var firstName : String?
    var lastName : String?
    var phoneNumber : String?
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
        phoneNumber = json["phoneNumber"].string
        email       = json["email"].string
        avatarURL   = json["avatarURL"].string
        needsEdit   = json["needsEdit"].bool

        super.init(json: json)
    }
}

