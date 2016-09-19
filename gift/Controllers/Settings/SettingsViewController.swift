//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SettingsViewController : UIViewController {

    // Injections
    private var appRoute : AppRoute
    private var identity : Identity

    //Views
    private var logoutButton: UIButton!

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

        logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: UIControlState())
        logoutButton.titleLabel!.font = UIFont.gftHeader1Font()
        logoutButton.setTitleColor(UIColor.gftWhiteColor(), for: UIControlState())
        logoutButton.backgroundColor = UIColor.gftAzureColor()
        logoutButton.addTarget(self, action: #selector(SettingsViewController.didTapLogout(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(logoutButton)
    }

    private func setConstraints() {
        logoutButton.snp.makeConstraints { (make) in
            make.center.equalTo(logoutButton.superview!)
        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapLogout(sender:UIButton!) {
        self.identity.logout()
    }
}
