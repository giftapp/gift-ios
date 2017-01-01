//
// Created by Matan Lachmish on 23/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class CreateCoupleViewController: UIViewController, CreateCoupleViewDelegate, ContactDetailsViewDelegate, UITextFieldDelegate, CNContactPickerDelegate {

    // Injections
    private var appRoute: AppRoute
    private var eventService: EventService

    //Views
    private var createCoupleView: CreateCoupleView!

    //Controllers
    private var contact1Picker: CNContactPickerViewController!
    private var contact2Picker: CNContactPickerViewController!

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

        if contact1Picker == nil {
            contact1Picker = CNContactPickerViewController()
            contact1Picker.delegate = self
        }

        if contact2Picker == nil {
            contact2Picker = CNContactPickerViewController()
            contact2Picker.delegate = self
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func getContactDetailView(for contactIndex: ContactIndex) -> ContactDetailsView {
        switch contactIndex {
        case .a:
            return createCoupleView.contact1DetailsView
        case .b:
            return createCoupleView.contact2DetailsView
        }
    }

    private func getContactPicker(for contactIndex: ContactIndex) -> CNContactPickerViewController {
        switch contactIndex {
        case .a:
            return contact1Picker
        case .b:
            return contact2Picker
        }
    }

    private func showContactDetailSourceActionSheet(contactIndex: ContactIndex) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Global.Cancel".localized, style: .cancel);
        actionSheetController.addAction(cancelActionButton)

        let addressBookButton: UIAlertAction = UIAlertAction(title: "CreateCoupleViewController.Add from address book".localized, style: .default)
        { action -> Void in
            let contactPicker = self.getContactPicker(for: contactIndex)
            self.present(contactPicker, animated: true, completion: nil)
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

    private func alertDeletingContactInfo(contactIndex: ContactIndex) {
        let deleteAction = AlertViewAction(title: "CreateCoupleViewController.Delete contact alert.Delete".localized, style: .regular, action: {
            self.deleteContactDetails(contactIndex: contactIndex)
        })
        let cancelAction = AlertViewAction(title: "Global.Cancel".localized, style: .cancel, action: nil)
        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "CreateCoupleViewController.Delete contact alert.Title".localized, description: "CreateCoupleViewController.Delete contact alert.Description".localized, image: nil, actions: [deleteAction, cancelAction])
        self.present(alertViewController, animated: true, completion: nil) //TODO: should this be using appRoute?
    }

    private func deleteContactDetails(contactIndex: ContactIndex) {
        let contactDetailsView = getContactDetailView(for: contactIndex)
        createCoupleView.shouldShowContactDetails(shouldShowContactDetails: false, forContactIndex: contactIndex)
        contactDetailsView.clearData()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - CreateCoupleViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapAddDetails(contactIndex: ContactIndex) {
        showContactDetailSourceActionSheet(contactIndex: contactIndex)
    }

    func didTapDeleteDetails(contactIndex: ContactIndex) {
        let contactDetailsView = getContactDetailView(for: contactIndex)
        if contactDetailsView.isNotEmpty() {
            alertDeletingContactInfo(contactIndex: contactIndex)
        } else {
            deleteContactDetails(contactIndex: contactIndex)
        }
    }

    func didTapContinue() {
        Logger.debug("User tapped to continue")
        createCoupleView.activityAnimation(shouldAnimate: true)
        eventService.createEvent(contact1FirstName: createCoupleView.contact1DetailsView.firstName!,
                contact1LastName: createCoupleView.contact1DetailsView.lastName!,
                contact1PhoneNumber: createCoupleView.contact1DetailsView.phoneNumber!,
                contact2FirstName: createCoupleView.contact2DetailsView.firstName!,
                contact2LastName: createCoupleView.contact2DetailsView.lastName!,
                contact2PhoneNumber: createCoupleView.contact2DetailsView.phoneNumber!,
                venueId: (selectedVenue?.id)!,
                success: { (event) in
                    Logger.debug("Successfully created event")
                    self.createCoupleView.activityAnimation(shouldAnimate: false)
                    self.appRoute.dismiss(controller: self, animated: true)
                    //TODO: offer similar events
                },
                failure: { (error) in
                    Logger.error("Failed to create event")
                    self.createCoupleView.activityAnimation(shouldAnimate: false)
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
    
    //-------------------------------------------------------------------------------------------
    // MARK: - CNContactPickerDelegate
    //-------------------------------------------------------------------------------------------
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        Logger.debug("Did select contact from picker")
        //TODO: choose which phone number in case of multiple options
        picker.dismiss(animated: true, completion: nil)

        let firstName = contact.givenName
        let lastName = contact.familyName
        var phoneNumber = ""
        if contact.phoneNumbers.first != nil {
            phoneNumber = contact.phoneNumbers.first!.value.stringValue.plainPhoneNumber()
        }

        if picker == contact1Picker {
            createCoupleView.shouldShowContactDetails(shouldShowContactDetails: true, forContactIndex: .a)
            createCoupleView.contact1DetailsView.firstName = firstName
            createCoupleView.contact1DetailsView.lastName = lastName
            createCoupleView.contact1DetailsView.phoneNumber = phoneNumber
        } else {
            createCoupleView.shouldShowContactDetails(shouldShowContactDetails: true, forContactIndex: .b)
            createCoupleView.contact2DetailsView.firstName = firstName
            createCoupleView.contact2DetailsView.lastName = lastName
            createCoupleView.contact2DetailsView.phoneNumber = phoneNumber
        }
    }


}
