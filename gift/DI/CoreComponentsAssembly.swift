//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class CoreComponentsAssembly : TyphoonAssembly {

    public var viewControllersAssembly: ViewControllersAssembly!

    private dynamic func configureLog() {
        Logger.configureLog()
    }

    public dynamic func developerTools() -> Any {
        return TyphoonDefinition.withClass(DeveloperTools.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(DeveloperTools.init(appRoute:identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.appRoute())
                initializer?.injectParameter(with: self.identity())
            }
        }
    }
    
    public dynamic func facebookClient() -> Any {
        return TyphoonDefinition.withClass(FacebookClient.self) {
            (definition) in
            definition!.scope = TyphoonScope.singleton
        }
    }

    public dynamic func giftServiceCoreClient() -> Any {
        return TyphoonDefinition.withClass(GiftServiceCoreClient.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(GiftServiceCoreClient.init(identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.identity())
            }
        }
    }

    public dynamic func appRoute() -> Any {
        return TyphoonDefinition.withClass(AppRoute.self) {
            (definition) in
            definition!.scope = TyphoonScope.singleton
        }
    }
    
    public dynamic func launcher() -> Any {
        return TyphoonDefinition.withClass(Launcher.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(Launcher.init(appRoute:welcomeViewController:loginViewController:editProfileViewController:mainTabViewController:identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.appRoute())
                initializer?.injectParameter(with: self.viewControllersAssembly.welcomeViewController())
                initializer?.injectParameter(with: self.viewControllersAssembly.loginViewController())
                initializer?.injectParameter(with: self.viewControllersAssembly.editProfileViewController())
                initializer?.injectParameter(with: self.viewControllersAssembly.mainTabViewController())
                initializer?.injectParameter(with: self.identity())
            }
        }
    }
    
    public dynamic func identity() -> Any {
        return TyphoonDefinition.withClass(Identity.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
        }
    }
    
    public dynamic func locationManager() -> Any {
        return TyphoonDefinition.withClass(LocationManager.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Services
    //-------------------------------------------------------------------------------------------
    public dynamic func authenticationService() -> Any {
        return TyphoonDefinition.withClass(AuthenticationService.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(AuthenticationService.init(giftServiceCoreClient:identity:))) {
                (initializer) in
                initializer?.injectParameter(with: self.giftServiceCoreClient())
                initializer?.injectParameter(with: self.identity())
            }
        }
    }

    public dynamic func userService() -> Any {
        return TyphoonDefinition.withClass(UserService.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(UserService.init(giftServiceCoreClient:))) {
                (initializer) in
                initializer?.injectParameter(with: self.giftServiceCoreClient())
            }
        }
    }


    public dynamic func venueService() -> Any {
        return TyphoonDefinition.withClass(VenueService.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(VenueService.init(giftServiceCoreClient:))) {
                (initializer) in
                initializer?.injectParameter(with: self.giftServiceCoreClient())
            }
        }
    }

    public dynamic func eventService() -> Any {
        return TyphoonDefinition.withClass(EventService.self) {
            (definition) in
            definition?.scope = TyphoonScope.singleton
            definition?.useInitializer(#selector(EventService.init(giftServiceCoreClient:))) {
                (initializer) in
                initializer?.injectParameter(with: self.giftServiceCoreClient())
            }
        }
    }

}
