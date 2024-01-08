// swift-tools-version:5.9

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
        .package(url: "https://github.com/Lakr233/openssl-spm.git", from: "3.2.1"),
    ],
    targets: [
        .target(
            name: "CSSH2",
            dependencies: [
                .product(name: "OpenSSL", package: "openssl-spm"),
            ],
            cSettings: [
                .unsafeFlags(["-w"]),
                .define("HAVE_LIBSSL"),
                .define("HAVE_LIBZ"),
                .define("LIBSSH2_HAVE_ZLIB"),
                .define("LIBSSH2_OPENSSL"),
                
                .define("STDC_HEADERS"),
                .define("HAVE_ALLOCA"),
                .define("HAVE_ALLOCA_H"),
                .define("HAVE_ARPA_INET_H"),
                .define("HAVE_GETTIMEOFDAY"),
                .define("HAVE_INTTYPES_H"),
                .define("HAVE_MEMSET_S"),
                .define("HAVE_NETINET_IN_H"),
                .define("HAVE_O_NONBLOCK"),
                .define("HAVE_SELECT"),
                .define("HAVE_SNPRINTF"),
                .define("HAVE_STDIO_H"),
                .define("HAVE_STRTOLL"),
                .define("HAVE_SYS_IOCTL_H"),
                .define("HAVE_SYS_PARAM_H"),
                .define("HAVE_SYS_SELECT_H"),
                .define("HAVE_SYS_SOCKET_H"),
                .define("HAVE_SYS_TIME_H"),
                .define("HAVE_SYS_UIO_H"),
                .define("HAVE_SYS_UN_H"),
                .define("HAVE_UNISTD_H"),
            ]
        ),
        .testTarget(name: "CSSH2Test", dependencies: ["CSSH2"]),
    ],
    cxxLanguageStandard: .cxx11
)
