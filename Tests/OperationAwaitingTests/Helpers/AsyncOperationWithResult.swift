import Foundation

import HasResult
import RetryingOperation

import OperationAwaiting



class AsyncOperationWithResult : RetryingOperation, HasResult {
	
	struct NotFinished : Error {}
	
	let destination: String
	var result: Result<String, Error> = .failure(NotFinished())
	
	init(destination: String) {
		self.destination = destination
	}
	
	override func startBaseOperation(isRetry: Bool) {
		DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
			self.result = .success(self.destination)
			self.baseOperationEnded()
		})
	}
	
	override var isAsynchronous: Bool {
		return true
	}
	
}
