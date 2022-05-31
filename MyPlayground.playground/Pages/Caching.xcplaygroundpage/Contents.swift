//: [Previous](@previous)

import Foundation

// MARK: - Caching Manager
protocol CacheItemStoreableProtocol: Encodable {
  func encode() throws -> Data
  func jsonDictionary() -> [String: Any]
}
protocol CacheItemRetrievableProtocol: Decodable {
  static func load(from store: CacheManager, forKey key: String) -> Self?
  static func loadItems(from store: CacheManager, forKey key: String) -> [Self]?
}
typealias CacheItemProtocol = CacheItemStoreableProtocol & CacheItemRetrievableProtocol

class CacheManager: ObservableObject {
  private let defaults: UserDefaults
  let decoder = JSONDecoder()

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func save(item: CacheItemProtocol, forKey key: String, synchronizeImmediate isImmediate: Bool = true) {
    if let encoded = try? item.encode() {
      defaults.setValue(encoded, forKey: key)
    } else {
      print("JSON Dictionary: Mapping Error")
    }

    if isImmediate {
      defaults.synchronize()
    }
  }

  func save(items: [CacheItemProtocol], groupKey key: String, synchronizeImmediate isImmediate: Bool = true) {
    let encoded = items.compactMap { try? $0.encode() }
    defaults.setValue(encoded, forKey: key)

    if isImmediate {
      defaults.synchronize()
    }
  }

  func value(forKey key: String) -> Any? {
    return defaults.value(forKey: key)
  }
}

// MARK: - Codable Extension
extension Encodable {
  func encode() throws -> Data {
    return try JSONEncoder().encode(self)
  }

  func jsonDictionary() -> [String: Any] {
      if let encoded = try? encode(),
         let jsonObject = try? JSONSerialization.jsonObject(with: encoded, options: .allowFragments),
         let jsonDictionary = jsonObject as? [String: Any] {
          return jsonDictionary
      } else {
          print("JSON Dictionary: Mapping Error")
          return [:]
      }
  }
}

extension Decodable {
  static func load(from store: CacheManager, forKey key: String) -> Self? {
    if let retrieved = store.value(forKey: key) as? Data {
      return try? store.decoder.decode(Self.self, from: retrieved)
    }

    return nil
  }

  static func loadItems(from store: CacheManager, forKey key: String) -> [Self]? {
    if let retrieved = store.value(forKey: key) as? [Data] {
      return retrieved.compactMap { try? store.decoder.decode(Self.self, from: $0) }
    }

    return nil
  }
}

// MARK: - Sample Usage
struct ModelToCache: CacheItemProtocol {
  let id: UUID
  let modelName: String
  let modelType: String
}

let cacheManager = CacheManager()
let model = ModelToCache(id: UUID(), modelName: "Test Name", modelType: "Struct")
cacheManager.save(item: model, forKey: "Cache01")


let retrievedModel = ModelToCache.load(from: cacheManager, forKey: "Cache01")
retrievedModel.jsonDictionary()

//: [Next](@next)
