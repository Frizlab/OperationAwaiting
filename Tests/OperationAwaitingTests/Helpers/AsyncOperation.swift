import Foundation

import RetryingOperation

import OperationAwaiting



class AsyncOperation : RetryingOperation, @unchecked Sendable, SendableOperation {
	
	override func startBaseOperation(isRetry: Bool) {
		DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(250), execute: baseOperationEnded)
	}
	
	override var isAsynchronous: Bool {
		return true
	}
	
}
