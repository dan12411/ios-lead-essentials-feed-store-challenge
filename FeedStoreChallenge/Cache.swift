import Foundation
import RealmSwift

class Cache: Object {
	let items = List<ImageItem>()
	@objc dynamic var timestamp = Date()

	static func retrieve(_ configuration: Realm.Configuration) throws -> Results<Cache> {
		let realm = try Realm(configuration: configuration)
		return realm.objects(Cache.self)
	}

	static func delete(_ configuration: Realm.Configuration) throws {
		let realm = try Realm(configuration: configuration)
		let cachedFeed = realm.objects(self)

		try realm.write {
			realm.delete(cachedFeed)
		}
	}

	static func insert(_ configuration: Realm.Configuration, feed: [LocalFeedImage], timestamp: Date) throws {
		let realm = try Realm(configuration: configuration)

		try realm.write {
			let items = feed.map { ImageItem($0) }
			let cache = Cache()

			cache.items.append(objectsIn: items)
			cache.timestamp = timestamp
			realm.add(cache)
		}
	}
}

class ImageItem: Object {
	@objc dynamic var id = ""
	@objc dynamic var imageDescription: String? = nil
	@objc dynamic var location: String? = nil
	@objc dynamic var urlString = ""

	var feed: LocalFeedImage? {
		guard let id = UUID(uuidString: id), let url = URL(string: urlString) else {
			return nil
		}
		return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
	}

	convenience init(_ feed: LocalFeedImage) {
		self.init()
		id = feed.id.uuidString
		imageDescription = feed.description
		location = feed.location
		urlString = feed.url.absoluteString
	}
}
