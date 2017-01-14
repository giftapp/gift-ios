//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, EditProfileViewDelegate, UITextFieldDelegate {

    // Injections
    private var appRoute: AppRoute
    private var identity: Identity
    private var facebookClient: FacebookClient
    private var userService: UserService
    private var fileService: FileService

    //Views
    private var editProfileView: EditProfileView!

    //Controllers
    private var avatarViewController: AvatarViewController!

    //Public Properties
    var cancelEnabled: Bool = false

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          identity: Identity,
                          facebookClient: FacebookClient,
                          userService: UserService,
                          fileService: FileService) {
        self.appRoute = appRoute
        self.identity = identity
        self.facebookClient = facebookClient
        self.userService = userService
        self.fileService = fileService
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

        self.addCustomViews()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
        updateCustomViews()
    }

    private func setupNavigationBar() {
        self.title = "EditProfileViewController.Title".localized

        self.setupNavigationBarStyle()

        let cancelBarButtonItem = UIBarButtonItem(title: "NavigationViewController.Cancel".localized, style: .plain, target: self, action: #selector(didTapCancel))
        cancelBarButtonItem.tintColor = UIColor.gftWhiteColor()
        cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.gftNavigationItemFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()], for: .normal)
        if cancelEnabled {
            self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        }
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
            editProfileView.textFieldDelegate = self

            avatarViewController.imageURL = identity.user?.avatarURL

            editProfileView.firstName = identity.user?.firstName
            editProfileView.lastName = identity.user?.lastName
            editProfileView.email = identity.user?.email

            self.view = editProfileView
        }
    }
    
    private func updateCustomViews() {
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func updateUserProfile(avatarUrl: String? = nil, success: @escaping () -> Void, failure: @escaping () -> Void) {
        userService.updateUserProfile(firstName: editProfileView.firstName, lastName: editProfileView.lastName, email: editProfileView.email, avatarUrl: avatarUrl, success: { (user) in
            Logger.debug("Successfully updated user profile")
            self.identity.updateUser(user: user)
            success()
        }) { (error) in
            Logger.error("error while updating user profile: \(error)")
            self.showErrorUpdatingProfile()
            failure()
        }
    }

    private func uploadAvatarIfNeeded(success: @escaping (_ imageUrl : String?) -> Void, failure: @escaping () -> Void) {
        if avatarViewController.image == nil {
            success(nil)
            return
        }
        
        if avatarViewController.imageURL != nil {
            success(avatarViewController.imageURL)
            return
        }

        let imageData = UIImagePNGRepresentation(avatarViewController.image!.resizeWith(width: 128)!)!
        fileService.uploadImage(imageData: imageData, success: { (avatarUrl) in
            Logger.debug("Successfully uploaded avatar")
            success(avatarUrl)
        }) { (error) in
            Logger.error("error while uploading avatar: \(error)")
            failure()
        }
    }

    private func showErrorUpdatingProfile() {
        let tryAgainAction = AlertViewAction(title: "Global.Try again".localized, style: .cancel, action: nil)
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "EditProfileViewController.Alert failed updating user profile.Title".localized, description: "EditProfileViewController.Alert failed updating user profile.Description".localized, image: nil, actions: [tryAgainAction])
        self.present(alertViewController, animated: true, completion: nil)
    }

    func didTapCancel() {
        //Return default values
        avatarViewController.imageURL = identity.user?.avatarURL

        editProfileView.firstName = identity.user?.firstName
        editProfileView.lastName = identity.user?.lastName
        editProfileView.email = identity.user?.email

        self.appRoute.dismiss(controller: self, animated: true)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - EditProfileViewDelegate
    //-------------------------------------------------------------------------------------------
    func didUpdateForm() {
        let shouldEnableDoneButton =
            editProfileView.firstNameTextField.isInputValid() &&
            editProfileView.lastNameTextField.isInputValid() &&
            editProfileView.emailTextField.isInputValid()

        editProfileView.enableDoneButton(enabled: shouldEnableDoneButton)
    }

    func didTapLoginWithFaceBook() {
        editProfileView.activityAnimation(shouldAnimate: true)
        self.facebookClient.login(viewController: self) { (error, facebookToken) in
            if (error) {
                Logger.error("error while login with facebook")
                self.editProfileView.activityAnimation(shouldAnimate: false)
            } else {
                self.userService.setFacebookAccount(facebookAccessToken: facebookToken!, success: { (user) in
                    Logger.debug("Successfully got user from facebook")
                    self.editProfileView.activityAnimation(shouldAnimate: false)
                    self.identity.updateUser(user: user)
                    self.appRoute.dismiss(controller: self, animated: true, completion: nil)
                }, failure: { (error) in
                    Logger.error("error while updating user account with facebook account: \(error)")
                    self.editProfileView.activityAnimation(shouldAnimate: false)
                })
            }
        }
    }

    func didTapDone() {
        editProfileView.activityAnimation(shouldAnimate: true)
        
        uploadAvatarIfNeeded(success: { (avatarUrl) in
            self.updateUserProfile(avatarUrl: avatarUrl, success: {
                self.editProfileView.activityAnimation(shouldAnimate: false)
                self.appRoute.dismiss(controller: self, animated: true)
            }, failure: { 
                self.editProfileView.activityAnimation(shouldAnimate: false)
                self.showErrorUpdatingProfile()
            })
        }, failure: {
            self.editProfileView.activityAnimation(shouldAnimate: false)
            self.showErrorUpdatingProfile()
        })
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------

    //Dismiss keyboard on return
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
