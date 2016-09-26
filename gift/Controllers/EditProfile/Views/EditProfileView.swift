//
// Created by Matan Lachmish on 12/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol EditProfileViewDelegate {
    func didUpdateForm()
    func didTapLoginWithFaceBook()
    func didTapDone()
}

class EditProfileView: UIView, UITextFieldDelegate {

    //Views
    private var firstNameTextField: PaddedTextField!
    private var lastNameTextField: PaddedTextField!
    private var emailTextField: PaddedTextField!
    private var loginWithFacebookDescriptionLabel: UILabel!
    private var loginWithFaceBookButton: UIButton!
    private var doneButton: BigButton!
    private var activityIndicatorView: ActivityIndicatorView!

    private var avatarView: UIView

    //Public Properties
    var delegate: EditProfileViewDelegate!

    var firstName: String? {
        get {
            return firstNameTextField.text
        }
        set {
            firstNameTextField.text = newValue
        }
    }

    var lastName: String? {
        get {
            return lastNameTextField.text
        }
        set {
            lastNameTextField.text = newValue
        }
    }

    var email: String? {
        get {
            return emailTextField.text
        }
        set {
            emailTextField.text = newValue
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(avatarView: UIView) {
        self.avatarView = avatarView
        super.init(frame: CGRect.zero)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        self.addSubview(avatarView)

        if firstNameTextField == nil {
            firstNameTextField = PaddedTextField()
            firstNameTextField.backgroundColor = UIColor.gftWhiteColor()
            firstNameTextField.addTopBorder()
            firstNameTextField.placeholder = "EditProfileView.First Name".localized
            firstNameTextField.textAlignment = .right
            firstNameTextField.font = UIFont.gftText1Font()
            firstNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            firstNameTextField.delegate = self
            self.addSubview(firstNameTextField)
        }

        if lastNameTextField == nil {
            lastNameTextField = PaddedTextField()
            lastNameTextField.backgroundColor = UIColor.gftWhiteColor()
            lastNameTextField.addTopBorder(padded: true)
            lastNameTextField.placeholder = "EditProfileView.Last Name".localized
            lastNameTextField.textAlignment = .right
            lastNameTextField.font = UIFont.gftText1Font()
            lastNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            lastNameTextField.delegate = self
            self.addSubview(lastNameTextField)
        }

        if emailTextField == nil {
            emailTextField = PaddedTextField()
            emailTextField.backgroundColor = UIColor.gftWhiteColor()
            emailTextField.addTopBorder(padded: true)
            emailTextField.addBottomBorder()
            emailTextField.placeholder = "EditProfileView.Email address".localized
            emailTextField.textAlignment = .right
            emailTextField.font = UIFont.gftText1Font()
            emailTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            emailTextField.keyboardType = .emailAddress
            emailTextField.delegate = self
            self.addSubview(emailTextField)
        }

        if loginWithFacebookDescriptionLabel == nil {
            loginWithFacebookDescriptionLabel = UILabel()
            loginWithFacebookDescriptionLabel.text = "EditProfileViewController.Login with facebook description text".localized
            loginWithFacebookDescriptionLabel.numberOfLines = 1
            loginWithFacebookDescriptionLabel.textAlignment = NSTextAlignment.center
            loginWithFacebookDescriptionLabel.font = UIFont.gftText1Font()
            loginWithFacebookDescriptionLabel.textColor = UIColor.gftWarmGreyColor()
            self.addSubview(loginWithFacebookDescriptionLabel)
        }

        if loginWithFaceBookButton == nil {
            loginWithFaceBookButton = UIButton()

            loginWithFaceBookButton.setTitle("EditProfileViewController.Login with Facebook".localized, for: UIControlState())
            loginWithFaceBookButton.titleLabel!.font = UIFont.gftHeader1Font()
            loginWithFaceBookButton.setTitleColor(UIColor.gftFacebookBlueColor(), for: UIControlState())

            loginWithFaceBookButton.setImage(UIImage(named:"facebookLogo"), for: UIControlState())
            loginWithFaceBookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

            loginWithFaceBookButton.backgroundColor = UIColor.gftWhiteColor()
            loginWithFaceBookButton.addTopBottomBorders()
            loginWithFaceBookButton.addTarget(self, action: #selector(didTapLoginWithFaceBook(sender:)), for: UIControlEvents.touchUpInside)

            self.addSubview(self.loginWithFaceBookButton)
        }

        if doneButton == nil {
            doneButton = BigButton()
            doneButton.setTitle("EditProfileViewController.Done Button".localized, for: UIControlState())
            doneButton.addTarget(self, action: #selector(didTapDone(sender:)), for: UIControlEvents.touchUpInside)
            doneButton.enable(enabled: false)
            self.addSubview(doneButton)
        }
        
        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            self.addSubview(activityIndicatorView)
        }
    }

    private func setConstraints() {
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.superview!).offset(20)
            make.centerX.equalTo(avatarView.superview!)
            make.size.equalTo(110)
        }

        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.centerX.equalTo(firstNameTextField.superview!)
            make.height.equalTo(44)
            make.width.equalTo(firstNameTextField.superview!)
        }

        lastNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameTextField.snp.bottom)
            make.centerX.equalTo(lastNameTextField.superview!)
            make.height.equalTo(44)
            make.width.equalTo(lastNameTextField.superview!)
        }

        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lastNameTextField.snp.bottom)
            make.centerX.equalTo(emailTextField.superview!)
            make.height.equalTo(44)
            make.width.equalTo(emailTextField.superview!)
        }

        loginWithFacebookDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(60)
            make.centerX.equalTo(loginWithFacebookDescriptionLabel.superview!)
        }

        loginWithFaceBookButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginWithFacebookDescriptionLabel.snp.bottom).offset(12)
            make.centerX.equalTo(loginWithFaceBookButton.superview!)
            make.height.equalTo(44)
            make.width.equalTo(loginWithFaceBookButton.superview!)
        }

        doneButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(doneButton.superview!)
            make.height.equalTo(53)
            make.bottom.equalTo(doneButton.superview!)
            make.width.equalTo(doneButton.superview!)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.size.equalTo(ActivityIndicatorSize.medium)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func enableDoneButton(enabled: Bool) {
        doneButton.enable(enabled: enabled)
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
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func didTapLoginWithFaceBook(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                Logger.error("Delegate not set")
                return
            }

        delegate.didTapLoginWithFaceBook()
    }

    func didTapDone(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                Logger.error("Delegate not set")
                return
            }

        delegate.didTapDone()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Update delegate
        delegate.didUpdateForm()

        return true
    }
}
