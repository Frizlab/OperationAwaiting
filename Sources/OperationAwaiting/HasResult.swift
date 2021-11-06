import Foundation



public protocol HasResult {
	
	associatedtype ResultType
	var result: Result<ResultType, Error> {get}
	
}
