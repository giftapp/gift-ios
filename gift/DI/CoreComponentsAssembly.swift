//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class CoreComponentsAssembly : TyphoonAssembly {

    public var viewControllersAssembly: ViewControllersAssembly!
    
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
    
    public dynamic func launcher() -> AnyObject {
        return TyphoonDefinition.withClass(Launcher.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.useInitializer(#selector(Launcher.init(appRoute:welcomeViewController:loginViewController:))) {
                (initializer) in
                initializer.injectParameterWith(self.appRoute())
                initializer.injectParameterWith(self.viewControllersAssembly.welcomeViewController())
                initializer.injectParameterWith(self.viewControllersAssembly.loginViewController())
            }
        }
    }

}