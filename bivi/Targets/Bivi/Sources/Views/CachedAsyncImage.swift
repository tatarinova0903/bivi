//
//  CachedAsyncImage.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import SwiftUI
import Kingfisher

struct CachedAsyncImage: View {
    private let url: URL?
    private let placeholder: () -> any View

    var body: some View {
        KFImage(url)
            .resizable()
            .placeholder { _ in ProgressView() }
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
    }

    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> any View
    ) {
        self.url = url
        self.placeholder = placeholder
    }
}
