//
//  VideoStream.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import Foundation

struct VideoStream: Hashable {
    let previewPath: String
    let playlistPath: String
    let name: String

    var playlistURL: URL? {
        Endpoint.staticFiles(filename: playlistPath).absoluteURL
    }

    var previewURL: URL? {
        Endpoint.staticFiles(filename: previewPath).absoluteURL
    }
}
