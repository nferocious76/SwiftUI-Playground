//: [Previous](@previous)

import Foundation
import Combine
import SwiftUI

class Model: ObservableObject {
  @Published var mediaURL: String?
  var cancellable: AnyCancellable?

  init(mediaURL: String?) {
    self.mediaURL = mediaURL

    bind()
  }

  private func bind() {
    cancellable = $mediaURL
      .compactMap { $0 }
      .compactMap { URL(string: $0) }
      .sink(receiveValue: { url in
        print("Processed URL: ", url)
      })
  }
}

Model(mediaURL: "https://youtu.be/018s8rXnA0I")

//: [Next](@next)
