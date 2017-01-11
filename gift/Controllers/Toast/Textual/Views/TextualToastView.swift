//
// Created by Matan Lachmish on 10/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol TextualToastViewDelegate {
    func didUpdatePresenterName()
    func didTapAddPicture()
    func didTapContinue()
}

class TextualToastView: UIView {

    //Views
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    private var toastIcon: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    private var presenterNameLabel: UILabel!
    private var presenterNameTextField : UITextField!

    private var textualToastTextView : UITextView!
    private var addPictureButton: UIButton!
    private var pictureImageView: UIImageView!

    private var continueButton: BigButton!

    private var activityIndicatorView: ActivityIndicatorView!

    //Public Properties
    var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    var presenterName: String? {
        get {
            return presenterNameTextField.text
        }
        set {
            presenterNameTextField.text = newValue
            didUpdatePresenterName(sender: presenterNameTextField)
        }
    }
    
    var textualToast: String? {
        get {
            return textualToastTextView.text
        }
        set {
            textualToastTextView.text = newValue
        }
    }

    var picture: UIImage? {
        get {
            return pictureImageView.image
        }
        set {
            pictureImageView.image = newValue

            if newValue == nil {
                addPictureButton.isHidden = false
                pictureImageView.isHidden = true
            } else {
                addPictureButton.isHidden = true
                pictureImageView.isHidden = false
            }
        }
    }

    var delegate: TextualToastViewDelegate!

    var textFieldDelegate: UITextFieldDelegate! {
        didSet {
            presenterNameTextField.delegate = self.textFieldDelegate
        }
    }
    
    var textViewDelegate: UITextViewDelegate! {
        didSet {
            textualToastTextView.delegate = self.textViewDelegate
        }
    }

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

        if toastIcon == nil {
            toastIcon = UIImageView(image: UIImage(named:"envelopToastIcon")!)
            contentView.addSubview(toastIcon)
        }

        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.text = "VideoToastView.Title".localized
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.font = UIFont.gftHeader1Font()
            titleLabel.textColor = UIColor.gftWaterBlueColor()
            contentView.addSubview(titleLabel)
        }

        if descriptionLabel == nil { //text is being set from outside
            descriptionLabel = UILabel()
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.font = UIFont.gftText1Font()
            descriptionLabel.textColor = UIColor.gftBlackColor()
            contentView.addSubview(descriptionLabel)
        }

        if presenterNameLabel == nil {
            presenterNameLabel = UILabel()
            presenterNameLabel.text = "VideoToastView.Presenter name".localized
            presenterNameLabel.textAlignment = NSTextAlignment.center
            presenterNameLabel.font = UIFont.gftText1Font()
            presenterNameLabel.textColor = UIColor.gftWaterBlueColor()
            contentView.addSubview(presenterNameLabel)
        }

        if presenterNameTextField == nil {
            presenterNameTextField = UITextField()
            presenterNameTextField.backgroundColor = UIColor.gftWhiteColor()
            presenterNameTextField.addTopBottomBorders()
            presenterNameTextField.textAlignment = NSTextAlignment.center
            presenterNameTextField.font = UIFont(name: "Rubik-Light", size: 25.0)
            presenterNameTextField.textColor = UIColor.gftBlackColor()
            presenterNameTextField.addTarget(self, action: #selector(didUpdatePresenterName(sender:)), for: .editingChanged)
            contentView.addSubview(presenterNameTextField)
        }

        if textualToastTextView == nil {
            textualToastTextView = UITextView()
            //TODO:add placeholder
            textualToastTextView.textAlignment = .right
            textualToastTextView.font = UIFont.gftText1Font()
            textualToastTextView.addTopBottomBorders()
            contentView.addSubview(textualToastTextView)
        }

        if addPictureButton == nil {
            addPictureButton = UIButton()

            addPictureButton.setTitle("VideoToastView.Add picture".localized, for: .normal)
            addPictureButton.titleLabel!.font = UIFont.gftModalButtonFont()
            addPictureButton.setTitleColor(UIColor.gftTurquoiseBlueColor(), for: .normal)

            addPictureButton.setImage(UIImage(named:"addPhotoButton"), for: .normal)
            addPictureButton.setImage(UIImage(named:"addPhotoButton"), for: .highlighted)
            addPictureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

            addPictureButton.backgroundColor = UIColor.gftWhiteColor()
            addPictureButton.addTopBottomBorders()
            addPictureButton.addTarget(self, action: #selector(didTapAddPicture(sender:)), for: UIControlEvents.touchUpInside)

            contentView.addSubview(addPictureButton)
        }

        if pictureImageView == nil {
            pictureImageView = UIImageView(image: nil) //Image is being set from public varaiable
            pictureImageView.contentMode = .scaleAspectFit
            pictureImageView.isHidden = true
            contentView.addSubview(pictureImageView)
        }

        if continueButton == nil {
            continueButton = BigButton()
            continueButton.setTitle("VideoToastView.Continue button".localized, for: UIControlState())
            continueButton.style = .rightAlignedWithChevron
            continueButton.addTarget(self, action: #selector(didTapContinue(sender:)), for: UIControlEvents.touchUpInside)
            continueButton.enable(enabled: false)
            contentView.addSubview(continueButton)
        }

        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            activityIndicatorView.isHidden = true
            self.addSubview(activityIndicatorView)
        }
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.size.equalToSuperview()
        }

        toastIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(toastIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        presenterNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }

        presenterNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(presenterNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(UIComponentConstants.textFieldHeight)
        }

        textualToastTextView.snp.makeConstraints { (make) in
            make.top.equalTo(presenterNameTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }

        addPictureButton.snp.makeConstraints { (make) in
            make.top.equalTo(textualToastTextView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalToSuperview()
        }

        pictureImageView.snp.makeConstraints { (make) in
            make.top.equalTo(textualToastTextView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
//            make.height.equalTo(350) //TODO: fix
        }

        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.width.equalToSuperview()
            
            make.top.greaterThanOrEqualTo(pictureImageView.snp.bottom).offset(30)
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
    func removePicture() {
        picture = nil
    }

    func enableContinueButton(enabled: Bool) {
        continueButton.enable(enabled: enabled)
    }

    func activityAnimation(shouldAnimate: Bool) {
        if shouldAnimate {
            self.isUserInteractionEnabled = false
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimation()
        } else {
            self.isUserInteractionEnabled = true
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimation()
        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didUpdatePresenterName(sender: UITextField!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didUpdatePresenterName()
    }

    @objc private func didTapAddPicture(sender: UITextField!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapAddPicture()
    }

    @objc private func didTapContinue(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapContinue()
    }
}
