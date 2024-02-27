import SwiftUI
import AVKit
import AVFoundation
import Combine

//struct VideoPlayerView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var viewModel: OnBoardViewModel
//    let category: String
//    let videoURL: URL
//    let startTimeInSeconds: Double?
//    let isFull: Bool
//    @Binding var isPlaying: Bool
//    @State private var rateObserver: AnyCancellable?
//    @State private var isVideoPlaying = false
//    @State private var player: AVPlayer?
//    @State private var showPlayerFullScreen = false
//    @State var showXmark: Bool = true
//    @State var showFullScreenButton: Bool = true
//    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
//    
//
//    
//    var body: some View {
//        Group {
//            if let player = player {
//                VideoPlayer(player: player)
//                    .edgesIgnoringSafeArea(.all)
//                    .onAppear {
//                        let progress = viewModel.fetchVideoProgress(categoryName: category, videoID: "\(videoURL.absoluteString)")
//                        
//                        
//                        print("DEBUG: progress[\(videoURL.absoluteString)] - \(progress)")
//                        if isPlaying {
//                            let startTime = CMTime(seconds: progress, preferredTimescale: 600)
//                            player.seek(to: startTime) { _ in
//                                player.play()
//                            }
//                        }
//                        
//                    }
//                    .onDisappear {
//                        let currentTime = player.currentTime().seconds
//                        
//                        viewModel.saveVideoProgress(categoryName: category, videoID: "\(videoURL.absoluteString)", currentTime: currentTime, videoLength: player.currentItem?.duration.seconds ?? 0)
//                        print("DEBUG: Saved progress[\(currentTime)] in core")
//                        player.pause()
//                    }
//                    .onChange(of: isPlaying, perform: { value in
//                        if value {
//                            player.play()
//                        } else {
//                            player.pause()
//                        }
//                    })
//                    .customOverlay(alignment: .topLeading) {
//                        if isFull {
//                            Button {
//                                withAnimation {
//                                    player.pause()
//                                    presentationMode.wrappedValue.dismiss()
//                                }
//                            } label: {
//                                Image(systemName: "arrow.down.forward.and.arrow.up.backward")
//                                    .font(.theme.title(18))
//                                    .foregroundColor(.white)
//                                    .padding()
//                            }
//                            .padding()
//                        }
//                    }
//                    
//            } else {
//                ProgressView()
//                    .onAppear {
//                        print("DEBUG: url - \(videoURL.absoluteString)")
//                        self.player = AVPlayer(url: videoURL)
////                        prepareVideo()
//                    }
//            }
//        }
//        
//    }
//    
//    private func setupRateObserver() {
//        rateObserver = player?.publisher(for: \.rate).sink { rate in
//            self.isVideoPlaying = rate > 0
//        }
//    }
//    
//    
//}
