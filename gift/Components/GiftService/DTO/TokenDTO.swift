//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class TokenDTO : DTOBase {
    var accessToken : String?
    var userDTO: UserDTO?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        accessToken     = json["token"]["accessToken"].string
        userDTO = UserDTO(json: json["token"]["user"])

        super.init(json: json)
    }
}
