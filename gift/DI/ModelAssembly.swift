//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

class ModelAssembly : TyphoonAssembly {

    //Mark: Model
    public dynamic func facebookClient() -> AnyObject {
        return TyphoonDefinition.withClass(FacebookClient.self)
    }

    //Mark: ViewControllers
    public dynamic func loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in

            definition.useInitializer("initWithFacebookClient:") {
                (initializer) in
                    initializer.injectParameterWith(self.facebookClient())
            }
        }
    }

}