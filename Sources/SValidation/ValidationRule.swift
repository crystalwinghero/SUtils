import Foundation

public indirect enum ValidationRule {
  case empty
  case min(Double)
  case max(Double)
  case matched(pattern: String)
  case not(ValidationRule)
}
