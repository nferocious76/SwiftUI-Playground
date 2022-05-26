//: [Previous](@previous)

import AVKit
import SwiftUI

/**
 * Customizing AVPlayerViewController to support PiP video player state
 */

// MARK: - Wrapped Video Player
struct VideoPlayerView: UIViewControllerRepresentable {
  typealias UIViewControllerType = AVPlayerViewController

  @ObservedObject private var model: VideoPlayerViewModel

  init(model: VideoPlayerViewModel) {
    self.model = model
  }

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let pvc = AVPlayerViewController()
    pvc.player = model.player
    pvc.canStartPictureInPictureAutomaticallyFromInline = model.canStartPictureInPictureAutomaticallyFromInline
    pvc.showsTimecodes = model.showsTimecodes
    pvc.showsPlaybackControls = model.showsPlaybackControls
    pvc.delegate = context.coordinator
    return pvc
  }

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {

  }

  func makeCoordinator() -> VideoPlayerCoordinator {
    VideoPlayerCoordinator(model: model)
  }
}

// MARK: - Model
import Combine

class VideoPlayerViewModel: ObservableObject {
  let player: AVPlayer
  @Published var pipStatus: PiPStatus
  let canStartPictureInPictureAutomaticallyFromInline: Bool
  let showsTimecodes: Bool
  let showsPlaybackControls: Bool

  private var cancellable: AnyCancellable?

  init(player: AVPlayer,
       pipStatus: PiPStatus = .default,
       canStartPictureInPictureAutomaticallyFromInline: Bool = false,
       showsTimecodes: Bool = false,
       showsPlaybackControls: Bool = true) {

    self.player = player
    self.pipStatus = pipStatus
    self.canStartPictureInPictureAutomaticallyFromInline = canStartPictureInPictureAutomaticallyFromInline
    self.showsTimecodes = showsTimecodes
    self.showsPlaybackControls = showsPlaybackControls

    setAudioSessionPlayback()
  }

  private func setAudioSessionPlayback() {
    do {
      let shared = AVAudioSession.sharedInstance()
      try shared.setCategory(.playback)
      try  shared.setActive(true)
      print("Audio Session set to playback")
    } catch {
      print("Failed to update Audio Session")
    }
  }
}

extension VideoPlayerViewModel {
  enum PiPStatus {
    case `default`
    case willStart
    case didStart
    case willStop
    case didStop
  }

  func play() {
    player.play()
  }

  func pause() {
    player.pause()
  }
}

// MARK: - Coordinator
class VideoPlayerCoordinator: NSObject {
  @ObservedObject private var model: VideoPlayerViewModel

  init(model: VideoPlayerViewModel) {
    self.model = model
  }
}

extension VideoPlayerCoordinator: AVPlayerViewControllerDelegate {
  func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
    model.pipStatus = .willStart
  }

  func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
    model.pipStatus = .didStart
  }

  func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
    model.pipStatus = .willStop
  }

  func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
    model.pipStatus = .didStop
  }
}

// MARK: - Preview
import PlaygroundSupport

let videoURL = URL(string: "https://drive.proton.me/urls/8RFF61KJ34#GWTaIUGpGiwk")!
let player = AVPlayer(url: videoURL)
let videoPlayerModel = VideoPlayerViewModel(player: player)
let videoPlayer = VideoPlayerView(model: videoPlayerModel)
  .onAppear {
    videoPlayerModel.play()
  }

PlaygroundPage.current.liveView = UIHostingController(rootView: videoPlayer)

//: [Next](@next)
