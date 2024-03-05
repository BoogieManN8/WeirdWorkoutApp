import SwiftUI
import AVKit
import AVFoundation
import Combine

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: OnBoardViewModel
    let category: String
    let videoURL: URL
    let startTimeInSeconds: Double?
    let isFull: Bool
    @Binding var isPlaying: Bool
    @State private var rateObserver: AnyCancellable?
    @State private var isVideoPlaying = false
    @State private var player: AVPlayer?
    @State private var showPlayerFullScreen = false
    @State var showXmark: Bool = true
    @State var showFullScreenButton: Bool = true
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    

    var body: some View {
        ZStack {
            Group {
                if let player = player {
                    VideoPlayer(player: player)
                        .edgesIgnoringSafeArea(.all)
                        .onChange(of: isPlaying, perform: { value in
                            if value {
                                player.play()
                            } else {
                                player.pause()
                            }
                        })
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear{
            self.player = AVPlayer(url: videoURL)
            let isPlayable = AVAsset(url: videoURL).isPlayable
            print("DEBUG: is playable \(isPlayable)")
        }
    }
    
    private func setupRateObserver() {
        rateObserver = player?.publisher(for: \.rate).sink { rate in
            self.isVideoPlaying = rate > 0
        }
    }
    
    
    
}
