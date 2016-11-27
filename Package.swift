// Generated automatically by Perfect Assistant Application
// Date: 2016-11-26 22:23:57 +0000
import PackageDescription
let package = Package(
    name: "PerfectTurnstilePostgreSQL",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/SwiftORM/Postgres-StORM.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/iamjono/SwiftString.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/iamjono/SwiftRandom.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/PerfectSideRepos/Turnstile-Perfect.git", versions: Version(1,0,0)..<Version(1,9223372036854775807,9223372036854775807)),
    ]
)