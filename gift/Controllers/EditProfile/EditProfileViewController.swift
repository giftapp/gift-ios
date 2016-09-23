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

    //Controllers
    private var avatarViewController: AvatarViewController!

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
        if avatarViewController == nil {
            avatarViewController = AvatarViewController()
            avatarViewController.isEditable = true
            avatarViewController.emptyState = .image(image: UIImage(named: "emptyAvatarPlaceHolder"))
            self.addChildViewController(avatarViewController)
            avatarViewController.didMove(toParentViewController: self)
        }

        if editProfileView == nil {
            editProfileView = EditProfileView(avatarView: avatarViewController.view)
            editProfileView.delegate = self
            self.view = editProfileView
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func updateUserProfile(avatarUrl: String? = nil, completion: @escaping () -> Void) {
        giftServiceCoreClient.updateUserProfile(firstName: editProfileView.firstName, lastName: editProfileView.lastName, email: editProfileView.email, avatarUrl: avatarUrl, success: { (user) in
            Logger.debug("Successfully updated user profile")
            completion()
            self.identity.updateUser(user: user)
            self.appRoute.dismiss(controller: self, animated: true, completion: nil)
        }) { (error) in
            Logger.error("error while updating user profile: \(error)")
            completion()
            self.showErrorUpdatingProfile()
        }
    }

    func uploadAvatar(success: @escaping (_ imageUrl : String?) -> Void) {
        if avatarViewController.image == nil {
            success(nil)
            return
        }
        
        giftServiceCoreClient.uploadImage(image: avatarViewController.image!, success: { (avatarUrl) in
            Logger.debug("Successfully uploaded avatar")
            success(avatarUrl)
        }) { (error) in
            Logger.error("error while uploading avatar: \(error)")
            self.showErrorUpdatingProfile()
        }
    }

    func showErrorUpdatingProfile() {
        let tryAgainAction = AlertViewAction(title: "Global.Try again".localized, style: .cancel, action: nil)
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "EditProfileViewController.Alert failed updating user profile.Title".localized, description: "EditProfileViewController.Alert failed updating user profile.Description".localized, image: nil, actions: [tryAgainAction])
        self.present(alertViewController, animated: true, completion: nil)
    }

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
        editProfileView.activityAnimation(shouldAnimate: true)
        uploadAvatar(success: { (avatarUrl) in
            self.updateUserProfile(avatarUrl: avatarUrl, completion: { 
                self.editProfileView.activityAnimation(shouldAnimate: false)
            })
        })
    }
}
