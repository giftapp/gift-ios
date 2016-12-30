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
    var isValidPhoneNumber: Bool { //TODO: this is israel only regex decide if we need to generalize this
        let phoneRegEx = "^\\+?(972|0)(\\-)?0?(([23489]{1}\\d{7})|[5]{1}\\d{8})$" //Israel only

        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return predicate.evaluate(with: self)
    }
}
