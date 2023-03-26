//
//  RuleValidatableTests.swift
//  
//
//  Created by Crystalwing Bakaboe on 3/26/23.
//

import XCTest
@testable import SValidation

private let kPatternNum: String = #"^[0-9]+$"#
final class RuleValidatableTests: XCTestCase {
  
  let rules: [ValidationRule] = [
    .empty,
    .min(6),
    .max(10),
    .matched(pattern: kPatternNum),
    .not(.empty),
    .not(.min(6)),
    .not(.max(10)),
    .not(.matched(pattern: kPatternNum)),
  ]
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_rules_int() throws {
    let testCases: [[(value: Int, expected: Bool)]] = [
      [ (0, true), (-1, false), (1, false) ],
      [ (-1, false), (5, false), (6, true), (10, true), (20, true) ],
      [ (-1, true), (5, true), (6, true), (10, true), (20, false) ],
      [ (-1, false), (5, true), (6, true), (10, true), (20, true) ],
      [ (0, false), (-1, true), (1, true) ],
      [ (-1, true), (5, true), (6, false), (10, false), (20, false) ],
      [ (-1, false), (5, false), (6, false), (10, false), (20, true) ],
      [ (-1, true), (5, false), (6, false), (10, false), (20, false) ],
    ]
    
    for i in 0..<rules.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(rule: rules[i]), test.expected)
      }
    }
  }
  
  func test_rules_double() throws {
    let testCases: [[(value: Double, expected: Bool)]] = [
      [ (0, true), (-1, false), (1, false), (0.1234, false) ],
      [ (-1, false), (5, false), (6, true), (10, true), (20, true) ],
      [ (-1, true), (5, true), (6, true), (10, true), (20, false) ],
      [ (-1, false), (5, false), (6, false), (10, false), (20, false) ],
      [ (0, false), (-1, true), (1, true), (0.1234, true) ],
      [ (-1, true), (5, true), (6, false), (10, false), (20, false) ],
      [ (-1, false), (5, false), (6, false), (10, false), (20, true) ],
      [ (-1, true), (5, true), (6, true), (10, true), (20, true) ],
    ]
    
    for i in 0..<rules.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(rule: rules[i]), test.expected)
        let float = Float(test.value)
        XCTAssertEqual(float.validate(rule: rules[i]), test.expected)
      }
    }
  }
  
  func test_rules_string() throws {
    let testCases: [[(value: String, expected: Bool)]] = [
      [ ("", true), (" ", false), ("abc", false), ("123456", false) ],
      [ ("", false), (" ", false), ("abc", false), ("123456", true) ],
      [ ("", true), (" ", true), ("abc", true), ("12345678910", false) ],
      [ ("", false), (" ", false), ("abc", false), ("12345678910", true) ],
      [ ("", false), (" ", true), ("abc", true), ("123456", true) ],
      [ ("", true), (" ", true), ("abc", true), ("123456", false) ],
      [ ("", false), (" ", false), ("abc", false), ("12345678910", true) ],
      [ ("", true), (" ", true), ("abc", true), ("12345678910", false) ],
    ]
    
    for i in 0..<rules.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(rule: rules[i]), test.expected)
      }
    }
  }
  
  
}
