//
// Created by Matan Lachmish on 02/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class DeveloperTools: NSObject {

    //Injected
    private var appRoute: AppRoute
    private var identity: Identity
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute, identity: Identity) {
        self.appRoute = appRoute
        self.identity = identity
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func allowIfEnable() {
        if !Configuration.sharedInstance.developmentToolsEnabled {
            return
        }
        
        Logger.info("Developer tools are enabled")
        let developerToolsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeveloperTools.openDeveloperToolsMenu))
        developerToolsTapRecognizer.numberOfTapsRequired = 3
        developerToolsTapRecognizer.numberOfTouchesRequired = 2
        UIApplication.shared.keyWindow!.addGestureRecognizer(developerToolsTapRecognizer)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func openDeveloperToolsMenu() {
        let cancelAction = AlertViewAction(title: "Cancel", style: .cancel, action: nil)
        let clearKeychainAction = AlertViewAction(title: "Clear Keychain", style: .regular, action: {
            self.identity.logout()
        })
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "Developer Tools", description: nil, image: nil, actions: [cancelAction, clearKeychainAction])
        appRoute.presentController(controller: alertViewController, animated: true)
    }
}
