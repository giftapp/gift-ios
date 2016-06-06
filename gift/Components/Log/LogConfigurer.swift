//
// Created by Matan Lachmish on 07/06/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import XCGLogger

class LogConfigurer : NSObject {
    
    private let log = XCGLogger.defaultInstance()

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic override init() {
        super.init()

        self.configureLog()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func configureLog() {
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "log", fileLogLevel: .Debug)
    }
}
