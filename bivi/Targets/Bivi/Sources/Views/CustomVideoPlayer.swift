//
//  CustomVideoPlayer.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import AVKit
import SwiftUI

struct CustomVideoPlayer: UIViewControllerRepresentable {
    @State var player: AVPlayer

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.player = player
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = BiviAVPlayerController()
        controller.showsPlaybackControls = false
        return controller
    }
}

final class BiviAVPlayerController: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
}
