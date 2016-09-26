//
//  ViewControllersAssembly.swift
//  gift
//
//  Created by Matan Lachmish on 27/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class ViewControllersAssembly : TyphoonAssembly {

    public var coreComponentsAssembly: CoreComponentsAssembly!
    
    public dynamic func welcomeViewController() -> Any {
        return TyphoonDefinition.withClass(WelcomeViewController.self){
            (definition) in
            definition!.useInitializer(#selector(WelcomeViewController.init(appRoute:))) {
                (initializer) in
                initializer!.injectParameter(with: self.coreComponentsAssembly.appRoute())
            }
        }
    }
    
    public dynamic func loginViewController() -> Any {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in
            
            definition!.useInitializer(#selector(LoginViewController.init(appRoute:verificationCodeViewController:authenticator:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.verificationCodeViewController())
                initializer?.injectParameter(with: self.coreComponentsAssembly.authenticator())
            }
        }
    }
    
    public dynamic func verificationCodeViewController() -> Any {
        return TyphoonDefinition.withClass(VerificationCodeViewController.self) {
            (definition) in
            
            definition?.useInitializer(#selector(VerificationCodeViewController.init(appRoute:authenticator:launcher:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.coreComponentsAssembly.authenticator())
                initializer?.injectParameter(with: nil) // Property injected
            }
            definition?.injectProperty(#selector(CoreComponentsAssembly.launcher), with: self.coreComponentsAssembly.launcher())

        }
    }
    
    public dynamic func editProfileViewController() -> Any {
        return TyphoonDefinition.withClass(EditProfileViewController.self) {
            (definition) in
            
            definition!.useInitializer(#selector(EditProfileViewController.init(appRoute:identity:facebookClient:giftServiceCoreClient:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.coreComponentsAssembly.identity())
                initializer?.injectParameter(with: self.coreComponentsAssembly.facebookClient())
                initializer?.injectParameter(with: self.coreComponentsAssembly.giftServiceCoreClient())
            }
        }
    }

    public dynamic func mainTabViewController() -> Any {
        return TyphoonDefinition.withClass(MainTabViewController.self) {
            (definition) in

            definition!.useInitializer(#selector(MainTabViewController.init(homeViewController:historyViewController:settingsViewController:))) {
                (initializer) in
                initializer?.injectParameter(with: self.homeViewController())
                initializer?.injectParameter(with: self.historyViewController())
                initializer?.injectParameter(with: self.settingsViewController())
            }
        }
    }
    
    public dynamic func homeViewController() -> Any {
        return TyphoonDefinition.withClass(HomeViewController.self) {
            (definition) in
            
            definition!.useInitializer(#selector(HomeViewController.init(appRoute:identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.coreComponentsAssembly.identity())
            }
        }
    }
    
    public dynamic func historyViewController() -> Any {
        return TyphoonDefinition.withClass(HistoryViewController.self) {
            (definition) in
            
            definition!.useInitializer(#selector(HistoryViewController.init(appRoute:identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.coreComponentsAssembly.identity())
            }
        }
    }
    
    public dynamic func settingsViewController() -> Any {
        return TyphoonDefinition.withClass(SettingsViewController.self) {
            (definition) in
            
            definition!.useInitializer(#selector(SettingsViewController.init(appRoute:identity:editProfileViewController:))) {
                (initializer) in
                initializer?.injectParameter(with: self.coreComponentsAssembly.appRoute())
                initializer?.injectParameter(with: self.coreComponentsAssembly.identity())
                initializer?.injectParameter(with: self.editProfileViewController())
            }
        }
    }
}
