//
// Created by Matan Lachmish on 12/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

private struct EventServiceConstants{
    static let nearbySearchRadius = 3.0
}

class EventService: NSObject {

    //Injected
    private var giftServiceCoreClient: GiftServiceCoreClient
    private var venueService: VenueService
    private var modelFactory: ModelFactory

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient: GiftServiceCoreClient,
                          venueService: VenueService,
                          modelFactory: ModelFactory) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.venueService = venueService
        self.modelFactory = modelFactory
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func getAllEvents(forToday: Bool,
                      success: @escaping (_ events : Array<Event>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getAllEvents(forTodayOnly: forToday,
                success: { (eventsDTO) in
                    self.getEventsFrom(eventsDTO: eventsDTO, success: success, failure: failure)
                }, failure: failure)
    }

    func getEvent(eventId: String,
                  success: @escaping (_ event : Event) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getEvent(eventId: eventId,
                success: { (eventDTO) in
                    self.getEventFrom(eventDTO: eventDTO, success: success, failure: failure)
                }, failure: failure)
    }

    func findEventsByLocation(lat: Double,
                              lng: Double,
                              success: @escaping (_ events : Array<Event>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.findEventsByLocation(lat: lat, lng: lng, rad: EventServiceConstants.nearbySearchRadius,
                success: { (eventsDTO) in
                    self.getEventsFrom(eventsDTO: eventsDTO, success: success, failure: failure)
                }, failure: failure)
    }

    func findEventsByKeyword(keyword: String,
                             success: @escaping (_ events : Array<Event>) -> Void,
                             failure: @escaping (_ error: Error) -> Void) {

        giftServiceCoreClient.findEventsByKeyword(keyword: keyword,
                success: { (eventsDTO) in
                    self.getEventsFrom(eventsDTO: eventsDTO, success: success, failure: failure)
                }, failure: failure)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func getEventFrom(eventDTO: EventDTO,
                      success: @escaping (_ event : Event) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        venueService.getVenue(venueId: eventDTO.venueId!,
                success: { (venue) in
                    let event = self.modelFactory.createEventFrom(eventDTO: eventDTO, venue: venue)
                    success(event)
                }, failure: failure)
    }

    func getEventsFrom(eventsDTO: Array<EventDTO>,
                       success: @escaping (_ events : Array<Event>) -> Void,
                       failure: @escaping (_ error: Error) -> Void) {
        let venuesId = eventsDTO.map({$0.venueId!})
        venueService.getVenues(venuesId: venuesId,
                success: { (venues) in
                    var events = [Event]()
                    for eventDTO in eventsDTO {
                        let venue = venues.filter({$0.id == eventDTO.venueId}).first
                        let event = self.modelFactory.createEventFrom(eventDTO: eventDTO, venue: venue!)
                        events.append(event)
                    }
                    success(events)
                }, failure: failure)
    }
}
