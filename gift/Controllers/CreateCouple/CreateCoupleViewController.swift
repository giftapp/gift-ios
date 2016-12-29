//
// Created by Matan Lachmish on 23/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class CreateCoupleViewController: UIViewController, CreateCoupleViewDelegate, UITextFieldDelegate {

    // Injections
    private var appRoute: AppRoute

    //Views
    private var createCoupleView: CreateCoupleView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute) {
        self.appRoute = appRoute
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
    }

    private func setupNavigationBar() {
        self.title = "CreateCoupleViewController.Title".localized
    }

    private func addCustomViews() {
        if createCoupleView == nil {
            createCoupleView = CreateCoupleView()
            createCoupleView.delegate = self
            createCoupleView.textFieldDelegate = self
            self.view = createCoupleView
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func showContactDetailSourceActionSheet(contactIndex: ContactIndex) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Global.Cancel".localized, style: .cancel);
        actionSheetController.addAction(cancelActionButton)

        let addressBookButton: UIAlertAction = UIAlertAction(title: "CreateCoupleViewController.Add from address book".localized, style: .default)
        { action -> Void in
            //TODO: add from AB
        }
        actionSheetController.addAction(addressBookButton)

        let manuallyButton: UIAlertAction = UIAlertAction(title: "CreateCoupleViewController.Add manually".localized, style: .default)
        { action -> Void in
            self.createCoupleView.shouldShowContactDetails(shouldShowContactDetails: true, forContactIndex: contactIndex)
        }
        actionSheetController.addAction(manuallyButton)

        self.present(actionSheetController, animated: true, completion: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - CreateCoupleViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapAddDetails(contactIndex: ContactIndex) {
        showContactDetailSourceActionSheet(contactIndex: contactIndex)
    }

    func didTapDeleteDetails(contactIndex: ContactIndex) {
        createCoupleView.shouldShowContactDetails(shouldShowContactDetails: false, forContactIndex: contactIndex)
    }


    func didTapContinue() {
        Logger.debug("User tapped to continue")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------

    //Dismiss keyboard on return
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    //TODO: remove if unesasery
//    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //Update delegate
//        didUpdateForm()
//
//        return true
//    }

}
