//
// Created by Matan Lachmish on 27/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class AppRoute : NSObject, UITabBarControllerDelegate, UINavigationControllerDelegate {

    private weak var topMostViewController : UIViewController!

    func showController(controller : UIViewController) {
        let window : UIWindow = UIApplication.sharedApplication().keyWindow!

        if (window.rootViewController != nil) {
            window.rootViewController!.dismissViewControllerAnimated(false, completion: nil)
        }
        
        window.rootViewController = controller
        self.switchTopMost(controller)
    }

    func pushViewController(controller : UIViewController, animated : Bool) {
        var controllerToPushFrom = self.topMostViewController
        if (controllerToPushFrom.isKindOfClass(UITabBarController)) {
            controllerToPushFrom = (controllerToPushFrom as! UITabBarController).selectedViewController
        }

        if (!controllerToPushFrom.isKindOfClass(UINavigationController) && controllerToPushFrom.navigationController == nil) {
            print ("Cannot push, presented controller is not a UINavigationController")
            print (controllerToPushFrom)
            return
        }

        if (controller.isEqual(controllerToPushFrom)) {
            print ("Skip push because controller already presented")
            return
        }

        let navigationController : UINavigationController
        if (controllerToPushFrom.navigationController != nil) {
            navigationController = controllerToPushFrom.navigationController!
        } else {
            navigationController = controllerToPushFrom as! UINavigationController
        }
        navigationController.pushViewController(controller, animated: animated)

        self.switchTopMost(controller)

    }

    func pop(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let navigationController = controller.navigationController
        controller.navigationController!.popViewControllerAnimated(animated)
        self.switchTopMost(navigationController!.topViewController!)
    }

    func presentController(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let window : UIWindow = UIApplication.sharedApplication().keyWindow!

        if (window.rootViewController!.presentedViewController != nil) {
            window.rootViewController?.dismissViewControllerAnimated(animated, completion: { 
                window.rootViewController?.presentViewController(controller, animated: animated, completion: completion)
            })
        } else {
            window.rootViewController?.presentViewController(controller, animated: animated, completion: completion)
        }

        self.switchTopMost(controller)
    }

    func dismiss(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let presentingViewController = controller.presentingViewController
        presentingViewController!.dismissViewControllerAnimated(animated, completion: completion)
        self.switchTopMost(presentingViewController!)
    }

    func switchTopMost(controller : UIViewController) {
        self.topMostViewController = controller

        if (controller.isKindOfClass(UINavigationController)) {
            let navigationController = controller as! UINavigationController
            navigationController.delegate = self
            self.switchTopMost(navigationController.topViewController!)
        } else if (controller.isKindOfClass(UITabBarController)) {
            let tabBarController = controller as! UITabBarController
            tabBarController.delegate = self
            self.switchTopMost(tabBarController.selectedViewController!)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UINavigationControllerDelegate
    //-------------------------------------------------------------------------------------------
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        self.switchTopMost(viewController)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITabBarControllerDelegate
    //-------------------------------------------------------------------------------------------
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        self.switchTopMost(viewController)
    }

}
