import Foundation

public indirect enum ValidationComposition {
  case rule(ValidationRule)
  case and([ValidationComposition])
  case or([ValidationComposition])
  case not(ValidationComposition)
}
