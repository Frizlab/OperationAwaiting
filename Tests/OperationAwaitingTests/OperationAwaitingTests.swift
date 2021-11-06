import XCTest

@testable import OperationAwaiting



final class OperationAwaitingTests : XCTestCase {
	
	func testStartNoResult() async throws {
		let startDate = Date()
		await AsyncOperation().startAsync()
		XCTAssertLessThanOrEqual(startDate.timeIntervalSinceNow, -0.25)
	}
	
	func testStartWithResult() async throws {
		let expected = "Hello! " + String((0..<5).map{ _ in "abcdefghijqlmnopqrstuvwxyz".randomElement()! })
		
		let operation = AsyncOperationWithResult(destination: expected)
		XCTAssertNil(operation.result.success)
		XCTAssert(operation.result.failure is AsyncOperationWithResult.NotFinished)
		
		let task = Task<String, Error>{
			return try await operation.startAsync()
		}
		XCTAssertNil(operation.result.success)
		
		let res = await task.result.success
		XCTAssertEqual(res, expected)
	}
	
}


extension Result {
	
	var failure: Failure? {
		switch self {
			case .success:        return nil
			case .failure(let r): return r
		}
	}
	
	var success: Success? {
		switch self {
			case .success(let r): return r
			case .failure:        return nil
		}
	}
	
}
