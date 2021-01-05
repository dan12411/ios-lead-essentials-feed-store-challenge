import Foundation
import RealmSwift

public final class RealmFeedStore: FeedStore {

	private let configuration: Realm.Configuration

	enum StoreError: Error {
		case readOnly
	}

	public init(configuration: Realm.Configuration) {
		self.configuration = configuration
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		if configuration.readOnly { return completion(StoreError.readOnly) }

		do {
			let realm = try Realm(configuration: configuration)
			try realm.write {
				let cachedFeed = realm.objects(Cache.self)
				realm.delete(cachedFeed)
				completion(nil)
			}

		} catch {
			completion(error)
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		if configuration.readOnly { return completion(StoreError.readOnly) }

		do {
			let realm = try Realm(configuration: configuration)
			try realm.write {
				let cachedFeed = realm.objects(Cache.self)
				realm.delete(cachedFeed)

				let items = feed.map { ImageItem($0) }
				let cache = Cache()

				cache.items.append(objectsIn: items)
				cache.timestamp = timestamp
				realm.add(cache)
				completion(nil)
			}

		} catch {
			completion(error)
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		do {
			let realm = try Realm(configuration: configuration)
			let cache = realm.objects(Cache.self)

			if let cache = cache.first {
				completion(.found(feed: cache.items.compactMap(\.feed), timestamp: cache.timestamp))
			} else {
				completion(.empty)
			}

		} catch {
			completion(.failure(error))
		}
	}
}
