import Foundation

public protocol RuleValidatable {
  func validate(rule: ValidationRule) -> Bool
}

public protocol CompositionValidatable: RuleValidatable {
  func validate(composition: ValidationComposition) -> Bool
}

extension CompositionValidatable {
  public func validate(composition: ValidationComposition) -> Bool {
    switch composition {
    case .rule(let validationRule):
      return self.validate(rule: validationRule)
    case .and(let array):
      return array.reduce(true, { $0 && self.validate(composition: $1) })
    case .or(let array):
      return array.firstIndex(where: { self.validate(composition: $0) }) != nil
    case .not(let validationComposition):
      return !self.validate(composition: validationComposition)
    }
  }
}

public protocol SValidatable {
  func validate(_ value: Any, with composition: ValidationComposition) -> [ValidationRule]
}
