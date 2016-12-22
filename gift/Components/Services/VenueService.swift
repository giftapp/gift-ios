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
    private var modelFactory : ModelFactory

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient : GiftServiceCoreClient,
                          modelFactory: ModelFactory) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.modelFactory = modelFactory
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getAllVenues(success: @escaping (_ venues : Array<Venue>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getAllVenues(success: { (venuesDTO) in
            let venues = venuesDTO.map({self.modelFactory.createVenueFrom(venueDTO: $0)})
            success(venues)
        }, failure: failure)
    }

    func findVenuesByLocation(lat: Double,
                              lng: Double,
                              success: @escaping (_ venues : Array<Venue>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.findVenuesByLocation(lat: lat, lng: lng, rad: VenueServiceConstants.nearbySearchRadius,
                success: { (venuesDTO) in
                    let venues = venuesDTO.map({self.modelFactory.createVenueFrom(venueDTO: $0)})
                    success(venues)
                }, failure: failure)
    }

    func findVenuesByKeyword(keyword: String,
                             success: @escaping (_ venues : Array<Venue>) -> Void,
                             failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.findVenuesByKeyword(keyword: keyword,
                success: { (venuesDTO) in
                    let venues = venuesDTO.map({self.modelFactory.createVenueFrom(venueDTO: $0)})
                    success(venues)
                }, failure: failure)
    }

    func getVenue(venueId: String,
                  success: @escaping (_ venue: Venue) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getVenue(venueId: venueId,
                success: { (venueDTO) in
                    let venue = self.modelFactory.createVenueFrom(venueDTO: venueDTO)
                    success(venue)
                }, failure: failure)
    }

    func getVenues(venuesId: Array<String>,
                  success: @escaping (_ venues: Array<Venue>) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getVenues(venuesId: venuesId,
                success: { (venuesDTO) in
                    let venues = venuesDTO.map({self.modelFactory.createVenueFrom(venueDTO: $0)})
                    success(venues)
                }, failure: failure)
    }

}
