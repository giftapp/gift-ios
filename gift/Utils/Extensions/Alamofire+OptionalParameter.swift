//
// Created by Matan Lachmish on 22/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func addIfNotOptional(key: String, value: Any?) {
        if let nonOptionalValue = value {
            self[key as! Key] = nonOptionalValue as? Value
        }
    }
    
}
