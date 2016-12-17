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

    init(googlePlaceId: String?,
         name: String?,
         address: String?,
         phoneNumber: String?,
         latitude: Double?,
         longitude: Double?,
         googleMapsUrl: String?,
         website: String?,
         imageUrl: String?,
         id: String?,
         createdAt: Date?,
         updatedAt: Date?) {
        self.googlePlaceId = googlePlaceId
        self.name          = name
        self.address       = address
        self.phoneNumber   = phoneNumber
        self.latitude      = latitude
        self.longitude     = longitude
        self.googleMapsUrl = googleMapsUrl
        self.website       = website
        self.imageUrl      = imageUrl

        super.init(id: id, createdAt: createdAt, updatedAt: updatedAt)
    }

}
