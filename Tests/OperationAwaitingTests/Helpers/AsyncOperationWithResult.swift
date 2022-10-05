import Foundation

import HasResult
import RetryingOperation

import OperationAwaiting



class AsyncOperationWithResult : RetryingOperation, @unchecked Sendable, SendableOperation, HasResult {
	
	struct NotFinished : Error {}
	
	let destination: String
	private var lock = NSLock()
	private var _result: Result<String, Error> = .failure(NotFinished())
	var result: Result<String, Error> {
		get {lock.withLock{ _result }}
		set {lock.withLock{ _result = newValue }}
	}
	
	init(destination: String) {
		self.destination = destination
	}
	
	override func startBaseOperation(isRetry: Bool) {
		DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(250), execute: {
			self.result = .success(self.destination)
			self.baseOperationEnded()
		})
	}
	
	override var isAsynchronous: Bool {
		return true
	}
	
}
