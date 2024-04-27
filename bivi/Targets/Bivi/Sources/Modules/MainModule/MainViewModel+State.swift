//
//  MainViewModel+State.swift
//  bivi
//
//  Created by d.tatarinova on 23.03.2024.
//

import AVKit

extension MainViewModel {
    enum State {
        struct ReadyState {
            var isPaused: Bool
            var currentQuality: Quality
            var currentStream: VideoStream
            var otherStreams: [VideoStream]
            var shouldShowPreview: Bool
            var videoPlayer: AVPlayer?
            var playPauseButtonOpacity: Double
            var videoStartPlayDate: Date?
        }

        case loading
        case ready(ReadyState)
        case error(String)

        var isPaused: Bool {
            switch self {
            case .loading, .error:
                return true
            case let .ready(readyState):
                return readyState.isPaused
            }
        }

        var currentQuality: Quality {
            switch self {
            case .loading, .error:
                return .default
            case let .ready(readyState):
                return readyState.currentQuality
            }
        }

        var playPauseButtonOpacity: Double {
            switch self {
            case .loading, .error:
                return 0.0
            case let .ready(readyState):
                return readyState.playPauseButtonOpacity
            }
        }

        func pausing() -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                var newState = readyState
                newState.isPaused = true
                newState.videoPlayer?.pause()
                return .ready(newState)
            }
        }

        func playing() -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                var newState = readyState
                newState.isPaused = false
                newState.playPauseButtonOpacity = 0.0
                if newState.shouldShowPreview, let playlistURL = readyState.currentStream.playlistURL {
                    newState.shouldShowPreview = false
                    newState.videoStartPlayDate = Date()
                    newState.videoPlayer = .playerForURL(playlistURL)
                }
                newState.videoPlayer?.play()
                return .ready(newState)
            }
        }

        func updating(withPlayPauseButtonOpacity playPauseButtonOpacity: Double) -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                var newState = readyState
                newState.playPauseButtonOpacity = playPauseButtonOpacity
                return .ready(newState)
            }
        }

        func updating(with currentQuality: Quality) -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                var newState = readyState
                newState.currentQuality = currentQuality
                newState.videoPlayer?.currentItem?.preferredPeakBitRate = currentQuality.preferredPeakBitRate ?? 0
                return .ready(newState)
            }
        }

        func seekingToLive() -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                let newState = readyState
                if let videoStartPlayDate = readyState.videoStartPlayDate {
                    let passedSeconds = Date().timeIntervalSince1970 - videoStartPlayDate.timeIntervalSince1970
                    newState.videoPlayer?.seek(to: CMTimeMakeWithSeconds(passedSeconds, preferredTimescale: 1000))
                }
                return .ready(newState)
            }
        }

        func changingCurrentStream(to stream: VideoStream) -> Self {
            switch self {
            case .loading, .error:
                return self
            case let .ready(readyState):
                var newState = readyState
                if let index = newState.otherStreams.firstIndex(of: stream) {
                    newState.otherStreams[index] = readyState.currentStream
                }
                newState.currentStream = stream
                newState.videoStartPlayDate = nil
                newState.videoPlayer = nil
                newState.isPaused = true
                newState.shouldShowPreview = true
                newState.playPauseButtonOpacity = 1.0
                return .ready(newState)
            }
        }
    }
}
