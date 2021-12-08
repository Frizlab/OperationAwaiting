import Foundation

import HasResult



public extension Operation {
	
	/**
	 Removed because there are situations where using non-async `start` becomes impossible.
	 
	 Provided as an alias to `startAndWait`, but might ambiguous.
	 Also does not provide intent to wait in its name, though the mandatory `await` keyword should make it clear enough. */
//	func start() async {
//		await startAndWait()
//	}
	
	func startAndWait() async {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		await withTaskCancellationHandler(handler: { cancel() }, operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				completionBlock = { continuation.resume() }
				start()
			}
		})
	}
	
}


public extension HasResult where Self : Operation {
	
	/**
	 Removed because there are situations where using non-async non-throwing `start` becomes impossible.
	 
	 Provided as an alias to `startAndGetResult`, but might ambiguous. */
//	func start() async throws -> ResultType {
//		return try await startAndGetResult()
//	}
	
	func startAndGetResult() async throws -> ResultType {
		assert(completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		return try await withTaskCancellationHandler(handler: { cancel() }, operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<ResultType, Error>) -> Void in
				completionBlock = { continuation.resume(with: self.result) }
				start()
			}
		})
	}
	
}
