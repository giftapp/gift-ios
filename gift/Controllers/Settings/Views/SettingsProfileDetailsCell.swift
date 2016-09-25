//
// Created by Matan Lachmish on 24/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

struct SettingsProfileDetailsCellConsts{
    static let reuseIdentifier: String = String(describing: SettingsProfileDetailsCell.self)
}

class SettingsProfileDetailsCell: UITableViewCell {

    //Views
    private var iconImageView: UIImageView!
    private var mainTextLabel: UILabel!

    //Public Properties
    var iconImage: UIImage? {
        get {
            return iconImageView.image
        }
        set {
            iconImageView.image = newValue
        }
    }

    var mainText: String? {
        get {
            return mainTextLabel.text
        }
        set {
            mainTextLabel.text = newValue
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftWhiteColor()

        if iconImageView == nil {
            iconImageView = UIImageView()
            self.addSubview(iconImageView)
        }

        if mainTextLabel == nil {
            mainTextLabel = UILabel()
            mainTextLabel.numberOfLines = 1
            mainTextLabel.textAlignment = .right
            mainTextLabel.font = UIFont.gftText1Font()
            mainTextLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(mainTextLabel)
        }

    }

    private func setConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.superview!)
            make.right.equalTo(iconImageView.superview!).offset(-15)
        }

        mainTextLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainTextLabel.superview!)
            make.right.equalTo(iconImageView.snp.left).offset(-10)
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}
