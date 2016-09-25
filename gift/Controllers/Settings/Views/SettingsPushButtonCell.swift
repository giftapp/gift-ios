//
// Created by Matan Lachmish on 24/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

struct SettingsPushButtonCellConsts{
    static let reuseIdentifier: String = String(describing: SettingsPushButtonCell.self)
}


class SettingsPushButtonCell : UITableViewCell {

    //Views
    private var mainTextLabel: UILabel!
    private var chevronImageView: UIImageView!

    //Public Properties
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
        self.backgroundColor = UIColor.gftAzureColor()

        if chevronImageView == nil {
            chevronImageView = UIImageView(image: UIImage(named: "chevron"))
            self.addSubview(chevronImageView)
        }

        if mainTextLabel == nil {
            mainTextLabel = UILabel()
            mainTextLabel.numberOfLines = 1
            mainTextLabel.textAlignment = .right
            mainTextLabel.font = UIFont.gftPushButtonFont()
            mainTextLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(mainTextLabel)
        }

    }

    private func setConstraints() {
        chevronImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(chevronImageView.superview!)
            make.left.equalTo(chevronImageView.superview!).offset(15)
        }

        mainTextLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainTextLabel.superview!)
            make.right.equalTo(mainTextLabel.superview!).offset(-15)
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}
