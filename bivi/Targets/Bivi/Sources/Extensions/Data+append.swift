//
//  Data+append.swift
//  bivi
//
//  Created by d.tatarinova on 07.04.2024.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
