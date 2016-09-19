//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelBase : NSObject, Mappable {
    var id: String?
    var createdAt: Date?
    var updatedAt: Date?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {}
    
    required init?(map: Map) {
        
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Mappable
    //-------------------------------------------------------------------------------------------
    func mapping(map: Map) {
        id          <- map["id"]
        createdAt   <- (map["createdAt"], DateTransform())
        updatedAt   <- (map["updatedAt"], DateTransform())
    }
}
