//
//  Color+Hex.swift
//  bivi
//
//  Created by d.tatarinova on 13.03.2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let (aComponent, rComponent, gComponent, bComponent) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        self.init(
            .sRGB,
            red: Double(rComponent) / 255,
            green: Double(gComponent) / 255,
            blue: Double(bComponent) / 255,
            opacity: Double(aComponent) / 255
        )
    }
}
