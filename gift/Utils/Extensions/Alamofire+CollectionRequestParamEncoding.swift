//
// Created by Matan Lachmish on 17/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire

//This struct is used to encode collections as request params.
//There is no official stadart to encode collections. Alamofire choose to do so with [] ('%5B%5D='), this struct replace that with '='.
//
//Read more:    https://github.com/Alamofire/Alamofire/issues/329
//              http://stackoverflow.com/questions/40017640/alamofire-3-custom-encoding-to-alamofire-4-custom-encoding

struct CollectionRequestParamEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try! URLEncoding().encode(urlRequest, with: parameters)
        let urlString = request.url?.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "=")
        request.url = URL(string: urlString!)
        return request
    }
}
