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
    private var eventSearchViewController : EventSearchViewController

    //Views
    private var homeView: HomeView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          identity : Identity,
                          eventSearchViewController : EventSearchViewController) {
        self.appRoute = appRoute
        self.identity = identity
        self.eventSearchViewController = eventSearchViewController
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
        //TODO: get time from server
        let now = Date()
        homeView.welcomeText = String(format: "%@ %@", arguments: [now.partOfDayGreetingString, (identity.user?.firstName ?? "")])
        homeView.descriptionText = String.localizedStringWithFormat("HomeViewController.Description".localized, now.dayString, now.formattedDateString)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - LoginViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapSendGift() {
        Logger.debug("User tapped send gift button")
        appRoute.presentNavigationViewController(controller: eventSearchViewController, animated: true)
    }
}
