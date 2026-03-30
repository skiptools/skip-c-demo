// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import Foundation
@testable import SkipCDemo

fileprivate let lib: DemoLibrary = DemoLibrary.instance

final class SkipCDemoTests: XCTestCase {
    func testSkipCDemo() throws {
        XCTAssertEqual(123, lib.demo_number())
        XCTAssertEqual("Hello Skip!", lib.demo_string())
        XCTAssertEqual(105.95723590826853, lib.demo_compute(n: 1_000_000, a: 2.5, b: 3.5))
        XCTAssertEqual(3, lib.add_with_assembly(a: 1, b: 2))
    }
}
