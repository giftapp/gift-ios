//
// Created by Matan Lachmish on 28/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private enum SettingsTableViewSection: Int {
    case profileDetails = 0
    case payments       = 1
    case aboutGift      = 2
    case logout         = 3

    static var numberOfSections: Int {
        return 4
    }

    var numberOfRows: Int {
        switch self {
        case .profileDetails:   return SettingsTableViewProfileDetailsItem.numberOfItems
        case .payments:         return SettingsTableViewPaymentsItem.numberOfItems
        case .aboutGift:        return SettingsTableViewAboutGiftItem.numberOfItems
        case .logout:           return SettingsTableViewLogoutItem.numberOfItems
        }
    }
}

private enum SettingsTableViewProfileDetailsItem: Int {
    case phoneNumber
    case email
    
    static var numberOfItems: Int {
        return 2
    }
}

private enum SettingsTableViewPaymentsItem: Int {
    case paymentDetails
    
    static var numberOfItems: Int {
        return 1
    }
}

private enum SettingsTableViewAboutGiftItem: Int {
    case sendFeedback
    case termsAndConditions
    
    static var numberOfItems: Int {
        return 2
    }
}

private enum SettingsTableViewLogoutItem: Int {
    case logout
    
    static var numberOfItems: Int {
        return 1
    }
}

private struct SettingsTableViewDataSourceConsts{
    static let estimatedHeightForRowAt: CGFloat = 44.0
    static let heightForHeaderInSection: CGFloat = 25.0
}

class SettingsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Injections
    private var appRoute: AppRoute
    private var identity: Identity
    private var editProfileViewController: EditProfileViewController

    //Views
    private var settingsView: SettingsView!

    //Controllers
    private var avatarViewController: AvatarViewController!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute : AppRoute,
                          identity : Identity,
                          editProfileViewController: EditProfileViewController) {
        self.appRoute = appRoute
        self.identity = identity
        self.editProfileViewController = editProfileViewController
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

        setupNavigationBar()
        addCustomViews()
    }

    private func setupNavigationBar() {
        self.title = "SettingsViewController.Title".localized

        self.navigationController!.navigationBar.isTranslucent = true
        self.setupNavigationBarStyle()

        let rightBarButtonItem = UIBarButtonItem(title: "SettingsViewController.Edit".localized, style: .plain, target: self, action: #selector(didTapEdit))
        rightBarButtonItem.tintColor = UIColor.gftWhiteColor()
        rightBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.gftNavigationItemFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()], for: .normal)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    private func addCustomViews() {

        editProfileViewController.cancelEnabled = true

        if avatarViewController == nil {
            avatarViewController = AvatarViewController()
            avatarViewController.isEditable = false
            self.addChildViewController(avatarViewController)
            avatarViewController.didMove(toParentViewController: self)
        }
        
        if settingsView == nil {
            settingsView = SettingsView(avatarView: avatarViewController.view)
            settingsView.tableViewDataSource = self
            settingsView.tableViewDelegate = self
            self.view = settingsView
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //This is done in order to fix tableview header height autolayout bug: http://stackoverflow.com/questions/5581116/how-to-set-the-height-of-table-header-in-uitableview
        settingsView.updateTableViewHeaderSize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewData()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    func numberOfSections(`in` tableView: UITableView) -> Int {
        return SettingsTableViewSection.numberOfSections
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (SettingsTableViewSection(rawValue: section)?.numberOfRows)!

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let settingsTableViewSections = SettingsTableViewSection(rawValue: indexPath.section)!

        switch settingsTableViewSections {
        case .profileDetails:
            let profileDetailsItem = SettingsTableViewProfileDetailsItem(rawValue: indexPath.item)!
            switch profileDetailsItem {
            case .phoneNumber:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsProfileDetailsCellConsts.reuseIdentifier, for: indexPath) as! SettingsProfileDetailsCell
                cell.iconImage = UIImage(named: "phone")
                cell.mainText = identity.user?.phoneNumber?.formateAsPhoneNumber
                cell.selectionStyle = .none
                return cell
            case .email:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsProfileDetailsCellConsts.reuseIdentifier, for: indexPath) as! SettingsProfileDetailsCell
                cell.iconImage = UIImage(named: "envelope")
                cell.mainText = identity.user?.email
                cell.selectionStyle = .none
                return cell
            }

        case .payments:
            let paymentsItem = SettingsTableViewPaymentsItem(rawValue: indexPath.item)!
            switch paymentsItem {
            case .paymentDetails:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsPushButtonCellConsts.reuseIdentifier, for: indexPath) as! SettingsPushButtonCell
                cell.mainText = "SettingsViewController.Payments".localized
                cell.selectionStyle = .none
                return cell
            }
            
        case .aboutGift:
            let aboutGiftItem = SettingsTableViewAboutGiftItem(rawValue: indexPath.item)!
            switch aboutGiftItem {
            case .sendFeedback:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsPushButtonCellConsts.reuseIdentifier, for: indexPath) as! SettingsPushButtonCell
                cell.mainText = "SettingsViewController.Feedback".localized
                cell.selectionStyle = .none
                return cell
            case .termsAndConditions:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsPushButtonCellConsts.reuseIdentifier, for: indexPath) as! SettingsPushButtonCell
                cell.mainText = "SettingsViewController.Terms and conditions".localized
                cell.selectionStyle = .none
                return cell
            }
            
        case .logout:
            let logoutItem = SettingsTableViewLogoutItem(rawValue: indexPath.item)!
            switch logoutItem {
            case .logout:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsModalButtonCellConsts.reuseIdentifier, for: indexPath) as! SettingsModalButtonCell
                cell.mainText = "SettingsViewController.Logout".localized
                cell.selectionStyle = .none
                return cell
            }
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewDataSourceConsts.estimatedHeightForRowAt
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }

        return SettingsTableViewDataSourceConsts.heightForHeaderInSection
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsTableViewSections = SettingsTableViewSection(rawValue: indexPath.section)!
        
        switch settingsTableViewSections {
        case .profileDetails:
            let profileDetailsItem = SettingsTableViewProfileDetailsItem(rawValue: indexPath.item)!
            switch profileDetailsItem {
            case .phoneNumber:
                return
            case .email:
                return
            }
            
        case .payments:
            let paymentsItem = SettingsTableViewPaymentsItem(rawValue: indexPath.item)!
            switch paymentsItem {
            case .paymentDetails:
                return
            }
            
        case .aboutGift:
            let aboutGiftItem = SettingsTableViewAboutGiftItem(rawValue: indexPath.item)!
            switch aboutGiftItem {
            case .sendFeedback:
                return
            case .termsAndConditions:
                return
            }
            
        case .logout:
            let logoutItem = SettingsTableViewLogoutItem(rawValue: indexPath.item)!
            switch logoutItem {
            case .logout:
                didTapLogout()
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func updateViewData() {
        avatarViewController.emptyState = .initials(fromString: identity.user?.fullName?.initials)
        avatarViewController.imageURL = identity.user?.avatarURL
        settingsView.name = identity.user?.fullName
        settingsView.updateTableData()
    }
    
    func didTapEdit() {
        let editProfileNavigationViewController = UINavigationController(rootViewController: editProfileViewController)
        editProfileNavigationViewController.navigationBar.isTranslucent = false;
        editProfileNavigationViewController.modalTransitionStyle = .crossDissolve
        self.appRoute.presentController(controller: editProfileNavigationViewController, animated: true, completion: nil)
    }
    
    func didTapLogout() {
        let logoutAction = AlertViewAction(title: "SettingsViewController.Logout".localized, style: .regular) {
            self.identity.logout()
        }
        let cancelAction = AlertViewAction(title: "Global.Cancel".localized, style: .cancel, action: nil)

        let alertViewController = AlertViewControllerFactory.createAlertViewController(title: "SettingsViewController.Alert logout.Title".localized, description: nil, image: nil, actions: [logoutAction, cancelAction])
        self.present(alertViewController, animated: true, completion: nil)
    }
}
