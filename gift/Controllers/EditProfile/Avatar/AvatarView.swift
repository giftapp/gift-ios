//
// Created by Matan Lachmish on 13/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

protocol AvatarViewDelegate {
    func didTapEdit()
}

class AvatarView: UIView, UIGestureRecognizerDelegate {

    //Views
    var imageView: UIImageView!
    var emptyImageViewPlaceholder: UIImageView!
    var initialsPlaceHolderLabel: UILabel!
    var editLabel: UILabel!

    //Public Properties
    var delegate: AvatarViewDelegate!
    
    var imageURL: String? {
        didSet {
            if let imageURLNonOptional = imageURL {
                let url = URL(string: imageURLNonOptional)
                imageView.kf_setImage(with: url)
                imageView.isHidden = false
                emptyImageViewPlaceholder.isHidden = true
                initialsPlaceHolderLabel.isHidden = true
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.isHidden = false
            emptyImageViewPlaceholder.isHidden = true
            initialsPlaceHolderLabel.isHidden = true
            
            imageURL = nil
        }
    }

    var emptyImagePlaceholder: UIImage? {
        get {
            return emptyImageViewPlaceholder.image
        }
        set {
            emptyImageViewPlaceholder.image = newValue
            emptyImageViewPlaceholder.isHidden = false
            initialsPlaceHolderLabel.isHidden = true
            imageView.isHidden = true
        }
    }

    var initialsPlaceHolder: String? {
        get {
            return initialsPlaceHolderLabel.text
        }
        set {
            initialsPlaceHolderLabel.text = newValue
            initialsPlaceHolderLabel.isHidden = false
            emptyImageViewPlaceholder.isHidden = true
            imageView.isHidden = true
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
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gftSeparatorColor().cgColor

        let tap = UITapGestureRecognizer(target: self, action: #selector(AvatarView.didTap))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        if imageView == nil {
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            self.addSubview(imageView)
        }

        if emptyImageViewPlaceholder == nil {
            emptyImageViewPlaceholder = UIImageView()
            emptyImageViewPlaceholder.contentMode = .scaleAspectFit
            self.addSubview(emptyImageViewPlaceholder)
        }

        if initialsPlaceHolderLabel == nil {
            initialsPlaceHolderLabel = UILabel()
            initialsPlaceHolderLabel.numberOfLines = 1
            initialsPlaceHolderLabel.textAlignment = .center
            initialsPlaceHolderLabel.font = UIFont.gftAvatarInitialsFont()
            initialsPlaceHolderLabel.textColor = UIColor.gftAzureColor()
            initialsPlaceHolderLabel.backgroundColor = UIColor.gftWhiteColor()
            self.addSubview(initialsPlaceHolderLabel)
        }
        
        if editLabel == nil {
            editLabel = UILabel()
            editLabel.text = "AvatarView.Edit".localized
            editLabel.numberOfLines = 1
            editLabel.textAlignment = .center
            editLabel.font = UIFont.gftText1Font()
            editLabel.textColor = UIColor.gftWarmGreyColor()
            editLabel.backgroundColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.5)
            self.addSubview(editLabel)
        }
    }

    private func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView.superview!)
            make.size.equalTo(imageView.superview!)
        }
        
        emptyImageViewPlaceholder.snp.makeConstraints { (make) in
            make.center.equalTo(emptyImageViewPlaceholder.superview!)
            make.size.equalTo(emptyImageViewPlaceholder.superview!)
        }

        initialsPlaceHolderLabel.snp.makeConstraints { (make) in
            make.center.equalTo(initialsPlaceHolderLabel.superview!)
            make.size.equalTo(initialsPlaceHolderLabel.superview!)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(editLabel.superview!)
            make.width.equalTo(editLabel.superview!)
            make.height.equalTo(28)
            make.bottom.equalTo(editLabel.superview!)
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTap() {
        delegate.didTapEdit()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
}
