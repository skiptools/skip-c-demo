# SkipCDemo

This is a [Skip](https://skip.tools) Swift/Kotlin library project demonstrating the use of C code from Swift on both Darwin (iOS & macOS) and Android. It utilizes Swift's built-in C integration on the Swift side, and takes advantage of gradle's support for building with the Android NDK using the cmake build tool on the Kotlin side. 

The C code is called from the transpiled Kotlin using Java Native Access (JNA). A JNA direct mapping class `SkipCDemo.swift` contains the library's functions, marked with `SKIP EXTERN` to cause the Skip transpiler to annotate the functions so JNA lines them up with the equivalent C functions.

This project can used as a starting point for integrating C/C++ code into a dual-platform Skip app. 

## Project Structure

```plaintext
.
├── Package.swift
├── Sources
│   ├── LibCLibrary
│   │   ├── CMakeLists.txt
│   │   ├── include
│   │   │   └── demo.h
│   │   └── src
│   │       └── demo.c
│   └── SkipCDemo
│       ├── Skip
│       │   └── skip.yml
│       └── SkipCDemo.swift
└── Tests
    └── SkipCDemoTests
        ├── Skip
        │   └── skip.yml
        ├── SkipCDemoTests.swift
        └── XCSkipTests.swift
```

## Implementation Details

Running `swift test` will run the Swift tests as well as the transpiled Kotlin tests against the native library's declared functions.

The `LibCLibrary` Swift target builds a `SkipCDemo.framework` for Xcode or `libSkipCDemo.dylib` for SwiftPM. These libraries are built for the host system (macOS, either ARM or Intel), and when testing the `SkipCDemoTests` target, the correct local shared library is linked, and so the Robolectric JVM tests use the same shared library that is used by the Swift tests.

When building and testing for Android (either the emulator or device), the generated gradle contains the `externalNativeBuild` clause, directing it to use the `CMakeLists.txt` to build the native libraries for each of the supported Android NDK targets. The resulting `LibCLibrary.aar` archive will look something like:

```plaintext
classes.dex
lib/arm64-v8a/libclibrary.so
lib/armeabi-v7a/libclibrary.so
lib/x86/libclibrary.so
lib/x86_64/libclibrary.so
AndroidManifest.xml
resources.arsc
```

## Project Structure

The target definition for a native target in the `Package.swift` file must contain only
`.c` and `.cpp` source files; it is not permitted to mix in `.swift` files.
In addition, the target containing the native libraries must declare a `publicHeadersPath`
and add the `skipstone` plugin in order for Skip to generate gradle build for the native module.


```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skip-c-demo",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipCDemo", type: .dynamic, targets: ["SkipCDemo"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.40"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.0.0"),
        .package(url: "https://source.skip.tools/skip-ffi.git", from: "0.0.0")
    ],
    targets: [
        .target(name: "SkipCDemo", dependencies: [
            "LibCLibrary",
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipFFI", package: "skip-ffi")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),

        .testTarget(name: "SkipCDemoTests", dependencies: [
            "SkipCDemo",
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),

        .target(name: "LibCLibrary", sources: ["src"], publicHeadersPath: "include", plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

```


## Building

Building the module requires that Skip be installed using 
[Homebrew](https://brew.sh) with `brew install skiptools/skip/skip`.
This will also install the necessary build prerequisites:
Kotlin, Gradle, and the Android build tools.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.
