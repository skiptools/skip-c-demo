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


## Building

This project is a free Swift Package Manager module that uses the
[Skip](https://skip.tools) plugin to transpile Swift into Kotlin.

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
