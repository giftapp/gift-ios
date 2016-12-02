//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController : UIViewController, HomeViewDelegate {

    // Injections
    private var appRoute : AppRoute
    private var identity : Identity

    //Views
    private var homeView: HomeView!

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

    private func addCustomViews() {
        if homeView == nil {
            homeView = HomeView()
            homeView.delegate = self
            self.view = homeView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCustomViews()
    }

    private func updateCustomViews() {
        //TODO: update view with real details
        homeView.welcomeText = "123"
        homeView.descriptionText = "333"
        //String.localizedStringWithFormat("HomeView.Description".localized, phoneNumber.formateAsPhoneNumber)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapSendGift() {
        Logger.debug("User tapped send gift button")
    }
}
