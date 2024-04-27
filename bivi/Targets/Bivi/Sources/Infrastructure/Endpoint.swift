//
//  Endpoint.swift
//  bivi
//
//  Created by d.tatarinova on 24.03.2024.
//

import Foundation

enum Endpoint {
    case streams
    case staticFiles(filename: String)
    case qualities
    case clientLogs

    var absoluteURL: URL? {
        baseURL?.appendingPathComponent(path)
    }

    var baseURL: URL? {
        URL(string: "http://localhost:8080")
    }

    var path: String {
        switch self {
        case .streams:
            return "api/v1/streams"
        case let .staticFiles(filename: filename):
            return filename
        case .qualities:
            return "api/v1/streams/qualities"
        case .clientLogs:
            return "api/v1/client/logs"
        }
    }
}
