//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

class EditProfileViewController: UIViewController, EditProfileViewDelegate {

    private let log = XCGLogger.defaultInstance()

    // Injections
    private var appRoute: AppRoute
    private var identity: Identity
    private var facebookClient: FacebookClient
    private var giftServiceCoreClient: GiftServiceCoreClient

    //Views
    private var editProfileView: EditProfileView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          identity: Identity,
                          facebookClient: FacebookClient,
                          giftServiceCoreClient: GiftServiceCoreClient) {
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

        self.title = "EditProfileViewController.Title".localized
        self.navigationController!.navigationBar.barStyle = .Black
        self.navigationController!.navigationBar.barTintColor = UIColor.gftWaterBlueColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.gftNavigationTitleFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()]

        self.addCustomViews()
    }

    private func addCustomViews() {
        if editProfileView == nil {
            editProfileView = EditProfileView()
            self.editProfileView.delegate = self
            self.view = editProfileView
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - EditProfileViewDelegate
    //-------------------------------------------------------------------------------------------
    func didUpdateForm() {
        let shouldEnableDoneButton =
            !(editProfileView.firstName ?? "").isEmpty &&
            !(editProfileView.lastName ?? "").isEmpty &&
            (editProfileView.email ?? "").isValidEmail

        editProfileView.enableDoneButton(shouldEnableDoneButton)
    }

    func didTapLoginWithFaceBook() {
        self.facebookClient.login(viewController: self) { (error, facebookToken) in
            if (error) {
                self.log.error("error while login with facebook")
            } else {
                self.giftServiceCoreClient.setFacebookAccount(facebookToken!, success: { (user) in
                    self.log.debug("Successfully got user from facebook")
                    self.identity.updateUser(user)
                    self.appRoute.dismiss(self, animated: true, completion: nil)
                }, failure: { (error) in
                    self.log.error("error while updating user account with facebook account: \(error)")
                })
            }
        }
    }

    func didTapDone() {
        self.appRoute.dismiss(self, animated: true, completion: nil)
    }
}
