//
// Created by Matan Lachmish on 22/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Cartography
import NVActivityIndicatorView

struct ActivityIndicatorSize{
    static let Medium: CGFloat = 35
}

class ActivityIndicatorView: UIView {

    //Private Properties
    private var activityIndicatorView : NVActivityIndicatorView!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .LineScale, color: UIColor.gftAzureColor(), padding: nil)
        self.addSubview(activityIndicatorView)
    }

    private func setConstraints() {
        constrain(activityIndicatorView) { activityIndicatorView in
            activityIndicatorView.center == activityIndicatorView.superview!.center
            activityIndicatorView.height == activityIndicatorView.superview!.height
            activityIndicatorView.width == activityIndicatorView.superview!.width
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func startAnimation() {
        self.activityIndicatorView.startAnimating()
    }

    func stopAnimation() {
        self.activityIndicatorView.stopAnimating()
    }
}
