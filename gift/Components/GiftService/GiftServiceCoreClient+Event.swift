//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient Event extension
extension GiftServiceCoreClient {

    //-------------------------------------------------------------------------------------------
    // MARK: - Get
    //-------------------------------------------------------------------------------------------
    func getAllEvents(forTodayOnly: Bool,
                      success: @escaping (_ eventsDTO : Array<EventDTO>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/event"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "forToday", value: forTodayOnly)

        manager.request(urlString, method: .get, parameters: parameters).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let eventsDTO = JSON(value).arrayValue.map({EventDTO(json: $0)})
                        success(eventsDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func getEvent(eventId: String,
                  success: @escaping (_ eventDTO : EventDTO) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/event" + "/\(eventId)"

        manager.request(urlString, method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let eventDTO = EventDTO(json: JSON(value))
                        success(eventDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func findEventsByLocation(lat: Double,
                              lng: Double,
                              rad: Double,
                              success: @escaping (_ eventsDTO : Array<EventDTO>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/event/today/nearbysearch"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "lat", value: lat)
        parameters.addIfNotOptional(key: "lng", value: lng)
        parameters.addIfNotOptional(key: "rad", value: rad)

        manager.request(urlString, method: .get, parameters: parameters).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let eventsDTO = JSON(value).arrayValue.map({EventDTO(json: $0)})
                        success(eventsDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func findEventsByKeyword(keyword: String,
                             success: @escaping (_ eventsDTO : Array<EventDTO>) -> Void,
                             failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/event/today/textsearch"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "keyword", value: keyword)

        manager.request(urlString, method: .get, parameters: parameters).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let eventsDTO = JSON(value).arrayValue.map({EventDTO(json: $0)})
                        success(eventsDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - POST
    //-------------------------------------------------------------------------------------------
    func createEvent(contact1: String,
                     contact2: String,
                     date: Date,
                     venueId: String,
                     success: @escaping (_ eventDTO : EventDTO) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/event"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "contact1", value: contact1)
        parameters.addIfNotOptional(key: "contact2", value: contact2)
        parameters.addIfNotOptional(key: "date", value: date)
        parameters.addIfNotOptional(key: "venueId", value: venueId)

        manager.request(urlString, method: .post, parameters: parameters).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let eventDTO = EventDTO(json: JSON(value))
                        success(eventDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

}
