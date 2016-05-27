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
            
            definition.useInitializer(#selector(LoginViewController.init(appRoute:welcomeViewController:verificationCodeViewController:authenticator:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.appRoute())
                initializer.injectParameterWith(self.welcomeViewController())
                initializer.injectParameterWith(self.verificationCodeViewController())
                initializer.injectParameterWith(self.coreComponentsAssembly.authenticator())
            }
        }
    }
    
    public dynamic func verificationCodeViewController() -> AnyObject {
        return TyphoonDefinition.withClass(VerificationCodeViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(VerificationCodeViewController.init(authenticator:))) {
                (initializer) in
                initializer.injectParameterWith(self.coreComponentsAssembly.authenticator())
            }
        }
    }
}