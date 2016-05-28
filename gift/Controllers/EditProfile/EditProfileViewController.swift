//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class EditProfileViewController : UIViewController {

    // Injections
    var appRoute : AppRoute
    var identity : Identity
    var facebookClient : FacebookClient
    var giftServiceCoreClient : GiftServiceCoreClient

    //Views
    private var loginWithFaceBookButton: UIButton = UIButton()

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          identity : Identity,
                          facebookClient : FacebookClient,
                          giftServiceCoreClient : GiftServiceCoreClient) {
        self.appRoute = appRoute
        self.identity = identity
        self.facebookClient = facebookClient
        self.giftServiceCoreClient = giftServiceCoreClient
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",style: .Done, target: self, action: #selector(doneTapped))

        self.addCustomViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setConstraints()
    }
    
    func addCustomViews() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.loginWithFaceBookButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        self.loginWithFaceBookButton.backgroundColor = UIColor.blueColor()
        self.loginWithFaceBookButton.addTarget(self, action: #selector(loginWithFacebookTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.loginWithFaceBookButton)
        
        
    }
    
    func setConstraints() {        
        constrain(loginWithFaceBookButton) { loginWithFaceBookButton in
            loginWithFaceBookButton.center == loginWithFaceBookButton.superview!.center
        }
    }

    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func doneTapped() {
        
        self.appRoute.dismiss(self, animated: true, completion: nil)
    }

    func loginWithFacebookTapped(sender:UIButton!) {
        self.facebookClient.login(viewController: self) { (error, facebookToken) in
            if (error) {
                print ("error while login with facebook")
            } else {
                self.giftServiceCoreClient.setFacebookAccount(facebookToken!, success: { (user) in
                    print ("Succsessfully got user from facebook")
                    self.identity.setIdentity(user, token: self.identity.token)
                    self.appRoute.dismiss(self, animated: true, completion: nil)
                    }, failure: { (error) in
                        print (error)
                })
            }
        }
    }
}
