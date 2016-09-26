//
// Created by Matan Lachmish on 20/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import PMAlertController

enum AlertViewControllerFactoryActionStyle {
    case regular
    case cancel

    func getPMAlertActionStyle() -> PMAlertActionStyle{
        switch self {
        case .regular:
            return PMAlertActionStyle.`default`
        case .cancel:
            return PMAlertActionStyle.cancel
        }
    }
}

struct AlertViewAction {
    let title: String
    let style: AlertViewControllerFactoryActionStyle
    let action: (() -> Void)?
}

struct AlertViewControllerFactory {

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    static func createAlertViewController(title: String, description: String?, image: UIImage?, actions: [AlertViewAction]) -> UIViewController {
        let alertViewController = PMAlertController(title: title, description: description ?? "", image: image, style: .alert)
        for alertViewAction in actions {
            alertViewController.addAction(PMAlertAction(title: alertViewAction.title, style: alertViewAction.style.getPMAlertActionStyle(), action: alertViewAction.action))
        }
        return alertViewController
    }

}
