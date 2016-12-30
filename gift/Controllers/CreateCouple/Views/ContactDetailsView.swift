//
// Created by Matan Lachmish on 23/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//
import Foundation
import UIKit
import SnapKit

protocol ContactDetailsViewDelegate{
    func didUpdate()
}

class ContactDetailsView: UIView, UITextFieldDelegate {

    //Views
    private var firstNameTextField: AnimatedTextField!
    private var lastNameTextField: AnimatedTextField!
    private var phoneNumberNameTextField: AnimatedTextField!


    //Public Properties
    var delegate: ContactDetailsViewDelegate!

    var textFieldDelegate: UITextFieldDelegate! {
        didSet {
            firstNameTextField.delegate = self.textFieldDelegate
            lastNameTextField.delegate = self.textFieldDelegate
            phoneNumberNameTextField.delegate = self.textFieldDelegate
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

    var phoneNumber: String? {
        get {
            return phoneNumberNameTextField.text
        }
        set {
            phoneNumberNameTextField.text = newValue
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

    override func draw(_ rect: CGRect) {
        self.round(corners: [.bottomLeft, .topLeft], radius: 10.0, borderColor: UIColor.gftSeparatorColor(), borderWidth: 1.0) //TODO: decide if this is the right approach
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftWhiteColor()

        if firstNameTextField == nil {
            firstNameTextField = AnimatedTextField()
            firstNameTextField.placeholder = "ContactDetailsView.First name".localized
            firstNameTextField.delegate = self
            firstNameTextField.addLeftBorder()
            firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            self.addSubview(firstNameTextField)
        }

        if lastNameTextField == nil {
            lastNameTextField = AnimatedTextField()
            lastNameTextField.placeholder = "ContactDetailsView.Last name".localized
            lastNameTextField.delegate = self
            lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            self.addSubview(lastNameTextField)
        }

        if phoneNumberNameTextField == nil {
            phoneNumberNameTextField = AnimatedTextField()
            phoneNumberNameTextField.addTopBorder(padded: true)
            phoneNumberNameTextField.placeholder = "ContactDetailsView.Phone number".localized
            phoneNumberNameTextField.keyboardType = .phonePad
            phoneNumberNameTextField.delegate = self
            phoneNumberNameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            self.addSubview(phoneNumberNameTextField)
        }

    }

    private func setConstraints() {
        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45) //TODO: const
            make.width.equalToSuperview().dividedBy(2)
        }
        
        lastNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameTextField)
            make.right.equalTo(firstNameTextField.snp.left)
            make.height.equalTo(45)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        phoneNumberNameTextField.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.width.equalToSuperview()
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

        delegate.didUpdate()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func clearData() {
        firstName = ""
        lastName = ""
        phoneNumber = ""
    }

    func focus() {
        firstNameTextField.becomeFirstResponder()
    }
}
