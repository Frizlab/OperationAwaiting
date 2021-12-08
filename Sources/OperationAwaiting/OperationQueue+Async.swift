import Foundation

import HasResult



public extension OperationQueue {
	
	/**
	 Removed because there are situations where using non-async `addOperation` becomes impossible.
	 
	 Provided as an alias to `addOperationAndWait`, but might ambiguous.
	 Also does not provide intent to wait in its name, though the mandatory `await` keyword should make it clear enough. */
//	func addOperation(_ op: Operation) async {
//		await addOperationAndWait(op)
//	}
	
	func addOperationAndWait(_ op: Operation) async {
		await withTaskCancellationHandler(handler: { op.cancel() }, operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume() }
				completionOperation.addDependency(op)
				
				addOperations([op, completionOperation], waitUntilFinished: false)
			}
		})
	}
	
	/**
	 Removed because there are situations where using non-async non-throwing `addOperation` becomes impossible.
	 
	 Provided as an alias to `addOperationAndGetResult`, but might ambiguous. */
//	func addOperation<O : Operation>(_ op: O) async throws -> O.ResultType where O : HasResult {
//		return try await addOperationAndGetResult(op)
//	}
	
	func addOperationAndGetResult<O : Operation>(_ op: O) async throws -> O.ResultType where O : HasResult {
		return try await withTaskCancellationHandler(handler: { op.cancel() }, operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<O.ResultType, Error>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume(with: op.result) }
				completionOperation.addDependency(op)
				
				addOperations([op, completionOperation], waitUntilFinished: false)
			}
		})
	}
	
}
