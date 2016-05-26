//
// Created by Matan Lachmish on 24/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController : UIViewController, WelcomeViewDelegate {
    
    var welcomeView : WelcomeView!
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.welcomeView =  WelcomeView(frame: self.view!.frame)
        self.welcomeView.delegate = self
        view.addSubview(welcomeView)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - WelcomeViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapContinue() {
        let assembly = ModelAssembly().activate()
        let loginViewController = assembly.loginViewController() as! LoginViewController
        
        let navigationViewController = UINavigationController()
        navigationViewController.navigationBar.translucent = false;
        navigationViewController.viewControllers = [loginViewController]
        
        self.presentViewController(navigationViewController, animated: true, completion: nil)
    }
}
