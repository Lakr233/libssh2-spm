// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "CSSH2",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .watchOS(.v5),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "CSSH2", targets: ["CSSH2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Lakr233/openssl-spm.git", from: "3.5.0"),
    ],
    targets: [
        .target(
            name: "CSSH2",
            dependencies: [
                .product(name: "OpenSSL", package: "openssl-spm"),
            ],
            cSettings: [
                // Crypto backend
                .define("HAVE_LIBSSL"),
                .define("LIBSSH2_OPENSSL"),

                // Compression support
                .define("HAVE_LIBZ"),
                .define("LIBSSH2_HAVE_ZLIB"),

                // Standard C headers
                .define("STDC_HEADERS"),
                .define("HAVE_STDLIB_H"), // Added
                .define("HAVE_STDIO_H"),
                .define("HAVE_INTTYPES_H"),
                .define("HAVE_UNISTD_H"),

                // Memory functions
                .define("HAVE_ALLOCA"),
                .define("HAVE_ALLOCA_H"),
                // REMOVED: HAVE_MEMSET_S (causes compilation errors)

                // Network headers
                .define("HAVE_ARPA_INET_H"),
                .define("HAVE_NETINET_IN_H"),
                .define("HAVE_SYS_SOCKET_H"),
                .define("HAVE_SYS_UN_H"),

                // System headers
                .define("HAVE_SYS_IOCTL_H"),
                .define("HAVE_SYS_PARAM_H"),
                .define("HAVE_SYS_SELECT_H"),
                .define("HAVE_SYS_TIME_H"),
                .define("HAVE_SYS_UIO_H"),

                // I/O and time functions
                .define("HAVE_GETTIMEOFDAY"),
                .define("HAVE_SELECT"),
                .define("HAVE_SNPRINTF"),
                .define("HAVE_STRTOLL"),

                // Non-blocking socket support
                .define("HAVE_O_NONBLOCK"),
                .define("HAVE_FIONBIO"), // Added
            ],
            linkerSettings: [
                .linkedLibrary("z"), // Added - explicit zlib linking
            ]
        ),
        .testTarget(name: "CSSH2Test", dependencies: ["CSSH2"]),
    ],
    cLanguageStandard: .c11 // Changed from cxxLanguageStandard
)
