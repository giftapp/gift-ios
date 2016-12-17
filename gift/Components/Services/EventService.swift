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
    func getAllEvents(forToday: Bool,
                      success: @escaping (_ events : Array<Event>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getAllEvents(forTodayOnly: forToday,
                success: { (eventsDTO) in
                    let events = eventsDTO.map({Event(eventDTO: $0)})
                    success(events)
                }, failure: failure)
    }

    func getEvent(eventId: String,
                  success: @escaping (_ event : Event) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.getEvent(eventId: eventId,
                success: { (eventDTO) in
                    let event = Event(eventDTO: eventDTO)
                    success(event)
        }, failure: failure)
    }

    func findEventsByLocation(lat: Double,
                              lng: Double,
                              success: @escaping (_ events : Array<Event>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {
        giftServiceCoreClient.findEventsByLocation(lat: lat, lng: lng, rad: EventServiceConstants.nearbySearchRadius,
                success: { (eventsDTO) in
                    let events = eventsDTO.map({Event(eventDTO: $0)})
                    success(events)
                }, failure: failure)
    }

    func findEventsByKeyword(keyword: String,
                             success: @escaping (_ events : Array<Event>) -> Void,
                             failure: @escaping (_ error: Error) -> Void) {

        giftServiceCoreClient.findEventsByKeyword(keyword: keyword, success: { (eventsDTO) in
            let events = eventsDTO.map({Event(eventDTO: $0)})
            success(events)
        }, failure: failure)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}
