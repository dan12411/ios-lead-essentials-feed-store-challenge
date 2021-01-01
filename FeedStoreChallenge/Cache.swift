import Foundation
import RealmSwift

class Cache: Object {
	let items = List<ImageItem>()
	@objc dynamic var timestamp = Date()
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
