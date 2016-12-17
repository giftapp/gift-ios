//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

struct VenueServiceConstants {
    static let nearbySearchRadius = 3.0
}

class VenueService: NSObject {

    //Injected
    private var giftServiceCoreClient : GiftServiceCoreClient

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient : GiftServiceCoreClient) {
        self.giftServiceCoreClient = giftServiceCoreClient
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getAllVenues(success: @escaping (_ venues : Array<Venue>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getAllVenues(success: { (venuesDTO) in
            let venues = venuesDTO.map({Venue(venueDTO: $0)})
            success(venues)
        }, failure: failure)
    }

    func findVenuesByLocation(lat: Double,
                              lng: Double,
                              success: @escaping (_ venues : Array<Venue>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.findVenuesByLocation(lat: lat, lng: lng, rad: VenueServiceConstants.nearbySearchRadius,
                success: { (venuesDTO) in
                    let venues = venuesDTO.map({Venue(venueDTO: $0)})
                    success(venues)
                }, failure: failure)
    }

    func getVenue(venueId: String,
                  success: @escaping (_ venue: Venue) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getVenue(venueId: venueId,
                success: { (venueDTO) in
                    let venue = Venue(venueDTO: venueDTO)
                    success(venue)
                }, failure: failure)
    }

}
