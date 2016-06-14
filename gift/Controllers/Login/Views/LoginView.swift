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

class LoginView : UIView, UITextFieldDelegate {

    private var loginLabel: UILabel = UILabel()
    private var phoneNumberTextField : UITextField = UITextField()

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
        self.backgroundColor = UIColor.whiteColor()
        
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.text = "Please insert your phone number".localized
        self.addSubview(loginLabel)
        
        phoneNumberTextField.placeholder = "XXX-XXX-XXXX"
        phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        phoneNumberTextField.delegate = self
        self.addSubview(phoneNumberTextField)
        
    }

    private func setConstraints() {
        loginLabel.sizeToFit()

        constrain(loginLabel, phoneNumberTextField) { loginLabel, phoneNumberTextField in
            loginLabel.centerX == loginLabel.superview!.centerX
            loginLabel.top == loginLabel.superview!.top + 30

            phoneNumberTextField.center == phoneNumberTextField.superview!.center
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func phoneNumber() -> String? {
        return self.phoneNumberTextField.text
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