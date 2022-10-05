import Foundation

import HasResult



public extension Operation {
	
	func startAndWait() async {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		await withTaskCancellationHandler(operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				completionBlock = { continuation.resume() }
				start()
			}
		}, onCancel: { cancel() })
	}
	
}


public extension HasResult where Self : Operation {
	
	func startAndGetResult() async throws -> ResultType {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		return try await withTaskCancellationHandler(operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<ResultType, Error>) -> Void in
				completionBlock = { continuation.resume(with: self.result) }
				start()
			}
		}, onCancel: { cancel() })
	}
	
}
