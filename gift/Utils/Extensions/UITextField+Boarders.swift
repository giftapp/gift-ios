//
// Created by Matan Lachmish on 19/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

//TODO: fix
extension UITextField {

    func useUnderline() {

        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.gftGreyishColor().CGColor
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    func useUpperline() {

        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.gftGreyishColor().CGColor
        border.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    func useUnderAndUpperline() {
        self.useUnderline()
        self.useUpperline()
    }
}