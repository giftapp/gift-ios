//
// Created by Matan Lachmish on 21/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

struct VenueCellConstants{
    static let reuseIdentifier = String(describing: VenueCell.self)
    static let height: CGFloat = 70
    static let imageDiameter: CGFloat = 45
}

class VenueCell: UITableViewCell {

    //Views
    private var venueImageView: UIImageView!
    private var venueNameLabel: UILabel!
    private var venueAddressLabel: UILabel!
    private var distanceAmountLabel: UILabel!
    private var distanceUnitLabel: UILabel!

    //Public Properties
    var venueImageUrl: String? {
        didSet {
            if let venueImageUrl = venueImageUrl {
                let url = URL(string: venueImageUrl)
                venueImageView.kf.setImage(with: url,
                                           placeholder: UIImage(named: "venuePlaceHolder"),
                                           options: [.transition(.fade(0.2))])
            }
        }
    }

    var venueName: String? {
        didSet {
            venueNameLabel.text = venueName
        }
    }

    var venueAddress: String? {
        didSet {
            venueAddressLabel.text = venueAddress
        }
    }

    var distanceAmount: Double? {
        didSet {
            if let distanceAmount = distanceAmount {
                distanceAmountLabel.text = String(format: "%.1f", distanceAmount)
            }
        }
    }

    var distanceUnit: DistanceUnit? {
        didSet {
            distanceUnitLabel.text = distanceUnit?.localizedDescriptor()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.white

        if venueImageView == nil {
            venueImageView = UIImageView(image: nil) //Image is being set from public varaiable
            venueImageView.layer.cornerRadius = VenueCellConstants.imageDiameter / 2
            venueImageView.layer.masksToBounds = true
            venueImageView.layer.borderWidth = 1.0
            venueImageView.layer.borderColor = UIColor.gftSeparatorColor().cgColor
            self.addSubview(venueImageView)
        }


        if venueNameLabel == nil {
            venueNameLabel = UILabel()
            venueNameLabel.textAlignment = NSTextAlignment.right
            venueNameLabel.font = UIFont(name: "Rubik-Regular", size: 20.0) //TODO move to fonts?
            venueNameLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(venueNameLabel)
        }

        if venueAddressLabel == nil {
            venueAddressLabel = UILabel()
            venueAddressLabel.textAlignment = NSTextAlignment.right
            venueAddressLabel.font = UIFont(name: "Rubik-Light", size: 15.0) //TODO move to fonts?
            venueAddressLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(venueAddressLabel)
        }

        if distanceAmountLabel == nil {
            distanceAmountLabel = UILabel()
            distanceAmountLabel.textAlignment = NSTextAlignment.left
            distanceAmountLabel.font = UIFont(name: "Rubik-Light", size: 20.0) //TODO move to fonts?
            distanceAmountLabel.textColor = UIColor.gftAzureColor()
            self.addSubview(distanceAmountLabel)
        }

        if distanceUnitLabel == nil {
            distanceUnitLabel = UILabel()
            distanceUnitLabel.textAlignment = NSTextAlignment.left
            distanceUnitLabel.font = UIFont(name: "Rubik-Light", size: 13.0) //TODO move to fonts?
            distanceUnitLabel.textColor = UIColor.gftAzureColor()
            self.addSubview(distanceUnitLabel)
        }

    }

    private func setConstraints() {
        venueImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(venueImageView.superview!)
            make.right.equalTo(venueImageView.superview!).offset(-10)
            make.size.equalTo(VenueCellConstants.imageDiameter)
        }

        venueNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(venueNameLabel.superview!).offset(15)
            make.right.equalTo(venueImageView.snp.left).offset(-14)
            make.left.greaterThanOrEqualTo(distanceAmountLabel.snp.right).offset(10)
        }

        venueAddressLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(venueAddressLabel.superview!).offset(-14)
            make.right.equalTo(venueNameLabel)
            make.left.greaterThanOrEqualTo(distanceAmountLabel.snp.right).offset(10)
        }

        distanceAmountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(distanceAmountLabel.superview!)
            make.left.equalTo(distanceUnitLabel.snp.right).offset(2)
            distanceAmountLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal) //FIXME: I am not a fan of this solution
        }

        distanceUnitLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(distanceAmountLabel).offset(-2)
            make.left.equalTo(distanceUnitLabel.superview!).offset(16)
            distanceUnitLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal) //FIXME: I am not a fan of this solution
        }

    }

}
