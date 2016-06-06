//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class CoreComponentsAssembly : TyphoonAssembly {

    public var viewControllersAssembly: ViewControllersAssembly!

    private dynamic func logConfigurer() -> AnyObject {
        return TyphoonDefinition.withClass(LogConfigurer.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    public dynamic func authenticator() -> AnyObject {
        return TyphoonDefinition.withClass(Authenticator.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.useInitializer(#selector(Authenticator.init(giftServiceCoreClient:identity:))) {
                (initializer) in
                initializer.injectParameterWith(self.giftServiceCoreClient())
                initializer.injectParameterWith(self.identity())
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
            definition.useInitializer(#selector(GiftServiceCoreClient.init(identity:))) {
                (initializer) in
                initializer.injectParameterWith(self.identity())
            }
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
            definition.useInitializer(#selector(Launcher.init(appRoute:welcomeViewController:loginViewController:editProfileViewController:mainTabViewController:identity:))) {
                (initializer) in
                initializer.injectParameterWith(self.appRoute())
                initializer.injectParameterWith(self.viewControllersAssembly.welcomeViewController())
                initializer.injectParameterWith(self.viewControllersAssembly.loginViewController())
                initializer.injectParameterWith(self.viewControllersAssembly.editProfileViewController())
                initializer.injectParameterWith(self.viewControllersAssembly.mainTabViewController())
                initializer.injectParameterWith(self.identity())
            }
        }
    }
    
    public dynamic func identity() -> AnyObject {
        return TyphoonDefinition.withClass(Identity.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

}