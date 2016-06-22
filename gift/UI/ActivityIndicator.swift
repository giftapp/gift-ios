//
// Created by Matan Lachmish on 22/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct ActivityIndicatorSize{
    static let Medium: CGFloat = 35
}

class ActivityIndicator {

    //Private Properties
    private let activityIndicatorView : NVActivityIndicatorView

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    private init(frame: CGRect) {
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0,0,0,0), type: .LineScale, color: UIColor.gftAzureColor(), padding: nil)
        self.activityIndicatorView.hidden = true
    }

    static func getActivityIndicator() -> ActivityIndicator {
        return ActivityIndicator()
    }
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getView() -> UIView {
        return self.activityIndicatorView
    }

    func startAnimation() {
        self.activityIndicatorView.hidden = false
        self.activityIndicatorView.startAnimation()
    }

    func stopAnimation() {
        self.activityIndicatorView.hidden = true
        self.activityIndicatorView.stopAnimation()
    }
}
