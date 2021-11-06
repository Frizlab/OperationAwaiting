// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "OperationAwaiting",
	platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
	products: [.library(name: "OperationAwaiting", targets: ["OperationAwaiting"])],
	dependencies: [
		.package(url: "https://github.com/happn-tech/RetryingOperation.git", from: "1.1.7")
	],
	targets: [
		.target(name: "OperationAwaiting"),
		.testTarget(name: "OperationAwaitingTests", dependencies: [
			"OperationAwaiting",
			/* Convenience to create async operations. */
			.product(name: "RetryingOperation", package: "RetryingOperation")
		])
	]
)
