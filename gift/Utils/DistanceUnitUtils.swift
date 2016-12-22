//
// Created by Matan Lachmish on 22/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

enum DistanceUnit {
    case kiloMeter
    case meter

    func localizedDescriptor() -> String {
        switch self {
        case .meter:
            return "DistanceUnit.meter".localized
        case .kiloMeter:
            return "DistanceUnit.kilo-meter".localized
        }
    }
}