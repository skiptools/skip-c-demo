// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import Foundation
import OSLog
@testable import SkipCDemo

fileprivate let logger: Logger = Logger(subsystem: "test", category: "SkipCDemoTests")

fileprivate let lib: DemoLibrary = DemoLibrary.instance

final class SkipCDemoTests: XCTestCase {
    func testSkipCDemo() throws {
        XCTAssertEqual(123, lib.demo_number())
        XCTAssertEqual("Hello Skip!", lib.demo_string())
        XCTAssertEqual(105.95723590826853, lib.demo_compute(n: 1_000_000, a: 2.5, b: 3.5))
        XCTAssertEqual(3, lib.add_with_assembly(a: 1, b: 2))
    }
}
