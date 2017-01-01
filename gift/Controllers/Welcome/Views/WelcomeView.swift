//
//  WelcomeView.swift
//  gift
//
//  Created by Matan Lachmish on 26/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol WelcomeViewDelegate{
    func didTapContinue()
}

class WelcomeView : UIView {

    //Views
    private var backgroundImage : UIImageView!
    private var giftLogoImage : UIImageView!
    private var slogenLabel: UILabel!
    private var continueButton: UIButton!

    //Public Properties
    var delegate: WelcomeViewDelegate! = nil

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

        if backgroundImage == nil {
            backgroundImage = UIImageView(image: UIImage(named:"welcomeScreenBackground")!)
            self.addSubview(backgroundImage)
        }
       
        if giftLogoImage == nil {
            giftLogoImage = UIImageView(image: UIImage(named:"giftLogoWide")!)
            self.addSubview(giftLogoImage)
        }

        if slogenLabel == nil {
            slogenLabel = UILabel()
            slogenLabel.text = "WelcomeView.Gift slogan".localized
            slogenLabel.textAlignment = NSTextAlignment.center
            slogenLabel.font = UIFont.gftHeader1Font()
            slogenLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(slogenLabel)
        }

        if continueButton == nil {
            continueButton = UIButton()
            continueButton.setTitle("WelcomeView.Continue Button".localized, for: UIControlState())
            continueButton.titleLabel!.font = UIFont.gftHeader1Font()
            continueButton.setTitleColor(UIColor.gftWhiteColor(), for: UIControlState())
            continueButton.backgroundColor = UIColor.gftAzureColor()
            continueButton.addTarget(self, action: #selector(WelcomeView.didTapContinue(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(continueButton)
        }
    }

    private func setConstraints() {
        backgroundImage.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage.superview!)
            make.left.equalTo(backgroundImage.superview!)
        }
        
        giftLogoImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(giftLogoImage.superview!)
            make.top.equalTo(giftLogoImage.superview!).offset(60)
        }
        
        slogenLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(slogenLabel.superview!)
            make.top.equalTo(giftLogoImage.snp.bottom).offset(10)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(continueButton.superview!)
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.bottom.equalTo(continueButton.superview!)
            make.width.equalTo(continueButton.superview!)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - WelcomeViewDelegate
    //-------------------------------------------------------------------------------------------
    @objc private func didTapContinue(sender:UIButton!) {
        delegate!.didTapContinue()
    }

}
