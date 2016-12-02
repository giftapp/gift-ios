//
// Created by Matan Lachmish on 12/11/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

enum ConfigurationScheme {
    case development, developmentLocal, production

    static func getConfigurationScheme(fromString: String) -> ConfigurationScheme{
        switch fromString {
        case "Development":
            return .development
        case "DevelopmentLocal":
            return .developmentLocal
        default:
            return .production
        }
    }
}

private struct ConfigurationConstants{
    static let currentConfigurationKey = "Configuration"
    static let configurationFileName = "Configuration"
    static let giftAPIEndpointURLKey = "giftAPIEndpointURL"
    static let loggingLevelKey = "loggingLevel"
    static let developmentToolsEnabledKey = "developmentToolsEnabled"
}

/**
* Represent the current built configuration (i.e Development/Production/etc.).
* This class is a singleton.
**/
class Configuration {

    //Public Properties
    static let sharedInstance = Configuration()
    public private(set) var configurationScheme: ConfigurationScheme

    //Private Properties
    private var configuration: NSDictionary!

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    private init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: ConfigurationConstants.currentConfigurationKey) as! String
        configurationScheme = ConfigurationScheme.getConfigurationScheme(fromString: currentConfiguration)

        let path = Bundle.main.path(forResource: ConfigurationConstants.configurationFileName, ofType: "plist")!
        configuration = NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    var apiEndpoint: String {
        return configuration.object(forKey: ConfigurationConstants.giftAPIEndpointURLKey) as! String
    }

    var loggingLevel: String {
        return configuration.object(forKey: ConfigurationConstants.loggingLevelKey) as! String
    }
    
    var developmentToolsEnabled: Bool {
        return configuration.object(forKey: ConfigurationConstants.developmentToolsEnabledKey) as! Bool
    }
}
