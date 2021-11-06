// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "OperationAwaiting",
	platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
	products: [.library(name: "OperationAwaiting", targets: ["OperationAwaiting"])],
	dependencies: [
		.package(url: "https://github.com/Frizlab/HasResult.git", from: "1.0.0"),
		.package(url: "https://github.com/happn-tech/RetryingOperation.git", from: "1.1.7")
	],
	targets: [
		.target(name: "OperationAwaiting", dependencies: [
			.product(name: "HasResult", package: "HasResult")
		]),
		.testTarget(name: "OperationAwaitingTests", dependencies: [
			"OperationAwaiting",
			.product(name: "HasResult",         package: "HasResult"),
			.product(name: "RetryingOperation", package: "RetryingOperation") /* Convenience to create async operations. */
		])
	]
)
