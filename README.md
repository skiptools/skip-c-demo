# SkipCDemo

This is a [Skip](https://skip.tools) Swift/Kotlin library project demonstrating the use C code from Swift on both Darwin (iOS & macOS) and Android. It utilized Swift's built-in C integration on the Swift side, and takes advantage of gradle's support for building with the Android NDK using the cmake build tool.

Calling C from the transpiled Kotlin is enabled by creating a Java Native Access (JNA) direct mapping class containing the library's functions, marked with `SKIP EXTERN` to cause the Skip transpiler to annotate the functions so JNA lines them up with the equivalent C functions.

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
