//
//  AVPlayer+playlistURL.swift
//  bivi
//
//  Created by d.tatarinova on 06.04.2024.
//

import AVKit

extension AVPlayer {
    static func playerForURL(_ playlistURL: URL) -> AVPlayer {
        let asset = AVURLAsset(url: playlistURL, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        return videoPlayer
    }
}
