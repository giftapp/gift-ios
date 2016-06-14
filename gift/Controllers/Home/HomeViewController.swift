//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

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

        self.title = "Gift"

        self.addCustomViews()
    }

    override func viewDidAppear(animated: Bool) {
        self.setConstraints()
    }

    private func addCustomViews() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.logoLabel = UILabel()
        self.logoLabel.text = "Gift".localized
        self.view.addSubview(self.logoLabel)
        
        self.slogenLabel = UILabel()
        self.slogenLabel.text = "Gift slogen".localized
        self.view.addSubview(self.slogenLabel)
    }

    private func setConstraints() {
        constrain(logoLabel, slogenLabel) { logoLabel, slogenLabel in
            logoLabel.center == logoLabel.superview!.center
            slogenLabel.centerX == logoLabel.centerX
            slogenLabel.top == logoLabel.bottom + 15
        }
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
}
