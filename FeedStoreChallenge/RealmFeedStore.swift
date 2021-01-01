import Foundation
import RealmSwift

public final class RealmFeedStore: FeedStore {

	let realm: Realm

	enum StoreError: Error {
		case initializationFailure
	}

	public init(configuration: Realm.Configuration) throws {
		do {
			realm = try Realm(configuration: configuration)
		} catch {
			throw StoreError.initializationFailure
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		try! realm.write {
			let items = feed.map { ImageItem($0) }
			let cache = Cache()

			cache.items.append(objectsIn: items)
			cache.timestamp = timestamp
			realm.add(cache)
			completion(nil)
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let cache = realm.objects(Cache.self)

		if let cache = cache.first {
			completion(.found(feed: cache.items.compactMap(\.feed), timestamp: cache.timestamp))
		} else {
			completion(.empty)
		}
	}
}
