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

    init(id: String?, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
