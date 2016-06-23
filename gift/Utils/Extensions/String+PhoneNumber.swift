//
// Created by Matan Lachmish on 21/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

extension String {
    var formateAsPhoneNumber: String {
        return self.insert("-", atIndex: 3)
    }
}

extension String {
    func phoneNumberAsRawString() -> String {
        var foramttedString = self
        foramttedString.removeAtIndex(self.startIndex.advancedBy(3))
        return foramttedString
    }
}


extension String {
    func insert(string:String,atIndex:Int) -> String {
        return  String(self.characters.prefix(atIndex)) + string + String(self.characters.suffix(self.characters.count-atIndex))
    }
}