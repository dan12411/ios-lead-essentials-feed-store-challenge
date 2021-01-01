import Foundation
import RealmSwift

class Cache: Object {
	var items = List<Item>()
	@objc dynamic var timestamp = Date()
}

class Item: Object {
	@objc dynamic var id = ""
	@objc dynamic var itemDescription: String? = nil
	@objc dynamic var location: String? = nil
	@objc dynamic var urlString = ""

	var feed: LocalFeedImage? {
		guard let id = UUID(uuidString: id), let url = URL(string: urlString) else {
			return nil
		}
		return LocalFeedImage(id: id, description: itemDescription, location: location, url: url)
	}

	convenience init(_ feed: LocalFeedImage) {
		self.init()
		id = feed.id.uuidString
		itemDescription = feed.description
		location = feed.location
		urlString = feed.url.absoluteString
	}
}

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
			let items = feed.map { Item($0) }
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
