//
//  Alamofire+AuthenticationHeader.swift
//  gift
//
//  Created by Matan Lachmish on 06/06/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import Alamofire

extension Manager {
    
    static func getManagerWithAuthenticationHeader(header : String, token : String) -> Manager {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            header: token,
            "Accept": "application/json"
        ]
        
        return Alamofire.Manager(configuration: configuration)
    }
    
}