//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class User : ModelBase {
    var firstName : String?
    var lastName : String?
    var email : String?
    var avatarURL : String?

    required init?(_ map: Map){
        super.init(map)
    }

    override func mapping(map: Map) {
        super.mapping(map)

        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        avatarURL <- map["avatarURL"]
    }

}
