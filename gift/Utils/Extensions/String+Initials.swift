//
// Created by Matan Lachmish on 25/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

extension String {
    var initials: String? {
        let splitStringArray = self.characters.split{$0 == " "}.map(String.init)
        let firstWord: String? = splitStringArray.first
        let lastWord: String? = splitStringArray.count > 1 ? splitStringArray.last : nil
        
        return "\(firstWord?.characters.first?.description ?? "")\(lastWord?.characters.first?.description ?? "")"
    }
}
