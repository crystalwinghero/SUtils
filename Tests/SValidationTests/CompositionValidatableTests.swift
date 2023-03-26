//
//  CompositionValidatableTests.swift
//  
//
//  Created by Crystalwing Bakaboe on 3/26/23.
//

import XCTest
@testable import SValidation

extension String: CompositionValidatable {}
extension Int: CompositionValidatable {}
extension Double: CompositionValidatable {}
extension Float: CompositionValidatable {}

private let kPatternNum: String = #"^[0-9]+$"#
final class CompositionValidatableTests: XCTestCase {
  
  let singleRuleCompositions: [ValidationComposition] = [
    .rule(.empty),
    .rule(.min(6)),
    .rule(.max(10)),
    .rule(.matched(pattern: kPatternNum)),
    .rule(.not(.empty)),
    .rule(.not(.min(6))),
    .rule(.not(.max(10))),
    .rule(.not(.matched(pattern: kPatternNum))),
  ]
  
  let compositions: [ValidationComposition] = [
    .and([
      .rule(.min(6)),
      .rule(.max(10)),
    ]),
    .or([
      .rule(.min(6)),
      .rule(.max(10)),
    ]),
    .not(
      .and([
        .rule(.min(6)),
        .rule(.max(10)),
      ])
    ),
    .not(
      .or([
        .rule(.min(6)),
        .rule(.max(10)),
      ])
    ),
  ]
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_single_rule_composition_int() throws {
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
    
    for i in 0..<singleRuleCompositions.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(composition: singleRuleCompositions[i]), test.expected)
      }
    }
  }
  
  func test_single_rule_composition_double() throws {
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
    
    for i in 0..<singleRuleCompositions.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(composition: singleRuleCompositions[i]), test.expected)
        let float = Float(test.value)
        XCTAssertEqual(float.validate(composition: singleRuleCompositions[i]), test.expected)
      }
    }
  }
  
  func test_single_rule_composition_string() throws {
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
    
    for i in 0..<singleRuleCompositions.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(composition: singleRuleCompositions[i]), test.expected)
      }
    }
  }
  
  func test_compositons_string() throws {
    let testCases: [[(value: String, expected: Bool)]] = [
      [ ("", false), ("123456", true), ("12345678", true), ("1234567890", true), ("1234567890a", false) ],
      [ ("", true), ("123456", true), ("12345678", true), ("1234567890", true), ("1234567890a", true) ],
      [ ("", true), ("123456", false), ("12345678", false), ("1234567890", false), ("1234567890a", true) ],
      [ ("", false), ("123456", false), ("12345678", false), ("1234567890", false), ("1234567890a", false) ],
    ]
    
    for i in 0..<compositions.count {
      for test in testCases[i] {
        XCTAssertEqual(test.value.validate(composition: compositions[i]), test.expected)
      }
    }
  }
  
}
