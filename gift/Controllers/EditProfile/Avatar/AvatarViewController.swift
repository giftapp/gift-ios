//
// Created by Matan Lachmish on 13/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

enum AvatarViewControllerEmptyState {
    case image(image: UIImage?)
    case initials(fromString: String?)
}

class AvatarViewController: UIViewController, AvatarViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //Public Properties
    var isEditable: Bool = false {
        didSet {
            avatarView.editLabel.isHidden = !isEditable
        }
    }

    var emptyState: AvatarViewControllerEmptyState = .image(image: UIImage(named: "emptyAvatarPlaceHolder")) {
        didSet {
            switch emptyState {
            case let .image(image):
                avatarView.emptyImagePlaceholder = image
            case let .initials(fromString):
                avatarView.initialsPlaceHolder = fromString
            }
        }
    }
    
    var image: UIImage? {
        return avatarView.image
    }


    //Views
    private lazy var avatarView: AvatarView! = AvatarView()

    //Controllers
    private lazy var imagePicker: UIImagePickerController! = UIImagePickerController()

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init() {
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
    }

    private func addCustomViews() {
            avatarView.delegate = self
            self.view = avatarView
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func showImagePickerActionSheet() {
        let actionSheetController = UIAlertController(title: "AvatarViewController.Choose an image".localized, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Global.Cancel".localized, style: .cancel);
        actionSheetController.addAction(cancelActionButton)

        let saveActionButton: UIAlertAction = UIAlertAction(title: "AvatarViewController.Camera".localized, style: .default)
        { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(saveActionButton)

        let deleteActionButton: UIAlertAction = UIAlertAction(title: "AvatarViewController.Photo Library".localized, style: .default)
        { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(deleteActionButton)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    //-------------------------------------------------------------------------------------------
    // MARK: - AvatarViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapEdit() {
        if !isEditable {
            return
        }
        
        showImagePickerActionSheet()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UIImagePickerControllerDelegate
    //-------------------------------------------------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarView.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
