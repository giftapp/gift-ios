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
    
    public dynamic func welcomeViewController() -> AnyObject {
        return TyphoonDefinition.withClass(WelcomeViewController.self){
            (definition) in
            definition.useInitializer(#selector(WelcomeViewController.init(appRoute:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.appRoute())
            }
        }
    }
    
    public dynamic func loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(LoginViewController.init(appRoute:verificationCodeViewController:authenticator:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.appRoute())
                initializer.injectParameterWith(self.verificationCodeViewController())
                initializer.injectParameterWith(self.coreComponentsAssembly.authenticator())
            }
        }
    }
    
    public dynamic func verificationCodeViewController() -> AnyObject {
        return TyphoonDefinition.withClass(VerificationCodeViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(VerificationCodeViewController.init(authenticator:launcher:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.authenticator())
                initializer.injectParameterWith(nil) // property injection
            }
            definition.injectProperty(#selector(CoreComponentsAssembly.launcher), with: self.coreComponentsAssembly.launcher())

        }
    }
    
    public dynamic func editProfileViewController() -> AnyObject {
        return TyphoonDefinition.withClass(EditProfileViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(EditProfileViewController.init(appRoute:facebookClient:giftServiceCoreClient:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.appRoute())
                initializer.injectParameterWith(self.coreComponentsAssembly.facebookClient())
                initializer.injectParameterWith(self.coreComponentsAssembly.giftServiceCoreClient())
            }
        }
    }

    public dynamic func mainTabViewController() -> AnyObject {
        return TyphoonDefinition.withClass(MainTabViewController.self) {
            (definition) in

            definition.useInitializer(#selector(MainTabViewController.init(homeViewController:historyViewController:settingsViewController:))) {
                (initializer) in
                initializer.injectParameterWith(UIViewController())
                initializer.injectParameterWith(UIViewController())
                initializer.injectParameterWith(UIViewController())
            }
        }
    }
}