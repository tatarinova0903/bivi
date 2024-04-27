//
//  TitleModifier.swift
//  bivi
//
//  Created by d.tatarinova on 13.03.2024.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    let font: Font

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(BiviColors.textColor)
            .padding()
    }
}

extension View {
    func titleStyle(font: Font) -> some View {
        modifier(TitleModifier(font: font))
    }
}
