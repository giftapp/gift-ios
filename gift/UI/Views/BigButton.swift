//
// Created by Matan Lachmish on 12/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class BigButton: UIButton {

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel!.font = UIFont.gftHeader1Font()
        self.setTitleColor(UIColor.gftWhiteColor(), for: UIControlState())
        self.backgroundColor = UIColor.gftAzureColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func enable(enabled: Bool) {
        if (enabled) {
            self.isEnabled = true
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.alpha = 1
            },
                           completion: nil)
        } else {
            self.isEnabled = false
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.alpha = 0.5
            },
                           completion: nil)
        }
    }
}
