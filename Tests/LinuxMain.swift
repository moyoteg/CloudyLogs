import XCTest

import logTests

var tests = [XCTestCaseEntry]()
tests += logTests.allTests()
XCTMain(tests)
