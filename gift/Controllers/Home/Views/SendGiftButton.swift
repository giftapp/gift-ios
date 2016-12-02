//
// Created by Matan Lachmish on 02/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class SendGiftButton: UIButton {

    //Views
    private var SendGiftButtonTitleLabel: UILabel!
    private var SendGiftButtonImageView: UIImageView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftWaterBlueColor()
        self.layer.cornerRadius = 10

        if SendGiftButtonTitleLabel == nil {
            SendGiftButtonTitleLabel = UILabel()
            SendGiftButtonTitleLabel.text = "HomeView.Gift button title".localized
            SendGiftButtonTitleLabel.textAlignment = NSTextAlignment.right
            SendGiftButtonTitleLabel.font = UIFont.gftGiveGiftButtonFont()
            SendGiftButtonTitleLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(SendGiftButtonTitleLabel)
        }

        if SendGiftButtonImageView == nil {
            SendGiftButtonImageView = UIImageView(image: UIImage(named:"buttonGiftImage")!)
            self.addSubview(SendGiftButtonImageView)
        }
    }

    private func setConstraints() {
        SendGiftButtonTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(SendGiftButtonTitleLabel.superview!).offset(-28)
            make.centerY.equalTo(SendGiftButtonTitleLabel.superview!)
        }

        SendGiftButtonImageView.snp.makeConstraints { (make) in
            make.left.equalTo(SendGiftButtonImageView.superview!).offset(33)
            make.centerY.equalTo(SendGiftButtonImageView.superview!)
        }
    }
    
}
