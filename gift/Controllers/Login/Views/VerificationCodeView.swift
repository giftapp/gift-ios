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
}

class VerificationCodeView : UIView, UITextFieldDelegate {
    
    private var verificationCodeLabel: UILabel = UILabel()
    private var verificationCodeTextField : UITextField = UITextField()
    
    var delegate: VerificationCodeViewDelegate! = nil
    
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
        
        verificationCodeLabel.textAlignment = NSTextAlignment.Center
        verificationCodeLabel.text = "We have sent you an SMS with a verification code."
        self.addSubview(verificationCodeLabel)
        
        verificationCodeTextField.placeholder = "12345"
        verificationCodeTextField.keyboardType = UIKeyboardType.NumberPad
        verificationCodeTextField.delegate = self
        self.addSubview(verificationCodeTextField)
    }
    
    private func setConstraints() {
        verificationCodeLabel.sizeToFit()
        verificationCodeTextField.sizeToFit()
        
        constrain(verificationCodeLabel, verificationCodeTextField) { verificationCodeLabel, verificationCodeTextField in
            verificationCodeLabel.centerX == verificationCodeLabel.superview!.centerX
            verificationCodeLabel.top == verificationCodeLabel.superview!.top + 30
            
            verificationCodeTextField.center == verificationCodeTextField.superview!.center
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - private
    //-------------------------------------------------------------------------------------------
    
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
