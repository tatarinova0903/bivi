//
//  PlayPauseButton.swift
//  bivi
//
//  Created by d.tatarinova on 14.03.2024.
//

import SwiftUI

struct PlayPauseButton: View {
    let isPaused: Bool
    let opacity: Double

    var body: some View {
        Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
            .resizable()
            .frame(width: 60.0, height: 60.0)
            .foregroundColor(BiviColors.textColor)
            .playPauseOpacity(newOpacity: opacity)
    }
}
