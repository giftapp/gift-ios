//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

struct VerificationCodeViewConstants{
    static let VERIFICATION_CODE_DIGITS = 5
}

protocol VerificationCodeViewDelegate{
    func didEnteredVerificationCode(verificationCode : Int)
    func didTapRetry()
}

class VerificationCodeView : UIView, UITextFieldDelegate {

    //Views
    private var inseretPasscodeLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var envelopImage: UIImageView!
    private var verificationCodeTextField : UITextField!
    private var retryButton : UIButton!

    //Public Properties
    var delegate: VerificationCodeViewDelegate! = nil

    //Private Properties
    private var phoneNumber: String!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(frame: CGRect, phoneNumber: String) {
        super.init(frame: frame)
        self.phoneNumber = phoneNumber
        self.addCustomViews()
        self.setConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        inseretPasscodeLabel = UILabel()
        inseretPasscodeLabel.text = "VerificationCodeView.Insert verification code".localized
        inseretPasscodeLabel.textAlignment = NSTextAlignment.Center
        inseretPasscodeLabel.font = UIFont.gftHeader1Font()
        inseretPasscodeLabel.textColor = UIColor.gftWaterBlueColor()
        self.addSubview(inseretPasscodeLabel)

        descriptionLabel = UILabel()
        descriptionLabel.text = String.localizedStringWithFormat("VerificationCodeView.Description".localized ,self.phoneNumber)
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.gftText1Font()
        descriptionLabel.textColor = UIColor.gftBlackColor()
        self.addSubview(descriptionLabel)

        envelopImage = UIImageView(image: UIImage(named:"envelopIcon")!)
        self.addSubview(envelopImage)

        verificationCodeTextField = UITextField()
        verificationCodeTextField.backgroundColor = UIColor.gftWhiteColor()
        verificationCodeTextField.placeholder = "VerificationCodeView.VerificationCode placeholder".localized
        verificationCodeTextField.textAlignment = NSTextAlignment.Center
        verificationCodeTextField.font = UIFont.gftText1Font()
        verificationCodeTextField.keyboardType = UIKeyboardType.NumberPad
        verificationCodeTextField.delegate = self
        self.addSubview(verificationCodeTextField)

        retryButton = UIButton()
        let attributedButtonTitle = NSMutableAttributedString(string: "VerificationCodeView.Retry Button".localized)
        attributedButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributedButtonTitle.length))
        attributedButtonTitle.addAttribute(NSFontAttributeName, value: UIFont.gftLinkFont()!, range: NSMakeRange(0, attributedButtonTitle.length))
        retryButton.setAttributedTitle(attributedButtonTitle, forState: UIControlState.Normal)

        retryButton.addTarget(self, action: #selector(VerificationCodeView.didTapRetry(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(retryButton)
    }
    
    private func setConstraints() {
        constrain(inseretPasscodeLabel, descriptionLabel, envelopImage, verificationCodeTextField, retryButton) { verificationCodeLabel, descriptionLabel, envelopImage, verificationCodeTextField, retryButton in
            verificationCodeLabel.centerX == verificationCodeLabel.superview!.centerX
            verificationCodeLabel.top == verificationCodeLabel.superview!.top + 50

            descriptionLabel.centerX == descriptionLabel.superview!.centerX
            descriptionLabel.top == verificationCodeLabel.bottom + 25

            envelopImage.centerX == envelopImage.superview!.centerX
            envelopImage.top == descriptionLabel.bottom + 40
            
            verificationCodeTextField.centerX == verificationCodeTextField.superview!.centerX
            verificationCodeTextField.top == envelopImage.bottom + 50
            verificationCodeTextField.height == 44
            verificationCodeTextField.left == verificationCodeTextField.superview!.left
            verificationCodeTextField.right == verificationCodeTextField.superview!.right

            retryButton.centerX == retryButton.superview!.centerX
            retryButton.top == verificationCodeTextField.bottom + 20
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapRetry(sender:UIButton!) {
        delegate!.didTapRetry()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (!string.isEmpty && Int(string) == nil) {
            return false
        }
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        // Prevent crashing undo bug
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        if (newLength == VerificationCodeViewConstants.VERIFICATION_CODE_DIGITS) {
            delegate!.didEnteredVerificationCode(Int(textField.text! + string)!)
        }
        
        return newLength <= VerificationCodeViewConstants.VERIFICATION_CODE_DIGITS
    }
    
}
