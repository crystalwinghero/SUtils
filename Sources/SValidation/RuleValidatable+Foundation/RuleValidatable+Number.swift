import Foundation

extension Int: RuleValidatable {
  public func validate(rule: ValidationRule) -> Bool {
    switch rule {
    case .empty:
      return self == 0
    case .min(let double):
      return self >= Int(double)
    case .max(let double):
      return self <= Int(double)
    case .matched(let pattern):
      return "\(self)".range(of: pattern, options: .regularExpression) != nil
    case .not(let validationRule):
      return !validate(rule: validationRule)
    }
  }
}

extension Double: RuleValidatable {
  public func validate(rule: ValidationRule) -> Bool {
    switch rule {
    case .empty:
      return self == 0.0
    case .min(let double):
      return self >= double
    case .max(let double):
      return self <= double
    case .matched(let pattern):
      return "\(self)".range(of: pattern, options: .regularExpression) != nil
    case .not(let validationRule):
      return !validate(rule: validationRule)
    }
  }
}

extension Float: RuleValidatable {
  public func validate(rule: ValidationRule) -> Bool {
    return Double(self).validate(rule: rule)
  }
}

extension Decimal: RuleValidatable {
  public func validate(rule: ValidationRule) -> Bool {
    switch rule {
    case .empty:
      return self.isZero
    case .min(let double):
      return !self.isLess(than: Decimal(double))
    case .max(let double):
      return self.isLessThanOrEqualTo(Decimal(double))
    case .matched(let pattern):
      return "\(self)".range(of: pattern, options: .regularExpression) != nil
    case .not(let validationRule):
      return !validate(rule: validationRule)
    }
  }
}
