import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "Bivi", platform: .iOS, spmDependencies: [
    .kingfisher,
    .factory
])
