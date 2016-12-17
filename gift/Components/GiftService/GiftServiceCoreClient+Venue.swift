//
// Created by Matan Lachmish on 16/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//GiftServiceCoreClient Venue extension
extension GiftServiceCoreClient {

    //-------------------------------------------------------------------------------------------
    // MARK: - GET
    //-------------------------------------------------------------------------------------------
    func getAllVenues(success: @escaping (_ venuesDTO : Array<VenueDTO>) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/venue"

        manager.request(urlString, method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let venuesDTO = JSON(value).arrayValue.map({VenueDTO(json: $0)})
                        success(venuesDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func findVenuesByLocation(lat: Double,
                              lng: Double,
                              rad: Double,
                              success: @escaping (_ venuesDTO : Array<VenueDTO>) -> Void,
                              failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/venue/nearbysearch"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "lat", value: lat)
        parameters.addIfNotOptional(key: "lng", value: lng)
        parameters.addIfNotOptional(key: "rad", value: rad)

        manager.request(urlString, method: .get, parameters: parameters).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let venuesDTO = JSON(value).arrayValue.map({VenueDTO(json: $0)})
                        success(venuesDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func getVenue(venueId: String,
                  success: @escaping (_ venueDTO: VenueDTO) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/venue" + "/\(venueId)"

        manager.request(urlString, method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let venueDTO = VenueDTO(json: JSON(value))
                        success(venueDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

    func getVenues(venuesId: Array<String>,
                  success: @escaping (_ venuesDTO: Array<VenueDTO>) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {

        let urlString = GiftServiceCoreClientConstants.baseUrlPath+"/venue/batch"

        var parameters = Parameters()
        parameters.addIfNotOptional(key: "venuesId", value: venuesId)
        
        manager.request(urlString, method: .get, parameters: parameters, encoding: CollectionRequestParamEncoding()).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let venuesDTO = JSON(value).arrayValue.map({VenueDTO(json: $0)})
                        success(venuesDTO)
                    case .failure(let error):
                        failure(error)
                    }
                }
    }

}
