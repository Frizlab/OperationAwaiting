import Foundation

import HasResult



public extension Operation {
	
	func startAsync() async {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		await withTaskCancellationHandler(handler: { cancel() }, operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				completionBlock = {
					continuation.resume()
				}
				start()
			}
		})
	}
	
}


public extension HasResult where Self : Operation {
	
	func startAsync() async throws -> ResultType {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		return try await withTaskCancellationHandler(handler: { cancel() }, operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<ResultType, Error>) -> Void in
				completionBlock = {
					continuation.resume(with: self.result)
				}
				start()
			}
		})
	}
	
}
