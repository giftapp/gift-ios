//
// Created by Matan Lachmish on 18/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import XCGLogger

class Logger {

    private init() {} //This prevents others from using the default '()' initializer for this class.

    static private let log = XCGLogger.defaultInstance()

    static func debug(@autoclosure closure: () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.debug(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func info(@autoclosure closure: () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.info(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func warning(@autoclosure closure: () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.warning(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func error(@autoclosure closure: () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.error(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func severe(@autoclosure closure: () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.severe(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    static func configureLog() {
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "log", fileLogLevel: .Debug)
    }

}
