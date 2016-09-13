//
// Created by Matan Lachmish on 12/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import XCGLogger

protocol EditProfileViewDelegate {
    func didUpdateForm()
    func didTapLoginWithFaceBook()
    func didTapDone()
}

class EditProfileView: UIView, UITextFieldDelegate {

    private let log = XCGLogger.defaultInstance()

    //Views
    private var descriptionLabel: UILabel!
    private var firstNameTextField: PaddedTextField!
    private var lastNameTextField: PaddedTextField!
    private var emailTextField: PaddedTextField!
    private var loginWithFacebookDescriptionLabel: UILabel!
    private var loginWithFaceBookButton: UIButton!
    private var doneButton: BigButton!

    //Public Properties
    var delegate: EditProfileViewDelegate!

    var firstName: String? {
        return firstNameTextField.text
    }

    var lastName: String? {
        return lastNameTextField.text
    }

    var email: String? {
        return emailTextField.text
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

        if descriptionLabel == nil {
            descriptionLabel = UILabel()
            descriptionLabel.text = "EditProfileViewController.Description text".localized
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = NSTextAlignment.Center
            descriptionLabel.font = UIFont.gftText1Font()
            descriptionLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(descriptionLabel)
        }

        if firstNameTextField == nil {
            firstNameTextField = PaddedTextField()
            firstNameTextField.backgroundColor = UIColor.gftWhiteColor()
            firstNameTextField.placeholder = "EditProfileView.First Name".localized
            firstNameTextField.textAlignment = .Right
            firstNameTextField.font = UIFont.gftText1Font()
            firstNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
            firstNameTextField.delegate = self
            self.addSubview(firstNameTextField)
        }

        if lastNameTextField == nil {
            lastNameTextField = PaddedTextField()
            lastNameTextField.backgroundColor = UIColor.gftWhiteColor()
            lastNameTextField.placeholder = "EditProfileView.Last Name".localized
            lastNameTextField.textAlignment = .Right
            lastNameTextField.font = UIFont.gftText1Font()
            lastNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
            lastNameTextField.delegate = self
            self.addSubview(lastNameTextField)
        }

        if emailTextField == nil {
            emailTextField = PaddedTextField()
            emailTextField.backgroundColor = UIColor.gftWhiteColor()
            emailTextField.placeholder = "EditProfileView.Email address".localized
            emailTextField.textAlignment = .Center
            emailTextField.font = UIFont.gftText1Font()
            emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
            emailTextField.keyboardType = .EmailAddress
            emailTextField.delegate = self
            self.addSubview(emailTextField)
        }

        if loginWithFacebookDescriptionLabel == nil {
            loginWithFacebookDescriptionLabel = UILabel()
            loginWithFacebookDescriptionLabel.text = "EditProfileViewController.Login with facebook description text".localized
            loginWithFacebookDescriptionLabel.numberOfLines = 1
            loginWithFacebookDescriptionLabel.textAlignment = NSTextAlignment.Center
            loginWithFacebookDescriptionLabel.font = UIFont.gftText1Font()
            loginWithFacebookDescriptionLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(loginWithFacebookDescriptionLabel)
        }

        if loginWithFaceBookButton == nil {
            loginWithFaceBookButton = UIButton()

            loginWithFaceBookButton.setTitle("EditProfileViewController.Login with Facebook".localized, forState: UIControlState.Normal)
            loginWithFaceBookButton.titleLabel!.font = UIFont.gftHeader1Font()
            loginWithFaceBookButton.setTitleColor(UIColor.gftWhiteColor(), forState: UIControlState.Normal)

            loginWithFaceBookButton.setImage(UIImage(named:"facebookLogo"), forState: UIControlState.Normal)
            loginWithFaceBookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

            loginWithFaceBookButton.backgroundColor = UIColor.gftFacebookBlueColor()
            loginWithFaceBookButton.addTarget(self, action: #selector(didTapLoginWithFaceBook(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            self.addSubview(self.loginWithFaceBookButton)
        }

        if doneButton == nil {
            doneButton = BigButton()
            doneButton.setTitle("EditProfileViewController.Done Button".localized, forState: UIControlState.Normal)
            doneButton.addTarget(self, action: #selector(didTapDone(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            doneButton.enable(false)
            self.addSubview(doneButton)
        }
    }

    private func setConstraints() {
        constrain(descriptionLabel, firstNameTextField, lastNameTextField, emailTextField) { descriptionText, firstNameTextField, lastNameTextField, emailTextField in

            descriptionText.top == descriptionText.superview!.top + 40
            descriptionText.centerX == descriptionText.superview!.centerX

            firstNameTextField.centerX == firstNameTextField.superview!.centerX
            firstNameTextField.top == descriptionText.bottom + 50
            firstNameTextField.height == 44
            firstNameTextField.left == firstNameTextField.superview!.left
            firstNameTextField.right == firstNameTextField.superview!.right

            lastNameTextField.centerX == lastNameTextField.superview!.centerX
            lastNameTextField.top == firstNameTextField.bottom
            lastNameTextField.height == 44
            lastNameTextField.left == lastNameTextField.superview!.left
            lastNameTextField.right == lastNameTextField.superview!.right

            emailTextField.centerX == emailTextField.superview!.centerX
            emailTextField.top == lastNameTextField.bottom + 55
            emailTextField.height == 44
            emailTextField.left == emailTextField.superview!.left
            emailTextField.right == emailTextField.superview!.right
        }

        constrain(emailTextField, loginWithFacebookDescriptionLabel, loginWithFaceBookButton, doneButton) { emailTextField, loginWithFacebookDescriptionLabel, loginWithFaceBookButton, doneButton in

            loginWithFacebookDescriptionLabel.top == emailTextField.bottom + 55
            loginWithFacebookDescriptionLabel.centerX == loginWithFacebookDescriptionLabel.superview!.centerX

            loginWithFaceBookButton.top == loginWithFacebookDescriptionLabel.bottom + 12
            loginWithFaceBookButton.centerX == loginWithFaceBookButton.superview!.centerX
            loginWithFaceBookButton.height == 44
            loginWithFaceBookButton.left == loginWithFaceBookButton.superview!.left
            loginWithFaceBookButton.right == loginWithFaceBookButton.superview!.right

            doneButton.centerX == doneButton.superview!.centerX
            doneButton.height == 53
            doneButton.bottom == doneButton.superview!.bottom
            doneButton.left == doneButton.superview!.left
            doneButton.right == doneButton.superview!.right
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func enableDoneButton(enabled: Bool) {
        doneButton.enable(enabled)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func didTapLoginWithFaceBook(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                log.error("Delegate not set")
                return
            }

        delegate.didTapLoginWithFaceBook()
    }

    func didTapDone(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                log.error("Delegate not set")
                return
            }

        delegate.didTapDone()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Update delegate
        delegate.didUpdateForm()

        return true
    }
}
