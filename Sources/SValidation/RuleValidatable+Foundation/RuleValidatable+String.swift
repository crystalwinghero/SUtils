import Foundation

extension String: RuleValidatable {
  public func validate(rule: ValidationRule) -> Bool {
    switch rule {
    case .empty:
      return isEmpty
    case .min(let double):
      return count >= Int(double)
    case .max(let double):
      return count <= Int(double)
    case .matched(let pattern):
      return range(of: pattern, options: .regularExpression) != nil
    case .not(let validationRule):
      return !validate(rule: validationRule)
    }
  }
}
