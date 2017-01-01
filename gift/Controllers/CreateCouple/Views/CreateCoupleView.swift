//
// Created by Matan Lachmish on 23/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//
import Foundation
import UIKit
import SnapKit

enum ContactIndex {
    case a
    case b
}

protocol CreateCoupleViewDelegate {
    func didTapAddDetails(contactIndex: ContactIndex)
    func didTapDeleteDetails(contactIndex: ContactIndex)
    func didTapContinue()
}

class CreateCoupleView: UIView, UITextFieldDelegate {

    //Views
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    private var coupleIcon: UIImageView!
    private var descriptionLabel: UILabel!

    private var addContact1Title: UILabel!
    private var addContact1Button: UIButton!
    var contact1DetailsView: ContactDetailsView!
    private var deleteContact1Button: UIButton!

    private var addContact2Title: UILabel!
    private var addContact2Button: UIButton!
    var contact2DetailsView: ContactDetailsView!
    private var deleteContact2Button: UIButton!

    private var continueButton: BigButton!

    private var activityIndicatorView: ActivityIndicatorView!

    //Public Properties
    var delegate: CreateCoupleViewDelegate!

    var textFieldDelegate: UITextFieldDelegate! {
        didSet {
            contact1DetailsView.textFieldDelegate = self.textFieldDelegate
            contact2DetailsView.textFieldDelegate = self.textFieldDelegate
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

        if coupleIcon == nil {
            coupleIcon = UIImageView(image: UIImage(named:"coupleIcon")!)
            contentView.addSubview(coupleIcon)
        }

        if descriptionLabel == nil {
            descriptionLabel = UILabel()
            descriptionLabel.text = "CreateCoupleView.Description".localized
            descriptionLabel.numberOfLines = 2
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.font = UIFont.gftText1Font()
            descriptionLabel.textColor = UIColor.gftBlackColor()
            contentView.addSubview(descriptionLabel)
        }

        if addContact1Title == nil {
            addContact1Title = UILabel()
            addContact1Title.text = "CreateCoupleView.Add contact1 title".localized
            addContact1Title.numberOfLines = 1
            addContact1Title.textAlignment = NSTextAlignment.right
            addContact1Title.font = UIFont.gftText1Font()
            addContact1Title.textColor = UIColor.gftBlackColor()
            contentView.addSubview(addContact1Title)
        }

        if addContact1Button == nil {
            addContact1Button = UIButton()
            addContact1Button.setTitle("CreateCoupleView.Add details".localized, for: .normal)
            addContact1Button.titleLabel!.font = UIFont.gftModalButtonFont()
            addContact1Button.setTitleColor(UIColor.gftTurquoiseBlueColor(), for: .normal)
            addContact1Button.backgroundColor = UIColor.gftWhiteColor()
            addContact1Button.addTopBottomBorders()
            addContact1Button.addTarget(self, action: #selector(didTapAddDetails(sender:)), for: UIControlEvents.touchUpInside)
            contentView.addSubview(addContact1Button)
        }

        if contact1DetailsView == nil {
            contact1DetailsView = ContactDetailsView()
            contact1DetailsView.isHidden = true
            contentView.addSubview(contact1DetailsView)
        }

        if deleteContact1Button == nil {
            deleteContact1Button = UIButton()
            deleteContact1Button.setImage(UIImage(named: "trash"), for: .normal)
            deleteContact1Button.addTarget(self, action: #selector(didTapDeleteDetails(sender:)), for: UIControlEvents.touchUpInside)
            deleteContact1Button.isHidden = true
            contentView.addSubview(deleteContact1Button)
        }

        if addContact2Title == nil {
            addContact2Title = UILabel()
            addContact2Title.text = "CreateCoupleView.Add contact2 title".localized
            addContact2Title.numberOfLines = 1
            addContact2Title.textAlignment = NSTextAlignment.right
            addContact2Title.font = UIFont.gftText1Font()
            addContact2Title.textColor = UIColor.gftBlackColor()
            contentView.addSubview(addContact2Title)
        }

        if addContact2Button == nil {
            addContact2Button = UIButton()
            addContact2Button.setTitle("CreateCoupleView.Add details".localized, for: .normal)
            addContact2Button.titleLabel!.font = UIFont.gftModalButtonFont()
            addContact2Button.setTitleColor(UIColor.gftTurquoiseBlueColor(), for: .normal)
            addContact2Button.backgroundColor = UIColor.gftWhiteColor()
            addContact2Button.addTopBottomBorders()
            addContact2Button.addTarget(self, action: #selector(didTapAddDetails(sender:)), for: UIControlEvents.touchUpInside)
            contentView.addSubview(addContact2Button)
        }

        if contact2DetailsView == nil {
            contact2DetailsView = ContactDetailsView()
            contact2DetailsView.isHidden = true
            contentView.addSubview(contact2DetailsView)
        }

        if deleteContact2Button == nil {
            deleteContact2Button = UIButton()
            deleteContact2Button.setImage(UIImage(named: "trash"), for: .normal)
            deleteContact2Button.addTarget(self, action: #selector(didTapDeleteDetails(sender:)), for: UIControlEvents.touchUpInside)
            deleteContact2Button.isHidden = true
            contentView.addSubview(deleteContact2Button)
        }

        if continueButton == nil {
            continueButton = BigButton()
            continueButton.setTitle("CreateCoupleView.Continue button".localized, for: UIControlState())
            continueButton.style = .rightAlignedWithChevron
            continueButton.addTarget(self, action: #selector(didTapContinue(sender:)), for: UIControlEvents.touchUpInside)
            continueButton.enable(enabled: false)
            contentView.addSubview(continueButton)
        }

        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
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

        coupleIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coupleIcon.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        addContact1Title.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.right.equalTo(-15)
        }

        addContact1Button.snp.makeConstraints { (make) in
            make.top.equalTo(addContact1Title.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalToSuperview()
        }

        contact1DetailsView.snp.makeConstraints { (make) in
            make.top.equalTo(addContact1Title.snp.bottom).offset(10)
            make.height.equalTo(90)
            make.right.equalToSuperview()
            make.left.equalTo(deleteContact1Button.snp.right).offset(15)
        }

        deleteContact1Button.snp.makeConstraints { (make) in
            make.centerY.equalTo(contact1DetailsView)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(deleteContact1Button.imageView!)
        }

        addContact2Title.snp.makeConstraints { (make) in
            make.top.equalTo(addContact1Button.snp.bottom).offset(75)
            make.right.equalTo(-15)
        }

        addContact2Button.snp.makeConstraints { (make) in
            make.top.equalTo(addContact2Title.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalToSuperview()
        }

        contact2DetailsView.snp.makeConstraints { (make) in
            make.top.equalTo(addContact2Title.snp.bottom).offset(10)
            make.height.equalTo(90)
            make.right.equalToSuperview()
            make.left.equalTo(deleteContact2Button.snp.right).offset(15)
        }

        deleteContact2Button.snp.makeConstraints { (make) in
            make.centerY.equalTo(contact2DetailsView)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(deleteContact2Button.imageView!)
        }

        continueButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
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
    func shouldShowContactDetails(shouldShowContactDetails: Bool, forContactIndex index: ContactIndex) {
        switch index {
        case .a:
            addContact1Button.isHidden = shouldShowContactDetails
            contact1DetailsView.isHidden = !shouldShowContactDetails
            deleteContact1Button.isHidden = !shouldShowContactDetails

            if shouldShowContactDetails {
                contact1DetailsView.focus()
            } else {
                self.endEditing(true)
            }
        case .b:
            addContact2Button.isHidden = shouldShowContactDetails
            contact2DetailsView.isHidden = !shouldShowContactDetails
            deleteContact2Button.isHidden = !shouldShowContactDetails

            if shouldShowContactDetails {
                contact2DetailsView.focus()
            } else {
                self.endEditing(true)
            }
        }
    }

    func enableContinueButton(enabled: Bool) {
        continueButton.enable(enabled: enabled)
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
    @objc private func didTapAddDetails(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        var contactIndex: ContactIndex
        contactIndex = sender.isEqual(addContact1Button) ? .a : .b
        delegate.didTapAddDetails(contactIndex: contactIndex)
    }

    @objc private func didTapDeleteDetails(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        var contactIndex: ContactIndex
        contactIndex = sender.isEqual(deleteContact1Button) ? .a : .b
        delegate.didTapDeleteDetails(contactIndex: contactIndex)
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
