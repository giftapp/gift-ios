//
// Created by Matan Lachmish on 25/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

struct SettingsModalButtonCellConsts{
    static let reuseIdentifier: String = String(describing: SettingsModalButtonCell.self)
}

class SettingsModalButtonCell: UITableViewCell {

    //Views
    private var mainTextLabel: UILabel!

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
        self.backgroundColor = UIColor.gftWhiteColor()

        if mainTextLabel == nil {
            mainTextLabel = UILabel()
            mainTextLabel.numberOfLines = 1
            mainTextLabel.textAlignment = .center
            mainTextLabel.font = UIFont.gftModalButtonFont()
            mainTextLabel.textColor = UIColor.gftTurquoiseBlueColor()
            self.addSubview(mainTextLabel)
        }

    }

    private func setConstraints() {
        mainTextLabel.snp.makeConstraints { (make) in
            make.center.equalTo(mainTextLabel.superview!)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}