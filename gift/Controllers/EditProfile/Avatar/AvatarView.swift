//
// Created by Matan Lachmish on 13/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
            imageView.contentMode = .scaleAspectFit
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
            initialsPlaceHolderLabel.font = UIFont.gftText1Font()
            initialsPlaceHolderLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(initialsPlaceHolderLabel)
        }
        
        if editLabel == nil {
            editLabel = UILabel()
            editLabel.text = "AvatarView.Edit".localized
            editLabel.numberOfLines = 1
            editLabel.textAlignment = .center
            editLabel.font = UIFont.gftText1Font()
            editLabel.textColor = UIColor.gftGreyishColor()
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
    func setImage(image: UIImage) {
        imageView.image = image
    }

    func useEmptyImagePlaceholder(image: UIImage?) {
        emptyImageViewPlaceholder.image = image
        emptyImageViewPlaceholder.isHidden = false
        initialsPlaceHolderLabel.isHidden = true
    }
    
    
    func useInitialsPlaceHolder(initials: String) {
        initialsPlaceHolderLabel.text = initials
        initialsPlaceHolderLabel.isHidden = false
        emptyImageViewPlaceholder.isHidden = true
    }
}
