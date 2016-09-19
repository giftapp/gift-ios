//
// Created by Matan Lachmish on 27/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class AppRoute : NSObject, UITabBarControllerDelegate, UINavigationControllerDelegate {

    private weak var topMostViewController : UIViewController!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func showController(controller : UIViewController) {
        let window : UIWindow = UIApplication.shared.keyWindow!

        if window.rootViewController != nil {
            window.rootViewController!.dismiss(animated: false, completion: nil)
        }
        
        window.rootViewController = controller
        self.switchTopMost(controller: controller)
    }

    func pushViewController(controller : UIViewController, animated : Bool) {
        var controllerToPushFrom = self.topMostViewController
        if (controllerToPushFrom?.isKind(of: UITabBarController.self))! {
            controllerToPushFrom = (controllerToPushFrom as! UITabBarController).selectedViewController
        }

        if !(controllerToPushFrom?.isKind(of: UINavigationController.self))! && controllerToPushFrom?.navigationController == nil {
            Logger.error("Cannot push, presented controller is not a UINavigationController")
            print (controllerToPushFrom)
            return
        }

        if controller.isEqual(controllerToPushFrom) {
            Logger.warning("Cannot push, presented controller is not a UINavigationController")
            return
        }

        let navigationController : UINavigationController
        if controllerToPushFrom?.navigationController != nil {
            navigationController = (controllerToPushFrom?.navigationController!)!
        } else {
            navigationController = controllerToPushFrom as! UINavigationController
        }
        navigationController.pushViewController(controller, animated: animated)

        self.switchTopMost(controller: controller)

    }

    func pop(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let navigationController = controller.navigationController
        controller.navigationController!.popViewController(animated: animated)
        self.switchTopMost(controller: navigationController!.topViewController!)
    }

    func presentController(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let window : UIWindow = UIApplication.shared.keyWindow!

        if window.rootViewController!.presentedViewController != nil {
            window.rootViewController?.dismiss(animated: animated, completion: { 
                window.rootViewController?.present(controller, animated: animated, completion: completion)
            })
        } else {
            window.rootViewController?.present(controller, animated: animated, completion: completion)
        }

        self.switchTopMost(controller: controller)
    }

    func dismiss(controller : UIViewController, animated : Bool, completion: (() -> Void)?) {
        let presentingViewController = controller.presentingViewController
        presentingViewController!.dismiss(animated: animated, completion: completion)
        self.switchTopMost(controller: presentingViewController!)
    }

    func switchTopMost(controller : UIViewController) {
        self.topMostViewController = controller

        if controller.isKind(of: UINavigationController.self) {
            let navigationController = controller as! UINavigationController
            navigationController.delegate = self
            self.switchTopMost(controller: navigationController.topViewController!)
        } else if controller.isKind(of: UITabBarController.self) {
            let tabBarController = controller as! UITabBarController
            tabBarController.delegate = self
            self.switchTopMost(controller: tabBarController.selectedViewController!)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UINavigationControllerDelegate
    //-------------------------------------------------------------------------------------------
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.switchTopMost(controller: viewController)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITabBarControllerDelegate
    //-------------------------------------------------------------------------------------------
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.switchTopMost(controller: viewController)
    }

}
