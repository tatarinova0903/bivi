//
//  ContentView.swift
//  bivi
//
//  Created by d.tatarinova on 24.02.2024.
//

import AVKit
import SwiftUI
import SwiftUISnackbar

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    @State private var shouldShowFullScreen = false

    var body: some View {
        ZStack {
            BiviColors.mainColor.ignoresSafeArea()
            NavigationView {
                content
                    .background(BiviColors.mainColor)
                    .navigationBarTitle("bivi", displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            HStack {
                                Menu(
                                    content: {
                                        Button("Send logs", action: {
                                            viewModel.sendLogsButtonDidTap()
                                        })
                                    },
                                    label: {
                                        Image(systemName: "gearshape.fill")
                                    }
                                )
                                Menu(
                                    content: {
                                        ForEach(viewModel.qualities, id: \.self) { quality in
                                            Button(quality.height) {
                                                viewModel.qualityChanged(to: quality)
                                            }
                                        }
                                    },
                                    label: {
                                        Text(viewModel.state.currentQuality.height)
                                            .font(.josefinLight)
                                    }
                                )
                            },
                        trailing:
                            LiveButton {
                                viewModel.liveButtonDidTap()
                            }
                    )
                    .foregroundColor(BiviColors.textColor)
                    .navigationBarColor(
                        backgroundColor: BiviColors.mainColor,
                        titleColor: BiviColors.textColor
                    )
                    .preferredColorScheme(.dark)
                    .onAppear {
                        viewModel.viewWillAppear()
                    }
                    .snackbar(
                        isShowing: $viewModel.shouldShowSnackBar,
                        title: "Success",
                        text: "Logs sended!",
                        style: .custom(BiviColors.successColor)
                    )
            }
        }
        .onRotate { newOrientaion in
            shouldShowFullScreen = newOrientaion.isLandscape
        }
        .fullScreenCover(isPresented: $shouldShowFullScreen) {
            if case .ready(let state) = viewModel.state {
                playerView(with: state)
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case let .error(errorDescription):
            errorView(with: errorDescription)
        case let .ready(state):
            readyView(with: state)
        }
    }

    var loadingView: some View {
        ProgressView()
    }

    func errorView(with errorDescription: String) -> some View {
        Text("Error occured \(errorDescription)")
    }

    func readyView(with state: MainViewModel.State.ReadyState) -> some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    ZStack {
                        playerView(with: state)
                    }
                    .frame(height: geometry.size.height / 3)
                    Text(state.currentStream.name).titleStyle(font: .josefinSemiBold).padding([.horizontal], 10)
                }
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(state.otherStreams, id: \.self) { stream in
                            VideoCell(imageURL: stream.previewURL, name: stream.name)
                                .onTapGesture {
                                    viewModel.didTapOnStream(stream)
                                }
                                .padding([.all], 20)
                        }
                    }
                    .padding([.top], 20)
                }
            }
        }
    }

    @ViewBuilder
    func playerView(with state: MainViewModel.State.ReadyState) -> some View {
        ZStack {
            if !state.shouldShowPreview, let videoPlayer = state.videoPlayer {
                CustomVideoPlayer(player: videoPlayer)
                    .onTapGesture {
                        viewModel.videoDidTap()
                    }
            } else {
                CachedAsyncImage(
                    url: state.currentStream.previewURL,
                    placeholder: { ProgressView() }
                )
                .scaledToFit()
            }
            PlayPauseButton(
                isPaused: state.isPaused,
                opacity: state.playPauseButtonOpacity
            )
            .onTapGesture {
                viewModel.playPauseButtonDidTap()
            }
        }
    }
}
