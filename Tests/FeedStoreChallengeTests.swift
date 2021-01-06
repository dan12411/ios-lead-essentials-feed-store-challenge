//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
import RealmSwift

class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
	//  ***********************
	//
	//  Follow the TDD process:
	//
	//  1. Uncomment and run one test at a time (run tests with CMD+U).
	//  2. Do the minimum to make the test pass and commit.
	//  3. Refactor if needed and commit again.
	//
	//  Repeat this process until all tests are passing.
	//
	//  ***********************
	
	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_insert_overridesPreviouslyInsertedCacheValues() {
		let sut = makeSUT()

		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}
	
	func test_delete_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_delete_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_delete_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_delete_emptiesPreviouslyInsertedCache() {
		let sut = makeSUT()

		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}
	
	func test_storeSideEffects_runSerially() {
		let sut = makeSUT()
		
		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
	private func makeSUT(_ configuration: Realm.Configuration? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
		let sut = RealmFeedStore(configuration: configuration ?? inMemoryConfiguration())
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}

	private func inMemoryConfiguration() -> Realm.Configuration {
		return Realm.Configuration(inMemoryIdentifier: "\(type(of: self))")
	}

	private func notExistStoreConfiguration() -> Realm.Configuration {
		let configuration = Realm.Configuration(fileURL: anyURL())
		return configuration
	}

	private func readOnlyMemoryConfiguration() -> Realm.Configuration {
		var configuration = inMemoryConfiguration()
		configuration.readOnly = true
		return configuration
	}

	private func testSpecificStoreURL() -> URL {
		let testBundle = Bundle(for: type(of: self))
		let filePath = testBundle.path(forResource: "default", ofType: "realm")!
		return URL(string: filePath)!
	}

	private func readOnlyStoreConfiguration() -> Realm.Configuration {
		var configuration = Realm.Configuration(fileURL: testSpecificStoreURL())
		configuration.readOnly = true
		return configuration
	}
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************

extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {

	func test_retrieve_deliversFailureOnRetrievalError() {
		let sut = makeSUT(notExistStoreConfiguration())

		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnFailure() {
		let sut = makeSUT(notExistStoreConfiguration())

		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
	}

}

extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {

	func test_insert_deliversErrorOnInsertionError() {
		let sut = makeSUT(readOnlyMemoryConfiguration())

		assertThatInsertDeliversErrorOnInsertionError(on: sut)
	}

	func test_insert_hasNoSideEffectsOnInsertionError() {
		let sut = makeSUT(readOnlyStoreConfiguration())

		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
	}

}

extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {

	func test_delete_deliversErrorOnDeletionError() {
		let sut = makeSUT(readOnlyMemoryConfiguration())

		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
	}

	func test_delete_hasNoSideEffectsOnDeletionError() {
		let sut = makeSUT(readOnlyStoreConfiguration())

		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
	}

}
