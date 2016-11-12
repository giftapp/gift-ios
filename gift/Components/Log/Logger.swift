//
// Created by Matan Lachmish on 18/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import XCGLogger

class Logger {

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    private init() {} //This prevents others from using the default '()' initializer for this class.

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    static private let log = XCGLogger.default

    static func debug(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.logln(closure, level: .debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func info(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.logln(closure, level: .info, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func warning(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.logln(closure, level: .warning, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func error(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.logln(closure, level: .error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func severe(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        log.logln(closure, level: .severe, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func configureLog() {
        let logLevel = getLogLevelFromString(fromString: Configuration.sharedInstance.loggingLevel)

        switch Configuration.sharedInstance.configurationScheme {
        case .development, .developmentLocal:
            log.setup(level: logLevel, showLogIdentifier: true, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: "log", fileLevel: .error)
        case .production:
            //TODO: turn off extensive log writing before production release
            log.setup(level: logLevel, showLogIdentifier: true, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: "log", fileLevel: .error)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private static func getLogLevelFromString(fromString: String) -> XCGLogger.Level {
        switch fromString {
        case "Debug":
            return .debug
        case "Info":
            return .info
        case "Error":
            return .error
        case "Warning":
            return .warning
        case "Severe":
            return .severe
        default:
            return .info
        }
    }
}
