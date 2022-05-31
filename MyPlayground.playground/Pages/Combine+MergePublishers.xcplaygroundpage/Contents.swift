//: [Previous](@previous)

import Foundation
import Combine

enum Action {
  case snapshot(_ id: Int)
  case watchLive(_ id: Int)
  case setReminder(_ id: Int)
}

var subscriptions = Set<AnyCancellable>()
let p1 = PassthroughSubject<Action, Never>()
let p2 = PassthroughSubject<Action, Never>()
let p3 = PassthroughSubject<Action, Never>()

let mergedPublishers = [p1, p2, p3].reduce(Publishers.MergeMany<PassthroughSubject<Action, Never>>(), { partialResult, publisher in
  partialResult.merge(with: publisher)
})

mergedPublishers.sink { feedAction in
  switch feedAction {
  case .snapshot(let id):
    print("Feed snapshot id: \(id)")

  case .watchLive(let id):
    print("Feed watchLive id: \(id)")

  case .setReminder(let id):
    print("Feed setReminder id: \(id)")
  }
}
.store(in: &subscriptions)
p1.send(.snapshot(1))
p2.send(.watchLive(1))
p3.send(.setReminder(1))

//: [Next](@next)
