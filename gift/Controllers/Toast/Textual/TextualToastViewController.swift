//
// Created by Matan Lachmish on 10/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class TextualToastViewController: UIViewController, TextualToastViewDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Injections
    private var appRoute: AppRoute
    private var identity: Identity
    private var toastService: ToastService
    private var fileService: FileService

    //Views
    private var textualToastView: TextualToastView!

    //Controllers
    private lazy var imagePicker: UIImagePickerController! = UIImagePickerController()

    //Public Properties
    var selectedEvent: Event?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          identity: Identity,
                          toastService: ToastService,
                          fileService: FileService) {
        self.appRoute = appRoute
        self.identity = identity
        self.toastService = toastService
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
        self.title = "TextualToastViewController.Title".localized
    }

    private func addCustomViews() {
        if textualToastView == nil {
            textualToastView = TextualToastView()
            textualToastView.delegate = self
            textualToastView.textFieldDelegate = self
            textualToastView.textViewDelegate = self
            self.view = textualToastView
        }
    }

    private func updateCustomViews() {
        textualToastView.descriptionText = String(format: "TextualToastViewController.Description".localized, arguments: [(selectedEvent?.contact1FirstName)!, (selectedEvent?.contact2FirstName)!])
        textualToastView.presenterName = identity.user?.fullName
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func validateInputs() -> Bool{
        return !(textualToastView.presenterName?.isEmpty)! && !(textualToastView.textualToast?.isEmpty)!
    }

    func showImagePickerActionSheet(shouldShowRemoveImage: Bool) {
        let actionSheetController = UIAlertController(title: "TextualToastViewController.Choose an image".localized, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Global.Cancel".localized, style: .cancel);
        actionSheetController.addAction(cancelActionButton)

        let cameraButton: UIAlertAction = UIAlertAction(title: "TextualToastViewController.Camera".localized, style: .default)
        { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(cameraButton)

        let photoLibraryButton: UIAlertAction = UIAlertAction(title: "TextualToastViewController.Photo Library".localized, style: .default)
        { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(photoLibraryButton)

        if shouldShowRemoveImage {
            let removePictureButton: UIAlertAction = UIAlertAction(title: "TextualToastViewController.Remove picture".localized, style: .destructive)
            { action -> Void in
                self.textualToastView.removePicture()
            }
            actionSheetController.addAction(removePictureButton)
        }

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func uploadPictureIfNeeded(picture: UIImage?,
                                       success: @escaping (_ imageUrl: String? ) -> Void,
                                       failure: @escaping (_ error: Error) -> Void) {
    
        if let picture = picture {
            let imageData = UIImagePNGRepresentation(picture)! //TODO: consider resize
            fileService.uploadImage(imageData: imageData, success: { (imageUrl) in
                Logger.debug("Successfully uploaded toast image")
                success(imageUrl)
            }, failure: { (error) in
                Logger.error("Failed to upload toast image \(error)")
                failure(error)
            })
        } else {
            success(nil)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - TextualToastViewDelegate
    //-------------------------------------------------------------------------------------------
    func didUpdatePresenterName() {
        Logger.debug("Did update presenter name")
        textualToastView.enableContinueButton(enabled: validateInputs())
    }

    func didTapAddPicture() {
        Logger.debug("Did tap add picture")
        showImagePickerActionSheet(shouldShowRemoveImage: false)
    }

    func didTapContinue() {
        Logger.debug("Did tap continue")

        textualToastView.activityAnimation(shouldAnimate: true)
        uploadPictureIfNeeded(picture: textualToastView.picture, success: { (imageUrl) in
            self.toastService.createToast(eventId: (self.selectedEvent?.id)!,
                    toastFlavor: .text,
                    giftPresenters: self.textualToastView.presenterName!,
                    imageUrl: imageUrl,
                    text: self.textualToastView.textualToast!,
                    success: { (toast) in
                        Logger.debug("Succesfuly created textual toast")
                        self.textualToastView.activityAnimation(shouldAnimate: false)
                    }, failure: { (error) in
                Logger.error("Failed to create textual toast \(error)")
                self.textualToastView.activityAnimation(shouldAnimate: false)
            })

        }, failure: { (error) in
            self.textualToastView.activityAnimation(shouldAnimate: false)
        })
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismiss keyboard on return
        textField.endEditing(true)
        return false
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextViewDelegate
    //-------------------------------------------------------------------------------------------
    func textViewDidChange(_ textView: UITextView) {
        textualToastView.enableContinueButton(enabled: validateInputs())
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UIImagePickerControllerDelegate
    //-------------------------------------------------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            textualToastView.picture = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
