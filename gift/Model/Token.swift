//
//  Token.swift
//  gift
//
//  Created by Matan Lachmish on 26/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import ObjectMapper

class Token : ModelBase {
    var accessToken : String?
    var user : User?
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        accessToken <- map["accessToken"]
        user <- map["user"]
    }
    
}