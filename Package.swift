// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "AwaitOperation",
	platforms: [.macOS(.v12)],
	products: [.library(name: "AwaitOperation", targets: ["AwaitOperation"])],
	dependencies: [
		.package(url: "https://github.com/happn-tech/RetryingOperation.git", from: "1.1.7")
	],
	targets: [
		.target(name: "AwaitOperation"),
		.testTarget(name: "AwaitOperationTests", dependencies: [
			"AwaitOperation",
			/* Convenience to create async operations. */
			.product(name: "RetryingOperation", package: "RetryingOperation")
		])
	]
)
