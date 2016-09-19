//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController : UIViewController {

    // Injections
    private var appRoute : AppRoute
    private var identity : Identity

    //Views
    private var logoLabel : UILabel!
    private var slogenLabel : UILabel!
    private var descriptionLabel : UILabel!
    private var separatorViewA : UILabel!
    private var dayLabel : UILabel!
    private var dateLabel : UILabel!
    private var separatorViewB : UILabel!
    private var sendGiftButton : UIButton!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          identity : Identity) {
        self.appRoute = appRoute
        self.identity = identity
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCustomViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setConstraints()
    }

    private func addCustomViews() {
        self.view.backgroundColor = UIColor.white
        
        self.logoLabel = UILabel()
        self.logoLabel.text = "Gift".localized
        self.view.addSubview(self.logoLabel)
        
        self.slogenLabel = UILabel()
        self.slogenLabel.text = "WelcomeView.Gift slogan".localized
        self.view.addSubview(self.slogenLabel)
    }

    private func setConstraints() {
        logoLabel.snp.makeConstraints { (make) in
            make.center.equalTo(logoLabel.superview!)
        }
        
        slogenLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(slogenLabel.superview!)
            make.top.equalTo(logoLabel.snp.bottom).offset(15)
        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
}
