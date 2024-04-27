//
//  Logger.swift
//  bivi
//
//  Created by d.tatarinova on 07.04.2024.
//

import Foundation
import CocoaLumberjackSwift

protocol Logger {
    var logsFileURL: URL? { get }
    func log(info: String)
    func log(error: String)
}

final class LoggerImpl: Logger {
    let logsFileURL: URL?

    init() {
        DDLog.add(DDOSLogger.sharedInstance)
        let documentsFileManager = BaseLogFileManager()
        let fileLogger = DDFileLogger(logFileManager: documentsFileManager)
        fileLogger.maximumFileSize = 5 * 1024 * 1024 // 5mb
        fileLogger.logFileManager.maximumNumberOfLogFiles = 1
        DDLog.add(fileLogger)
        if let filePath = fileLogger.currentLogFileInfo?.filePath {
            self.logsFileURL = URL(string: filePath)
        } else {
            self.logsFileURL = nil
        }
    }

    func log(info: String) {
        DDLogInfo(DDLogMessageFormat(stringLiteral: "[bivi] \(info)"))
    }

    func log(error: String) {
        DDLogError(DDLogMessageFormat(stringLiteral: "[bivi] \(error)"))
    }
}


final class BaseLogFileManager: DDLogFileManagerDefault {
    override var newLogFileName: String {
        Constants.logsFileName
    }

    override func isLogFile(withName fileName: String) -> Bool {
        fileName == Constants.logsFileName
    }
}

private enum Constants {
    static let logsFileName = "\(UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device").log"
}
