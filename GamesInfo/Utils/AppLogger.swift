//
//  AppLogger.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Foundation
import OSLog

protocol Loggable {

    func debug(_ message: String, file: String, function: String, line: Int)
    func fault(_ message: String, file: String, function: String, line: Int)
}

extension Loggable {

    func makeMessage(_ type: String, file: String, function: String, line: Int) -> String {
        let file = file.components(separatedBy: "/").last
        return "\(type) [\(file ?? "UNKNOWN")] [\(function)] [\(line)] -> "
    }
}

final class AppLogger: Loggable {

    enum LoggerType {
        case debug
        case fault

        var message: String {
            switch self {
            case .debug:
                return "🟢 [DEBUG]"
            case .fault:
                return "🔴 [FAULT]"
            }
        }
    }

    enum Category: String, Hashable {
        case `default` = "Default"
    }

    private let logger: Logger

    init(_ category: Category = .default) {
        logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "UNKNOWN")", category: category.rawValue)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        
        let message = "\(makeMessage(LoggerType.debug.message, file: file, function: function, line: line)) \(message)"

        logger.debug("\(message)")
    }

    func fault(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {

        let message = "\(makeMessage(LoggerType.debug.message, file: file, function: function, line: line)) \(message)"

        logger.debug("\(message)")
    }
}
