//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class Venue: ModelBase, NSCoding {
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

    //-------------------------------------------------------------------------------------------
    // MARK: - NSCoding
    //-------------------------------------------------------------------------------------------
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id             = aDecoder.decodeObject(forKey: "id") as! String?
        self.createdAt      = aDecoder.decodeObject(forKey: "createdAt") as! Date?
        self.updatedAt      = aDecoder.decodeObject(forKey: "updatedAt") as! Date?

        self.googlePlaceId  = aDecoder.decodeObject(forKey: "googlePlaceId") as! String?
        self.name           = aDecoder.decodeObject(forKey: "name") as! String?
        self.address        = aDecoder.decodeObject(forKey: "address") as! String?
        self.phoneNumber    = aDecoder.decodeObject(forKey: "phoneNumber") as! String?
        self.latitude       = aDecoder.decodeObject(forKey: "latitude") as! Double?
        self.longitude      = aDecoder.decodeObject(forKey: "longitude") as! Double?
        self.googleMapsUrl  = aDecoder.decodeObject(forKey: "googleMapsUrl") as! String?
        self.website        = aDecoder.decodeObject(forKey: "website") as! String?
        self.imageUrl       = aDecoder.decodeObject(forKey: "imageUrl") as! String?
    }

    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")

        aCoder.encode(self.googlePlaceId, forKey: "googlePlaceId")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
        aCoder.encode(self.googleMapsUrl, forKey: "googleMapsUrl")
        aCoder.encode(self.website, forKey: "website")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
    }
}
