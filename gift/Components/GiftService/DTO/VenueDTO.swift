//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class VenueDTO: DTOBase {
    var googlePlaceId : String?
    var name : String?
    var address : String?
    var phoneNumber : String?
    var latitude : Double?
    var longitude : Double?
    var googleMapsUrl : String?
    var website : String?
    var imageUrl : String?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init() {
        super.init()
    }

    required init(json: JSON) {
        googlePlaceId   = json["googlePlaceId"].string
        name            = json["name"].string
        address         = json["address"].string
        phoneNumber     = json["phoneNumber"].string
        latitude        = json["latitude"].double
        longitude       = json["longitude"].double
        googleMapsUrl   = json["googleMapsUrl"].string
        website         = json["website"].string
        imageUrl        = json["imageUrl"].string

        super.init(json: json)
    }

}