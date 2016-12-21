//
// Created by Matan Lachmish on 21/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

//This view is displayed when a table view is empty
class EmptyTablePlaceholderView: UIView {

    //Views
    private var imageView: UIImageView!
    private var label: UILabel!

    //Public Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var text: String? {
        didSet {
            label.text = text
        }
    }

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
        self.backgroundColor = UIColor.clear

        if imageView == nil {
            imageView = UIImageView(image: nil) //Image is being set from public varaiable
            self.addSubview(imageView)
        }

        if label == nil {
            label = UILabel()
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.gftHeader1Font()
            label.textColor = UIColor.gftGreyishColor()
            self.addSubview(label)
        }

    }

    private func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView.superview!)
        }

        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView.superview!)
            make.top.equalTo(imageView.snp.bottom).offset(18)
        }

    }
}
