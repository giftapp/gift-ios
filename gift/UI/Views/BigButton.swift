//
// Created by Matan Lachmish on 12/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

enum BigButtonStyle {
    case centered
    case rightAlignedWithChevron
}

class BigButton: UIButton {

    //Views
    private var chevron: UIImageView!

    //Public Varaiables
    var style: BigButtonStyle = .centered {
        didSet {
            updateApearence()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addCustomViews()
        self.setConstraints()
        self.updateApearence()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.titleLabel!.font = UIFont.gftHeader1Font()
        self.setTitleColor(UIColor.gftWhiteColor(), for: UIControlState())
        self.backgroundColor = UIColor.gftAzureColor()

        if chevron == nil {
            chevron = UIImageView(image: UIImage(named:"chevronLeft")!)
            self.addSubview(chevron)
        }
    }

    private func setConstraints() {
        chevron.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func enable(enabled: Bool) {
        if (enabled) {
            self.isEnabled = true
            UIView.animate(withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.alpha = 1
                    },
                    completion: nil)
        } else {
            self.isEnabled = false
            UIView.animate(withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.alpha = 0.5
                    },
                    completion: nil)
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func updateApearence() {
        switch style {
        case .centered:
            self.contentHorizontalAlignment = .center
            self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.chevron.isHidden = true
        case .rightAlignedWithChevron:
            self.contentHorizontalAlignment = .right
            self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
            self.chevron.isHidden = false
        }
    }
}
