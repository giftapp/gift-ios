//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

struct WelcomeViewControllerUserDefaultKeys {
    static let didDismissWelcomeViewController = "WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController"
}

class WelcomeViewController : UIViewController, WelcomeViewDelegate {

    //Injected
    private var appRoute : AppRoute

    //Views
    private var welcomeView : WelcomeView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute) {
        self.appRoute = appRoute;
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
        self.welcomeView =  WelcomeView(frame: self.view!.frame)
        self.welcomeView.delegate = self
        view.addSubview(welcomeView)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - WelcomeViewDelegate
    //-------------------------------------------------------------------------------------------
    internal func didTapContinue() {
        UserDefaults.standard.set(true, forKey: WelcomeViewControllerUserDefaultKeys.didDismissWelcomeViewController)
        appRoute.dismiss(controller: self, animated: true, completion: nil)
    }
}
