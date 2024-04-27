//
//  Rate.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import Foundation

struct Quality: Hashable {
    let height: String
    let preferredPeakBitRate: Double?
}

extension Quality {
    static let `default` = Quality(height: "auto", preferredPeakBitRate: nil)
}
