//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class ModelBase: NSObject {
    var id: String?
    var createdAt: Date?
    var updatedAt: Date?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
    }
    
    init(dtoBase: DTOBase) {
        id          = dtoBase.id
        createdAt   = dtoBase.createdAt
        updatedAt   = dtoBase.updatedAt
    }
    
}
