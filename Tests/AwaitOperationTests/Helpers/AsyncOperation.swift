import Foundation

import RetryingOperation



class AsyncOperation : RetryingOperation {
	
	override func startBaseOperation(isRetry: Bool) {
		DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: baseOperationEnded)
	}
	
	override var isAsynchronous: Bool {
		return true
	}
	
}
