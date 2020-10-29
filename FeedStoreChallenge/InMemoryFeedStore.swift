//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Dan on 2020/10/29.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public class InMemoryFeedStore: FeedStore {

    typealias Cache = (feed: [LocalFeedImage], timestamp: Date)

    private var cache: Cache?
    private let queue = DispatchQueue(label: "\(InMemoryFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)

    public init() { }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        queue.async(flags: .barrier) {
            self.cache = nil
            completion(nil)
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        queue.async(flags: .barrier) {
            self.cache = (feed, timestamp)
            completion(nil)
        }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async {
            if let cache = self.cache {
                completion(.found(feed: cache.feed, timestamp: cache.timestamp))
            } else {
                completion(.empty)
            }
        }
    }
}
