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

class EditProfileView: UIView {

    //Views
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    var firstNameTextField: AnimatedTextField!
    var lastNameTextField: AnimatedTextField!
    var emailTextField: AnimatedTextField!

    private var loginWithFacebookDescriptionLabel: UILabel!
    private var loginWithFaceBookButton: UIButton!

    private var doneButton: BigButton!

    private var activityIndicatorView: ActivityIndicatorView!

    //Injected
    private var avatarView: UIView

    //Public Properties
    var delegate: EditProfileViewDelegate!

    var textFieldDelegate: UITextFieldDelegate! {
        didSet {
            firstNameTextField.delegate = self.textFieldDelegate
            lastNameTextField.delegate = self.textFieldDelegate
            emailTextField.delegate = self.textFieldDelegate
        }
    }

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
        self.observerNotifications()
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func observerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name:Notification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name:Notification.Name.UIKeyboardWillHide, object: nil);
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        if scrollView == nil {
            scrollView = UIScrollView()
            self.addSubview(scrollView)
        }

        if contentView == nil {
            contentView = UIView()
            scrollView.addSubview(contentView)
        }

        contentView.addSubview(avatarView)

        if firstNameTextField == nil {
            firstNameTextField = AnimatedTextField()
            firstNameTextField.addTopBorder()
            firstNameTextField.addBottomBorder(padded: true)
            firstNameTextField.placeholder = "EditProfileView.First Name".localized
            firstNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            firstNameTextField.inputValidators = [.isNotEmpty]
            contentView.addSubview(firstNameTextField)
        }

        if lastNameTextField == nil {
            lastNameTextField = AnimatedTextField()
            lastNameTextField.addBottomBorder(padded: true)
            lastNameTextField.placeholder = "EditProfileView.Last Name".localized
            lastNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            lastNameTextField.inputValidators = [.isNotEmpty]
            contentView.addSubview(lastNameTextField)
        }

        if emailTextField == nil {
            emailTextField = AnimatedTextField()
            emailTextField.addBottomBorder(padded: false)
            emailTextField.placeholder = "EditProfileView.Email address".localized
            emailTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            emailTextField.keyboardType = .emailAddress
            emailTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            emailTextField.inputValidators = [.isNotEmpty, .isValidEmail]
            contentView.addSubview(emailTextField)
        }

        if loginWithFacebookDescriptionLabel == nil {
            loginWithFacebookDescriptionLabel = UILabel()
            loginWithFacebookDescriptionLabel.text = "EditProfileViewController.Login with facebook description text".localized
            loginWithFacebookDescriptionLabel.numberOfLines = 1
            loginWithFacebookDescriptionLabel.textAlignment = NSTextAlignment.center
            loginWithFacebookDescriptionLabel.font = UIFont.gftText1Font()
            loginWithFacebookDescriptionLabel.textColor = UIColor.gftWarmGreyColor()
            contentView.addSubview(loginWithFacebookDescriptionLabel)
        }

        if loginWithFaceBookButton == nil {
            loginWithFaceBookButton = UIButton()

            loginWithFaceBookButton.setTitle("EditProfileViewController.Login with Facebook".localized, for: .normal)
            loginWithFaceBookButton.titleLabel!.font = UIFont.gftHeader1Font()
            loginWithFaceBookButton.setTitleColor(UIColor.gftFacebookBlueColor(), for: .normal)

            loginWithFaceBookButton.setImage(UIImage(named:"facebookLogo"), for: .normal)
            loginWithFaceBookButton.setImage(UIImage(named:"facebookLogo"), for: .highlighted)
            loginWithFaceBookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

            loginWithFaceBookButton.backgroundColor = UIColor.gftWhiteColor()
            loginWithFaceBookButton.addTopBottomBorders()
            loginWithFaceBookButton.addTarget(self, action: #selector(didTapLoginWithFaceBook(sender:)), for: UIControlEvents.touchUpInside)

            contentView.addSubview(self.loginWithFaceBookButton)
        }

        if doneButton == nil {
            doneButton = BigButton()
            doneButton.setTitle("EditProfileViewController.Done Button".localized, for: UIControlState())
            doneButton.addTarget(self, action: #selector(didTapDone(sender:)), for: UIControlEvents.touchUpInside)
            doneButton.enable(enabled: false)
            contentView.addSubview(doneButton)
        }
        
        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            activityIndicatorView.isHidden = true
            contentView.addSubview(activityIndicatorView)
        }
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
        }

        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.superview!).offset(20)
            make.centerX.equalTo(avatarView.superview!)
            make.size.equalTo(110)
        }

        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.centerX.equalTo(firstNameTextField.superview!)
            make.height.equalTo(UIComponentConstants.textFieldHeight)
            make.width.equalTo(firstNameTextField.superview!)
        }

        lastNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameTextField.snp.bottom)
            make.centerX.equalTo(lastNameTextField.superview!)
            make.height.equalTo(UIComponentConstants.textFieldHeight)
            make.width.equalTo(lastNameTextField.superview!)
        }

        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lastNameTextField.snp.bottom)
            make.centerX.equalTo(emailTextField.superview!)
            make.height.equalTo(UIComponentConstants.textFieldHeight)
            make.width.equalTo(emailTextField.superview!)
        }

        loginWithFacebookDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(60)
            make.centerX.equalTo(loginWithFacebookDescriptionLabel.superview!)
        }

        loginWithFaceBookButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginWithFacebookDescriptionLabel.snp.bottom).offset(12)
            make.centerX.equalTo(loginWithFaceBookButton.superview!)
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalTo(loginWithFaceBookButton.superview!)
        }

        doneButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(doneButton.superview!)
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.bottom.equalTo(doneButton.superview!)
            make.width.equalTo(doneButton.superview!)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.size.equalTo(ActivityIndicatorSize.medium)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - NSNotificationCenter
    //-------------------------------------------------------------------------------------------
    func adjustForKeyboard(notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            let userInfo = notification.userInfo!

            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)

            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
            activityIndicatorView.isHidden = false
        } else {
            self.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimation()
            activityIndicatorView.isHidden = true
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func textFieldDidChange(sender: UITextField!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didUpdateForm()
    }

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

}
