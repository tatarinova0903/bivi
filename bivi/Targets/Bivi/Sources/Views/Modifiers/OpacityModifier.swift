//
//  OpacityModifier.swift
//  bivi
//
//  Created by d.tatarinova on 13.03.2024.
//

import SwiftUI

struct OpacityModifier: ViewModifier {
    let newOpacity: Double

    func body(content: Content) -> some View {
        content
            .opacity(newOpacity)
            .animation(.linear(duration: newOpacity ~= 0.0 ? 4 : 0), value: newOpacity)
    }
}

extension View {
    func playPauseOpacity(newOpacity: Double) -> some View {
        modifier(OpacityModifier(newOpacity: newOpacity))
    }
}
