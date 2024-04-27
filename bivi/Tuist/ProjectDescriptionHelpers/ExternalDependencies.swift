import ProjectDescription

public struct SPMDependency {
    let url: String
    let name: String
    let requirement: Package.Requirement

    var package: Package {
        .remote(url: url, requirement: requirement)
    }

    var targetDependency: TargetDependency {
        .package(product: name)
    }
}

public extension SPMDependency {
    static let kingfisher = SPMDependency(
        url: "https://github.com/onevcat/Kingfisher",
        name: "Kingfisher",
        requirement: .exact("7.11.0")
    )
    static let factory = SPMDependency(
        url: "https://github.com/hmlongco/Factory",
        name: "Factory",
        requirement: .exact("2.3.2")
    )

    static let cocoaLumberjack = SPMDependency(
        url: "https://github.com/CocoaLumberjack/CocoaLumberjack",
        name: "CocoaLumberjack",
        requirement: .exact("3.8.5")
    )

    static let cocoaLumberjackSwift = SPMDependency(
        url: "https://github.com/CocoaLumberjack/CocoaLumberjack",
        name: "CocoaLumberjackSwift",
        requirement: .exact("3.8.5")
    )

    static let swiftUISnackbar = SPMDependency(
        url: "https://github.com/zaniluca/SwiftUISnackbar",
        name: "SwiftUISnackbar",
        requirement: .exact("1.0.0")
    )
}
