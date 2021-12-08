import XCTest

import HasResult

@testable import OperationAwaiting



final class OperationAwaitingTests : XCTestCase {
	
	func testReadmeExample() async throws {
		struct OperationNotStarted : Error {}
		
		final class MyOperation : Operation, HasResult {
			
			var result: Result<Int, Error> = .failure(OperationNotStarted())
			
			override func main() {
				result = .success(42)
			}
			
		}
		
		let q = OperationQueue()
		let op = MyOperation()
		XCTAssert(op.result.failure is OperationNotStarted)
		let r = try await q.addOperationAndGetResult(op)
		XCTAssertEqual(r, 42)
		XCTAssertEqual(op.result.success, 42)
	}
	
	func testStartNoResult() async throws {
		let startDate = Date()
		await AsyncOperation().startAndWait()
		XCTAssertLessThanOrEqual(startDate.timeIntervalSinceNow, -0.25)
	}
	
	func testStartWithResult() async throws {
		let expected = "Hello! " + String((0..<5).map{ _ in "abcdefghijqlmnopqrstuvwxyz".randomElement()! })
		
		let operation = AsyncOperationWithResult(destination: expected)
		XCTAssertNil(operation.result.success)
		XCTAssert(operation.result.failure is AsyncOperationWithResult.NotFinished)
		
		let task = Task<String, Error>{
			return try await operation.startAndGetResult()
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
