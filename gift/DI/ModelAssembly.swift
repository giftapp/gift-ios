//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class ModelAssembly : TyphoonAssembly {

    //-------------------------------------------------------------------------------------------
    // MARK: - Model
    //-------------------------------------------------------------------------------------------
    public dynamic func authenticator() -> AnyObject {
        return TyphoonDefinition.withClass(Authenticator.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.useInitializer(#selector(Authenticator.init(facebookClient:))) {
                (initializer) in
                initializer.injectParameterWith(self.facebookClient())
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

    //-------------------------------------------------------------------------------------------
    // MARK: - ViewControllers
    //-------------------------------------------------------------------------------------------
    public dynamic func loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in

            definition.useInitializer(#selector(LoginViewController.init(authenticator:))) {
                (initializer) in
                    initializer.injectParameterWith(self.authenticator())
            }
        }
    }

}