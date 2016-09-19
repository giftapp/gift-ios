//
//  Alamofire+AuthenticationHeader.swift
//  gift
//
//  Created by Matan Lachmish on 06/06/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire

extension SessionManager {
    
    static func getManagerWithAuthenticationHeader(header : String, token : String) -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            header: token,
            "Accept": "application/json"
        ]
        
        return Alamofire.SessionManager(configuration: configuration)
    }
    
}
