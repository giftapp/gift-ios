//
// Created by Matan Lachmish on 13/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker

enum AvatarViewControllerEmptyState {
    case image(image: UIImage?)
    case initials(fromString: String)
}

class AvatarViewController: UIViewController, AvatarViewDelegate, ImagePickerDelegate {

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
                avatarView.useEmptyImagePlaceholder(image: image)
            case let .initials(fromString):
                avatarView.useInitialsPlaceHolder(initials: fromString)
            }
        }
    }


    //Views
    private lazy var avatarView: AvatarView! = AvatarView()

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

    //-------------------------------------------------------------------------------------------
    // MARK: - AvatarViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapEdit() {
        if !isEditable {
            return
        }

        Configuration.recordLocation = false

        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - ImagePickerDelegate
    //-------------------------------------------------------------------------------------------
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    }

}
