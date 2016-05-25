//
// Created by Matan Lachmish on 25/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class SuccessfullLoginEvent : NSObject {

    static let name = String(SuccessfullLoginEvent)

    let token : String

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(token : String) {
        self.token = token
    }

}
