import Foundation
import RealmSwift

public final class RealmFeedStore {

	private let configuration: Realm.Configuration

	public init(configuration: Realm.Configuration) {
		self.configuration = configuration
	}
}

extension RealmFeedStore: FeedStore {

	enum StoreError: Error {
		case readOnly
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		if configuration.readOnly { return completion(StoreError.readOnly) }

		do {
			try Cache.delete(self.configuration)
			completion(nil)

		} catch {
			completion(error)
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		if configuration.readOnly { return completion(StoreError.readOnly) }

		do {
			try Cache.delete(self.configuration)
			try Cache.insert(self.configuration, feed: feed,timestamp: timestamp)
			completion(nil)

		} catch {
			completion(error)
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		do {
			let caches = try Cache.retrieve(self.configuration)
			guard let cache = caches.first else { return completion(.empty) }
			completion(.found(feed: cache.items.compactMap(\.feed), timestamp: cache.timestamp))

		} catch {
			completion(.failure(error))
		}
	}
}
