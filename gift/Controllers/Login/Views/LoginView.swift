//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

struct LoginViewConstants{
    static let PHONE_NUMBER_DIGITS = 10
}

protocol LoginViewDelegate{
    func didTapContinue()
}

class LoginView : UIView, UITextFieldDelegate {

    //Views
    private var giftTextualLogoImage: UIImageView!
    private var welcomeLabel: UILabel!
    private var boxesImage : UIImageView!
    private var phoneNumberTextField : UITextField!
    private var phoneNumberDisclaimerLabel: UILabel!
    private var continueButton: UIButton!

    //Vars
    var delegate: LoginViewDelegate! = nil
    private var continueButtonConstraintsGroup: ConstraintGroup!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.observerNotifications()
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func observerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        giftTextualLogoImage = UIImageView(image: UIImage(named:"giftLogoTextual")!)
        self.addSubview(giftTextualLogoImage)

        welcomeLabel = UILabel()
        welcomeLabel.text = "LoginView.Welcome".localized
        welcomeLabel.textAlignment = NSTextAlignment.Center
        welcomeLabel.font = UIFont.gftHeader1Font()
        welcomeLabel.textColor = UIColor.gftWaterBlueColor()
        self.addSubview(welcomeLabel)

        boxesImage = UIImageView(image: UIImage(named:"boxesIcon")!)
        self.addSubview(boxesImage)

        phoneNumberTextField = UITextField()
        phoneNumberTextField.backgroundColor = UIColor.gftWhiteColor()
        phoneNumberTextField.placeholder = "LoginView.Phone number place holder".localized
        phoneNumberTextField.textAlignment = NSTextAlignment.Center
        phoneNumberTextField.font = UIFont.gftText1Font()
        phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        phoneNumberTextField.delegate = self
        self.addSubview(phoneNumberTextField)

        phoneNumberDisclaimerLabel = UILabel()
        phoneNumberDisclaimerLabel.text = "LoginView.Phone number disclaimer".localized
        phoneNumberDisclaimerLabel.textAlignment = NSTextAlignment.Center
        phoneNumberDisclaimerLabel.numberOfLines = 0
        phoneNumberDisclaimerLabel.font = UIFont.gftText1Font()
        phoneNumberDisclaimerLabel.textColor = UIColor.gftBlackColor()
        self.addSubview(phoneNumberDisclaimerLabel)

        continueButton = UIButton()
        continueButton.setTitle("LoginView.Continue Button".localized, forState: UIControlState.Normal)
        continueButton.titleLabel!.font = UIFont.gftHeader1Font()
        continueButton.setTitleColor(UIColor.gftWhiteColor(), forState: UIControlState.Normal)
        continueButton.backgroundColor = UIColor.gftAzureColor()
        continueButton.addTarget(self, action: #selector(LoginView.didTapContinue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(continueButton)
    }

    private func setConstraints() {
        constrain(giftTextualLogoImage, welcomeLabel, boxesImage, phoneNumberTextField, phoneNumberDisclaimerLabel) { giftTextualLogoImage, welcomeLabel, boxesImage, phoneNumberTextField, phoneNumberDisclaimerLabel in
            giftTextualLogoImage.centerX == giftTextualLogoImage.superview!.centerX
            giftTextualLogoImage.top == giftTextualLogoImage.superview!.top + 35

            welcomeLabel.centerX == welcomeLabel.superview!.centerX
            welcomeLabel.top == giftTextualLogoImage.bottom + 10

            boxesImage.centerX == boxesImage.superview!.centerX
            boxesImage.top == welcomeLabel.bottom + 25

            phoneNumberTextField.centerX == phoneNumberTextField.superview!.centerX
            phoneNumberTextField.top == boxesImage.bottom + 20
            phoneNumberTextField.height == 44
            phoneNumberTextField.left == phoneNumberTextField.superview!.left
            phoneNumberTextField.right == phoneNumberTextField.superview!.right

            phoneNumberDisclaimerLabel.centerX == phoneNumberDisclaimerLabel.superview!.centerX
            phoneNumberDisclaimerLabel.top == phoneNumberTextField.bottom + 10
        }

        self.continueButtonConstraintsGroup = constrain(continueButton) { continueButton in
            continueButton.centerX == continueButton.superview!.centerX
            continueButton.height == 53
            continueButton.bottom == continueButton.superview!.bottom
            continueButton.left == continueButton.superview!.left
            continueButton.right == continueButton.superview!.right
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - NSNotificationCenter
    //-------------------------------------------------------------------------------------------
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        constrain(continueButton, replace: self.continueButtonConstraintsGroup) { continueButton in
            continueButton.centerX == continueButton.superview!.centerX
            continueButton.height == 53
            continueButton.bottom == continueButton.superview!.bottom - keyboardFrame.size.height
            continueButton.left == continueButton.superview!.left
            continueButton.right == continueButton.superview!.right
        }

        UIView.animateWithDuration(1.0, animations: continueButton.layoutIfNeeded)
    }

    func keyboardWillHide(notification: NSNotification) {
        constrain(continueButton, replace: self.continueButtonConstraintsGroup) { continueButton in
            continueButton.centerX == continueButton.superview!.centerX
            continueButton.height == 53
            continueButton.bottom == continueButton.superview!.bottom
            continueButton.left == continueButton.superview!.left
            continueButton.right == continueButton.superview!.right
        }

        UIView.animateWithDuration(1.0, animations: continueButton.layoutIfNeeded)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func phoneNumber() -> String? {
        return self.phoneNumberTextField.text
    }

    func focus() {
        self.phoneNumberTextField.becomeFirstResponder()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapContinue(sender:UIButton!) {
        delegate!.didTapContinue()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        // Prevent crashing undo bug
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= LoginViewConstants.PHONE_NUMBER_DIGITS
    }
}