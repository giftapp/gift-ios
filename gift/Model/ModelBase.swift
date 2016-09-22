//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class ModelBase: NSObject {
    var id: String?
    var createdAt: Date?
    var updatedAt: Date?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {}
    
    required init(json: JSON) {
        id          = json["id"].string
        createdAt   = json["createdAt"].date
        updatedAt   = json["updatedAt"].date
    }
}
