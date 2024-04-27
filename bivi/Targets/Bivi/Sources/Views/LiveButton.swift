//
//  LiveButton.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import SwiftUI

struct LiveButton: View {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 6, height: 6)
                Text("Live")
                    .font(.josefinLight)
            }
            .padding([.horizontal], 10)
            .padding([.vertical], 5)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.red, lineWidth: 1)
            )
        }
    }
}
