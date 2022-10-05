import Foundation

import HasResult



public extension OperationQueue {
	
	/**
	 Adds the given operation to the queue and waits (asynchronously) for the operation to complete.
	 
	 If the current task is cancelled, the operation will be cancelled too. */
	func addOperationAndWait(_ op: Operation) async {
		await withTaskCancellationHandler(operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume() }
				completionOperation.addDependency(op)
				
				addOperations([op, completionOperation], waitUntilFinished: false)
			}
		}, onCancel: { op.cancel() })
	}
	
	/**
	 Adds all the given operations to the queue and waits (asynchronously) for all of them to complete.
	 
	 If the current task is cancelled, all of the operations will be cancelled too. */
	func addOperationsAndWait(_ ops: [Operation]) async {
		await withTaskCancellationHandler(operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<Void, Never>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume() }
				for op in ops {completionOperation.addDependency(op)}
				
				addOperations(ops + [completionOperation], waitUntilFinished: false)
			}
		}, onCancel: { ops.forEach{ $0.cancel() } })
	}
	
	/**
	 Adds the given operation to the queue, waits (asynchronously) for the operation to complete and retrieves the operation result.
	 
	 If the current task is cancelled, the operation will be cancelled too. */
	func addOperationAndGetResult<O : Operation>(_ op: O) async throws -> O.ResultType where O : HasResult {
		return try await withTaskCancellationHandler(operation: {
			try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<O.ResultType, Error>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume(with: op.result) }
				completionOperation.addDependency(op)
				
				addOperations([op, completionOperation], waitUntilFinished: false)
			}
		}, onCancel: { op.cancel() })
	}
	
	/**
	 Adds the given operation to the queue, waits (asynchronously) for all of them to complete and retrieves the operation results.
	 The order of the results corresponds to the order of the operations.
	 
	 If the current task is cancelled, all of the operations will be cancelled too. */
	func addOperationsAndGetResults<O : Operation>(_ ops: [O]) async -> [Result<O.ResultType, Error>] where O : HasResult {
		return await withTaskCancellationHandler(operation: {
			await withCheckedContinuation{ (continuation: CheckedContinuation<[Result<O.ResultType, Error>], Never>) -> Void in
				let completionOperation = BlockOperation{ continuation.resume(returning: ops.map{ $0.result }) }
				for op in ops {completionOperation.addDependency(op)}
				
				addOperations(ops + [completionOperation], waitUntilFinished: false)
			}
		}, onCancel: { ops.forEach{ $0.cancel() } })
	}
	
}
