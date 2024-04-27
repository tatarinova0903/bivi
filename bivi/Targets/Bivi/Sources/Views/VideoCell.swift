//
//  VideoCell.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import SwiftUI

struct VideoCell: View {
    let imageURL: URL?
    let name: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CachedAsyncImage(
                    url: imageURL,
                    placeholder: { BiviColors.mainColor }
                )
                .scaledToFit()
                .withShading(0.5)
                .blur(radius: 20)
                HStack {
                    CachedAsyncImage(
                        url: imageURL,
                        placeholder: { ProgressView() }
                    )
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.5, height: 90)
                    .clipped()
                    Text(name)
                        .multilineTextAlignment(.leading)
                        .titleStyle(font: .josefinRegular)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                }
            }
        }
        .padding([.horizontal], 20)
        .cornerRadius(30)
        .frame(height: 140)
    }
}
