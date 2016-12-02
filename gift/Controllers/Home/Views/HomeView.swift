//
// Created by Matan Lachmish on 02/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol HomeViewDelegate{
    func didTapSendGift()
}

class HomeView: UIView {

    //Views
    private var headerImage: UIImageView!
    private var giftTextualLogoImage: UIImageView!
    private var giftSloganLabel: UILabel!
    private var welcomeLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var sendGiftButton: SendGiftButton!

    //Public Properties
    var delegate: HomeViewDelegate!

    var welcomeText: String? {
        didSet {
            welcomeLabel.text = welcomeText
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

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
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        if headerImage == nil {
            headerImage = UIImageView(image: UIImage(named:"homeBackground")!)
            self.addSubview(headerImage)
        }

        if giftTextualLogoImage == nil {
            giftTextualLogoImage = UIImageView(image: UIImage(named:"giftLogoTextual")!)
            self.addSubview(giftTextualLogoImage)
        }

        if giftSloganLabel == nil {
            giftSloganLabel = UILabel()
            giftSloganLabel.text = "HomeView.Slogan".localized
            giftSloganLabel.textAlignment = NSTextAlignment.center
            giftSloganLabel.font = UIFont.gftHeader1Font()
            giftSloganLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(giftSloganLabel)
        }

        if welcomeLabel == nil {
            welcomeLabel = UILabel()
            welcomeLabel.textAlignment = NSTextAlignment.center
            welcomeLabel.font = UIFont.gftHeader1Font()
            welcomeLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(welcomeLabel)
        }

        if descriptionLabel == nil {
            descriptionLabel = UILabel()
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.font = UIFont.gftHeader2Font()
            descriptionLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(descriptionLabel)
        }

        if sendGiftButton == nil {
            sendGiftButton = SendGiftButton()
            sendGiftButton.addTarget(self, action: #selector(HomeView.didTapSendGift(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(sendGiftButton)
        }
    }

    private func setConstraints() {
        giftTextualLogoImage.snp.makeConstraints { (make) in
            make.top.equalTo(giftTextualLogoImage.superview!).offset(35)
            make.centerX.equalTo(giftTextualLogoImage.superview!)
        }

        giftSloganLabel.snp.makeConstraints { (make) in
            make.top.equalTo(giftTextualLogoImage.snp.bottom).offset(10)
            make.centerX.equalTo(giftSloganLabel.superview!)
        }

        headerImage.snp.makeConstraints { (make) in
            make.top.equalTo(headerImage.superview!)
            make.centerX.equalTo(headerImage.superview!)
        }

        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImage.snp.bottom).offset(42)
            make.centerX.equalTo(welcomeLabel.superview!)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(40)
            make.centerX.equalTo(descriptionLabel.superview!)
        }

        sendGiftButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.centerX.equalTo(sendGiftButton.superview!)
            make.height.equalTo(50)
            make.width.equalTo(215)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapSendGift(sender:UIButton!) {
        delegate!.didTapSendGift()
    }
}
