//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, EditProfileViewDelegate {

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
        self.navigationController!.navigationBar.barStyle = .black
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

        editProfileView.enableDoneButton(enabled: shouldEnableDoneButton)
    }

    func didTapLoginWithFaceBook() {
        self.facebookClient.login(viewController: self) { (error, facebookToken) in
            if (error) {
                Logger.error("error while login with facebook")
            } else {
                self.giftServiceCoreClient.setFacebookAccount(facebookAccessToken: facebookToken!, success: { (user) in
                    Logger.debug("Successfully got user from facebook")
                    self.identity.updateUser(user: user)
                    self.appRoute.dismiss(controller: self, animated: true, completion: nil)
                }, failure: { (error) in
                    Logger.error("error while updating user account with facebook account: \(error)")
                })
            }
        }
    }

    func didTapDone() {
        self.appRoute.dismiss(controller: self, animated: true, completion: nil)
    }
}
