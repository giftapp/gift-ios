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

    private var welcomeLabel: UILabel = UILabel()
    private var continueButton: UIButton = UIButton()

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
        self.backgroundColor = UIColor.grayColor()
        
        welcomeLabel.textAlignment = NSTextAlignment.Center
        welcomeLabel.text = "Welcome to Gift App"
        self.addSubview(welcomeLabel)

        continueButton.setTitle("Continue", forState: UIControlState.Normal)
        continueButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        continueButton.addTarget(self, action: #selector(WelcomeView.didTapContinue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(continueButton)
    }

    private func setConstraints() {
        welcomeLabel.sizeToFit()

        constrain(welcomeLabel, continueButton) { welcomeLabel, continueButton in
            welcomeLabel.centerX == welcomeLabel.superview!.centerX
            welcomeLabel.top == welcomeLabel.superview!.top + 50

            continueButton.centerX == continueButton.superview!.centerX
            continueButton.bottom == continueButton.superview!.bottom - 30
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    @objc private func didTapContinue(sender:UIButton!) {
        delegate!.didTapContinue()
    }

}
