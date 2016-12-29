//
// Created by Matan Lachmish on 21/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

extension String {
    var formateAsPhoneNumber: String {
        return self.insert(string: "-", atIndex: 3)
    }
}

extension String {
    func phoneNumberAsRawString() -> String {
        var foramttedString = self
        foramttedString.remove(at: self.characters.index(self.startIndex, offsetBy: 3))
        return foramttedString
    }
}


extension String {
    func insert(string:String,atIndex:Int) -> String {
        return  String(self.characters.prefix(atIndex)) + string + String(self.characters.suffix(self.characters.count-atIndex))
    }
}

extension String {
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"

        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return predicate.evaluate(with: self)
    }
}
