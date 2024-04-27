//
//  MainViewModel.swift
//  bivi
//
//  Created by d.tatarinova on 10.03.2024.
//

import AVKit
import Combine
import Factory

final class MainViewModel: ObservableObject {
    @Published var state: State
    @Published var qualities: [Quality]
    @Published var shouldShowSnackBar: Bool
    @Injected(\.networkManager)
    private var networkManager
    @Injected(\.logger)
    private var logger
    private var bag = Set<AnyCancellable>()
    private var viewDidAppear = false

    init() {
        self.state = .loading
        self.qualities = [Quality.default]
        self.shouldShowSnackBar = false
    }

    func viewWillAppear() {
        guard !viewDidAppear else { return }
        viewDidAppear = true
        Publishers.Zip(
            networkManager.fetchStreamsList(),
            networkManager.fetchQualities()
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.logger.log(error: "Fetching finished with error: \(error)")
                    self?.state = .error(String(describing: error))
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] streams, qualities in
                guard let self,
                      let firstStream = streams.first
                else { return }
                self.logger.log(info: "Fetched streams = \(streams)")
                self.logger.log(info: "Fetched qualities = \(qualities)")
                let currentStream = firstStream
                let otherStreams = Array(streams.dropFirst())
                self.qualities = [Quality.default] + qualities
                self.state = .ready(.init(
                    isPaused: true,
                    currentQuality: .default,
                    currentStream: currentStream,
                    otherStreams: otherStreams,
                    shouldShowPreview: true,
                    playPauseButtonOpacity: 1.0
                ))
            }
        )
        .store(in: &bag)
    }

    func playPauseButtonDidTap() {
        if state.isPaused {
            playVideo()
        } else {
            pauseVideo()
        }
    }

    func videoDidTap() {
        if state.playPauseButtonOpacity.isZero {
            self.state = state.updating(withPlayPauseButtonOpacity: 1.0)
        } else {
            self.state = state.updating(withPlayPauseButtonOpacity: 0.0)
        }
    }

    func sendLogsButtonDidTap() {
        networkManager
            .sendLogs(fileURL: logger.logsFileURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case let .failure(error):
                        self?.logger.log(error: "Sending logs finished with error: \(error)")
                    case .finished:
                        self?.shouldShowSnackBar = true
                    }
                },
                receiveValue: { [weak self] in
                    self?.logger.log(error: "Logs sended")
                }
            )
            .store(in: &bag)
    }

    func qualityChanged(to newQuality: Quality) {
        self.state = state.updating(with: newQuality)
    }

    func didTapOnStream(_ stream: VideoStream) {
        self.state = state.changingCurrentStream(to: stream)
    }

    private func playVideo() {
        self.state = state.playing()
    }

    private func pauseVideo() {
        self.state = state.pausing()
    }
}
