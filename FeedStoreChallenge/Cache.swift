import Foundation
import RealmSwift

class Cache: Object {
	let items = List<Item>()
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
