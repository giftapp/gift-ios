//
// Created by Matan Lachmish on 23/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class CreateCoupleViewController: UIViewController, CreateCoupleViewDelegate, ContactDetailsViewDelegate, UITextFieldDelegate {

    // Injections
    private var appRoute: AppRoute
    private var eventService: EventService

    //Views
    private var createCoupleView: CreateCoupleView!

    //Public Properties
    var selectedVenue: Venue?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          eventService: EventService) {
        self.appRoute = appRoute
        self.eventService = eventService
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
            createCoupleView.contact1DetailsView.delegate = self
            createCoupleView.contact2DetailsView.delegate = self
            createCoupleView.textFieldDelegate = self
            self.view = createCoupleView
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func showContactDetailSourceActionSheet(contactIndex: ContactIndex) {
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

    private func validateContactDetails() -> Bool {
        return !createCoupleView.contact1DetailsView.lastName!.isEmpty &&
                !createCoupleView.contact1DetailsView.firstName!.isEmpty &&
                !createCoupleView.contact1DetailsView.phoneNumber!.isEmpty &&
                createCoupleView.contact1DetailsView.phoneNumber!.isValidPhoneNumber
                &&
                !createCoupleView.contact2DetailsView.lastName!.isEmpty &&
                !createCoupleView.contact2DetailsView.firstName!.isEmpty &&
                !createCoupleView.contact2DetailsView.phoneNumber!.isEmpty &&
                createCoupleView.contact2DetailsView.phoneNumber!.isValidPhoneNumber
                &&
                !(createCoupleView.contact1DetailsView.phoneNumber! == createCoupleView.contact2DetailsView.phoneNumber!)

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - CreateCoupleViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapAddDetails(contactIndex: ContactIndex) {
        showContactDetailSourceActionSheet(contactIndex: contactIndex)
    }

    func didTapDeleteDetails(contactIndex: ContactIndex) {
        createCoupleView.shouldShowContactDetails(shouldShowContactDetails: false, forContactIndex: contactIndex)
        switch contactIndex {
        case .a:
            createCoupleView.contact1DetailsView.clearData()
        case .b:
            createCoupleView.contact2DetailsView.clearData()
        }
    }

    func didTapContinue() {
        Logger.debug("User tapped to continue")
        eventService.createEvent(contact1FirstName: createCoupleView.contact1DetailsView.firstName!,
                contact1LastName: createCoupleView.contact1DetailsView.lastName!,
                contact1PhoneNumber: createCoupleView.contact1DetailsView.phoneNumber!,
                contact2FirstName: createCoupleView.contact2DetailsView.firstName!,
                contact2LastName: createCoupleView.contact2DetailsView.lastName!,
                contact2PhoneNumber: createCoupleView.contact2DetailsView.phoneNumber!,
                venueId: (selectedVenue?.id)!,
                success: { (event) in
                    Logger.debug("Successfully created event")
                    self.appRoute.dismiss(controller: self, animated: true)
                    //TODO: offer similar events
                },
                failure: { (error) in
                    Logger.error("Failed to create event")
                    //TODO: error handling
                })
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - ContactDetailsViewDelegate
    //-------------------------------------------------------------------------------------------
    func didUpdate() {
        let shouldEnableContinueButton = validateContactDetails()
        createCoupleView.enableContinueButton(enabled: shouldEnableContinueButton)
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
