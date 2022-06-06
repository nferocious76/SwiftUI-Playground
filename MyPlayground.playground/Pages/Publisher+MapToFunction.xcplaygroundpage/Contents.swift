//: [Previous](@previous)

import Combine
import Foundation

extension ViewModel {
  struct MappedInputResult: Identifiable {
    let id: UUID
    let title: String
  }
}

class ViewModel: ObservableObject {
  private var subscriptions = Set<AnyCancellable>()
  private var textChange = PassthroughSubject<String, Never>()

  @Published var searchedText: String
  @Published var searchResults: [MappedInputResult]

  init(searchedText: String = "", searchResults: [MappedInputResult] = []) {
    self.searchedText = searchedText
    self.searchResults = searchResults

    setBindings()
  }
}

extension ViewModel {
  private func setBindings() {
    $searchedText
      .sink(receiveValue: { [weak self] text in
        guard let self = self else { return }
        if text.isEmpty {
          self.searchResults = []
          self.textChange.send("")
        } else {
          self.textChange.send(text)
        }
      })
      .store(in: &subscriptions)

    textChange
      .debounce(for: .seconds(1), scheduler: DispatchQueue.global(qos: .background))
      .map { [weak self] text -> AnyPublisher<[ViewModel.MappedInputResult], Never> in
        guard let self = self
        else {
          return PassthroughSubject<[ViewModel.MappedInputResult], Never>().eraseToAnyPublisher()
        }
        return self.performFilter(for: text)
      }
      .switchToLatest()
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] results in
        guard let self = self else { return }
        self.searchResults = results
        print("Results: ", results.map({ $0.title }))
      })
      .store(in: &subscriptions)
  }

  private func performFilter(for query: String) -> AnyPublisher<[ViewModel.MappedInputResult], Never> {
    if query.isEmpty {
      return CurrentValueSubject([]).eraseToAnyPublisher()
    } else {
      let results = ToSearchItems.filter({ item in
        item.title.lowercased().hasPrefix(query.lowercased())
      })
      return CurrentValueSubject(results).eraseToAnyPublisher()
    }
  }
}

let ToSearchItems: [ViewModel.MappedInputResult] = [
  .init(id: UUID(), title: "a aaaa aaaa"),
  .init(id: UUID(), title: "a bbbb aaaa"),
  .init(id: UUID(), title: "b bbbb cc"),
  .init(id: UUID(), title: "c cc cccc"),
  .init(id: UUID(), title: "d aa cccc")
]

let model = ViewModel()
model.searchedText = "c"

//: [Next](@next)
