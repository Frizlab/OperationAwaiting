import Foundation

import HasResult



public extension OperationQueue {
	
	func addOperationWaitingForCompletion(_ op: Operation) async {
		assert(op.completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		await withTaskCancellationHandler(handler: { op.cancel() }, operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				op.completionBlock = {
					continuation.resume()
				}
				addOperation(op)
			}
		})
	}
	
	func addOperationWaitingForCompletionAndGetResult<O : Operation>(_ op: O) async throws -> O.ResultType where O : HasResult {
		assert(op.completionBlock == nil, "Async support for Operation, as implemented, requires the completion block to be left nil.")
		return try await withTaskCancellationHandler(handler: { op.cancel() }, operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<O.ResultType, Error>) -> Void in
				op.completionBlock = {
					continuation.resume(with: op.result)
				}
				addOperation(op)
			}
		})
	}
	
}
