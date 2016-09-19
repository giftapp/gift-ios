//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController : UIViewController {

    // Injections
    private var appRoute : AppRoute
    private var identity : Identity

    //Views

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
    }

    private func setConstraints() {
//        constrain(loginWithFaceBookButton) { loginWithFaceBookButton in
//            loginWithFaceBookButton.center == loginWithFaceBookButton.superview!.center
//        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
}
