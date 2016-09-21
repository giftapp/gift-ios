//
// Created by Matan Lachmish on 19/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {

    func addTopBorder() {
        let border = UIView()
        self.addSubview(border)
        border.backgroundColor = UIColor.gftSaperatorColor()
        border.snp.makeConstraints { (make) in
            make.top.equalTo(border.superview!)
            make.left.equalTo(border.superview!)
            make.width.equalTo(border.superview!)
            make.height.equalTo(0.5)
        }
    }
    
    func addBottomBorder() {
        let border = UIView()
        self.addSubview(border)
        border.backgroundColor = UIColor.gftSaperatorColor()
        border.snp.makeConstraints { (make) in
            make.bottom.equalTo(border.superview!)
            make.left.equalTo(border.superview!)
            make.width.equalTo(border.superview!)
            make.height.equalTo(0.5)
        }
    }

    func addTopBottomBorders() {
        addTopBorder()
        addBottomBorder()
    }
}
