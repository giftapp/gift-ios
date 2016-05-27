//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class ModelAssembly : TyphoonAssembly {
    
    public dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            
            definition.injectProperty(#selector(ModelAssembly.appRoute), with: self.appRoute())
            definition.injectProperty(#selector(ModelAssembly.loginViewController), with: self.loginViewController())

        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Model
    //-------------------------------------------------------------------------------------------
    public dynamic func authenticator() -> AnyObject {
        return TyphoonDefinition.withClass(Authenticator.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.useInitializer(#selector(Authenticator.init(giftServiceCoreClient:))) {
                (initializer) in
                initializer.injectParameterWith(self.giftServiceCoreClient())
            }
        }
    }
    
    public dynamic func facebookClient() -> AnyObject {
        return TyphoonDefinition.withClass(FacebookClient.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    public dynamic func giftServiceCoreClient() -> AnyObject {
        return TyphoonDefinition.withClass(GiftServiceCoreClient.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    public dynamic func appRoute() -> AnyObject {
        return TyphoonDefinition.withClass(AppRoute.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - ViewControllers
    //-------------------------------------------------------------------------------------------
    public dynamic func welcomeViewController() -> AnyObject {
        return TyphoonDefinition.withClass(WelcomeViewController.self){
            (definition) in
            definition.useInitializer(#selector(WelcomeViewController.init(appRoute:))) {
                (initializer) in
                initializer.injectParameterWith(self.appRoute())
            }
        }
    }
    
    public dynamic func loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in

            definition.useInitializer(#selector(LoginViewController.init(appRoute:welcomeViewController:verificationCodeViewController:authenticator:))) {
                (initializer) in
                    initializer.injectParameterWith(self.appRoute())
                    initializer.injectParameterWith(self.welcomeViewController())
                    initializer.injectParameterWith(self.verificationCodeViewController())
                    initializer.injectParameterWith(self.authenticator())
            }
        }
    }
    
    public dynamic func verificationCodeViewController() -> AnyObject {
        return TyphoonDefinition.withClass(VerificationCodeViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(VerificationCodeViewController.init(authenticator:))) {
                (initializer) in
                initializer.injectParameterWith(self.authenticator())
            }
        }
    }

}