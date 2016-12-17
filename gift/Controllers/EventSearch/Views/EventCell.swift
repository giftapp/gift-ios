//
// Created by Matan Lachmish on 10/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct EventCellConstants{
    static let reuseIdentifier = String(describing: EventCell.self)
    static let height: CGFloat = 50
}

enum EventCellDistanceUnit {
    case kiloMeter
    case meter

    func localizedDescriptor() -> String {
        switch self {
        case .meter:
            return "EventCellDistanceUnit.meter".localized
        case .kiloMeter:
            return "EventCellDistanceUnit.kilo-meter".localized
        }
    }
}

class EventCell: UITableViewCell {

    //Views
    private var eventNameLabel: UILabel!
    private var venueNameLabel: UILabel!
    private var distanceAmountLabel: UILabel!
    private var distanceUnitLabel: UILabel!

    //Public Properties
    var eventName: String? {
        didSet {
            eventNameLabel.text = eventName
        }
    }

    var venueName: String? {
        didSet {
            venueNameLabel.text = venueName
        }
    }

    var distanceAmount: Double? {
        didSet {
            if let distanceAmount = distanceAmount {
                distanceAmountLabel.text = String(format: "%.1f", distanceAmount)
            }
        }
    }

    var distanceUnit: EventCellDistanceUnit? {
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

        if eventNameLabel == nil {
            eventNameLabel = UILabel()
            eventNameLabel.textAlignment = NSTextAlignment.right
            eventNameLabel.font = UIFont(name: "Rubik-Regular", size: 15.0) //TODO move to fonts?
            eventNameLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(eventNameLabel)
        }

        if venueNameLabel == nil {
            venueNameLabel = UILabel()
            venueNameLabel.textAlignment = NSTextAlignment.right
            venueNameLabel.font = UIFont(name: "Rubik-Light", size: 13.0) //TODO move to fonts?
            venueNameLabel.textColor = UIColor.gftBlackColor()
            self.addSubview(venueNameLabel)
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
        eventNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(eventNameLabel.superview!).offset(8)
            make.right.equalTo(eventNameLabel.superview!).offset(-16)
        }

        venueNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(venueNameLabel.superview!).offset(-8)
            make.right.equalTo(eventNameLabel)
        }

        distanceAmountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(distanceAmountLabel.superview!)
            make.left.equalTo(distanceUnitLabel.snp.right).offset(2)
        }

        distanceUnitLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(distanceAmountLabel).offset(-2)
            make.left.equalTo(distanceUnitLabel.superview!).offset(16)
        }

    }

}
