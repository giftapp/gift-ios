//
// Created by Matan Lachmish on 01/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupNavigationBarStyle() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.barTintColor = UIColor.gftWaterBlueColor()
        self.navigationController!.navigationBar.tintColor = UIColor.gftWhiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.gftNavigationTitleFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()]
    }
}
