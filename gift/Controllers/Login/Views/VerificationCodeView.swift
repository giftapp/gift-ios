//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private struct VerificationCodeViewConstants{
    static let VERIFICATION_CODE_DIGITS = 5
}

protocol VerificationCodeViewDelegate{
    func didEnteredVerificationCode(verificationCode : String)
    func didTapRetry()
}

class VerificationCodeView : UIView, UITextFieldDelegate {

    //Views
    private var inseretPasscodeLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var envelopImage: UIImageView!
    private var verificationCodeTextField : UITextField!
    private var retryButton : UIButton!
    private var activityIndicatorView: ActivityIndicatorView!

    //Public Properties
    var delegate: VerificationCodeViewDelegate! = nil

    var phoneNumber: String! {
        didSet {
            descriptionLabel.text = String.localizedStringWithFormat("VerificationCodeView.Description".localized ,self.phoneNumber)
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

        if inseretPasscodeLabel == nil {
            inseretPasscodeLabel = UILabel()
            inseretPasscodeLabel.text = "VerificationCodeView.Insert verification code".localized
            inseretPasscodeLabel.textAlignment = NSTextAlignment.center
            inseretPasscodeLabel.font = UIFont.gftHeader1Font()
            inseretPasscodeLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(inseretPasscodeLabel)
        }

        if descriptionLabel == nil {
            //Text of this label is beeing set from self.phoneNumber didSet
            descriptionLabel = UILabel()
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.numberOfLines = 0
            descriptionLabel.font = UIFont.gftText1Font()
            descriptionLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(descriptionLabel)
        }

        if envelopImage == nil {
            envelopImage = UIImageView(image: UIImage(named:"envelopIcon")!)
            self.addSubview(envelopImage)
        }

        if verificationCodeTextField == nil {
            verificationCodeTextField = UITextField()
            verificationCodeTextField.backgroundColor = UIColor.gftWhiteColor()
            verificationCodeTextField.addTopBottomBorders()
            verificationCodeTextField.placeholder = "VerificationCodeView.VerificationCode placeholder".localized
            verificationCodeTextField.textAlignment = NSTextAlignment.center
            verificationCodeTextField.font = UIFont.gftText1Font()
            verificationCodeTextField.keyboardType = UIKeyboardType.numberPad
            verificationCodeTextField.delegate = self
            self.addSubview(verificationCodeTextField)
        }

        if retryButton == nil {
            retryButton = UIButton()
            let attributedButtonTitle = NSMutableAttributedString(string: "VerificationCodeView.Retry Button".localized)
            attributedButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributedButtonTitle.length))
            attributedButtonTitle.addAttribute(NSFontAttributeName, value: UIFont.gftLinkFont()!, range: NSMakeRange(0, attributedButtonTitle.length))
            retryButton.setAttributedTitle(attributedButtonTitle, for: UIControlState())
            
            retryButton.addTarget(self, action: #selector(VerificationCodeView.didTapRetry(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(retryButton)
        }
        
        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            self.addSubview(activityIndicatorView)
        }
    }
    
    private func setConstraints() {
        inseretPasscodeLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(inseretPasscodeLabel.superview!)
            make.width.top.equalTo(inseretPasscodeLabel.superview!).offset(50)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(descriptionLabel.superview!)
            make.top.equalTo(inseretPasscodeLabel.snp.bottom).offset(25)
        }
        
        envelopImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(envelopImage.superview!)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
        }
        
        verificationCodeTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(verificationCodeTextField.superview!)
            make.top.equalTo(envelopImage.snp.bottom).offset(50)
            make.height.equalTo(44)
            make.width.equalTo(verificationCodeTextField.superview!)
        }
        
        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(retryButton.superview!)
            make.top.equalTo(verificationCodeTextField.snp.bottom).offset(20)
        }

        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.size.equalTo(ActivityIndicatorSize.medium)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func clearVerificationCode() {
        self.verificationCodeTextField.text = ""
    }

    func activityAnimation(shouldAnimate: Bool) {
        if shouldAnimate {
            self.isUserInteractionEnabled = false
            activityIndicatorView.startAnimation()
        } else {
            self.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimation()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapRetry(sender:UIButton!) {
        delegate!.didTapRetry()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
            delegate!.didEnteredVerificationCode(verificationCode: textField.text! + string)
        }
        
        return newLength <= VerificationCodeViewConstants.VERIFICATION_CODE_DIGITS
    }
    
}
