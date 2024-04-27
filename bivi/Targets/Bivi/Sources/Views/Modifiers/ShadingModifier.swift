//
//  ShadingModifier.swift
//  bivi
//
//  Created by d.tatarinova on 13.03.2024.
//

import SwiftUI

struct ShadingModifier: ViewModifier {
    let opacity: Double

    func body(content: Content) -> some View {
        ZStack {
            content
            Color.black.opacity(opacity)
        }
    }
}

extension View {
    func withShading(_ opacity: Double) -> some View {
        modifier(ShadingModifier(opacity: opacity))
    }
}
