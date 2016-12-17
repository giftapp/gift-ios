//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class Venue: ModelBase {
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
    init(venueDTO: VenueDTO) {
        googlePlaceId   = venueDTO.googlePlaceId
        name            = venueDTO.name
        address         = venueDTO.address
        phoneNumber     = venueDTO.phoneNumber
        latitude        = venueDTO.latitude
        longitude       = venueDTO.longitude
        googleMapsUrl   = venueDTO.googleMapsUrl
        website         = venueDTO.website
        imageUrl        = venueDTO.imageUrl

        super.init(dtoBase: venueDTO)
    }

}
