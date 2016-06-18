//
//  WelcomeView.swift
//  gift
//
//  Created by Matan Lachmish on 26/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

protocol WelcomeViewDelegate{
    func didTapContinue()
}

class WelcomeView : UIView {

    private var backgroundImage : UIImageView!
    private var giftLogoImage : UIImageView!
    private var slogenLabel: UILabel!
    private var continueButton: UIButton!

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
        backgroundImage = UIImageView(image: UIImage(named:"welcomeScreenBackground")!)
        self.addSubview(backgroundImage)

        giftLogoImage = UIImageView(image: UIImage(named:"giftLogoWide")!)
        self.addSubview(giftLogoImage)


        slogenLabel = UILabel()
        slogenLabel.text = "Gift slogen".localized
        slogenLabel.textAlignment = NSTextAlignment.Center
        slogenLabel.font = UIFont.gftHeader1Font()
        slogenLabel.textColor = UIColor.gftWaterBlueColor()
        self.addSubview(slogenLabel)

        continueButton = UIButton()
        continueButton.setTitle("Continue Button".localized, forState: UIControlState.Normal)
        continueButton.titleLabel!.font = UIFont.gftHeader1Font()
        continueButton.setTitleColor(UIColor.gftWhiteColor(), forState: UIControlState.Normal)
        continueButton.backgroundColor = UIColor.gftAzureColor()
        continueButton.addTarget(self, action: #selector(WelcomeView.didTapContinue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(continueButton)
    }

    private func setConstraints() {
        slogenLabel.sizeToFit()

        constrain(backgroundImage, giftLogoImage, slogenLabel, continueButton) { backgroundImage, giftLogoImage, slogenLabel, continueButton in
            backgroundImage.left == backgroundImage.superview!.left
            backgroundImage.top == backgroundImage.superview!.top

            giftLogoImage.centerX == giftLogoImage.superview!.centerX
            giftLogoImage.top == giftLogoImage.superview!.top + 60

            slogenLabel.centerX == slogenLabel.superview!.centerX
            slogenLabel.top == giftLogoImage.bottom + 10

            continueButton.centerX == continueButton.superview!.centerX
            continueButton.top == backgroundImage.bottom
            continueButton.bottom == continueButton.superview!.bottom
            continueButton.left == continueButton.superview!.left
            continueButton.right == continueButton.superview!.right
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    @objc private func didTapContinue(sender:UIButton!) {
        delegate!.didTapContinue()
    }

}
