//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

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

        self.title = "Settings"

        self.addCustomViews()
    }

    override func viewDidAppear(animated: Bool) {
        self.setConstraints()
    }

    private func addCustomViews() {
        self.view.backgroundColor = UIColor.whiteColor()

        logoutButton = UIButton()
        logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        logoutButton.titleLabel!.font = UIFont.gftHeader1Font()
        logoutButton.setTitleColor(UIColor.gftWhiteColor(), forState: UIControlState.Normal)
        logoutButton.backgroundColor = UIColor.gftAzureColor()
        logoutButton.addTarget(self, action: #selector(SettingsViewController.didTapLogout(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)
    }

    private func setConstraints() {
        constrain(logoutButton) { logoutButton in
            logoutButton.center == logoutButton.superview!.center
        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapLogout(sender:UIButton!) {
        self.identity.logout()
    }
}
