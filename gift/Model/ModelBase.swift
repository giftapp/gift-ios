//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelBase : NSObject, Mappable {
    var id: String?
    var createdAt: NSDate?
    var updatedAt: NSDate?

    override init() {}
    
    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- (map["createdAt"], DateTransform())
        updatedAt <- (map["updatedAt"], DateTransform())
    }
}
