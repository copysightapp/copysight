import Foundation

enum L10n {
  static func text(_ key: String, _ arguments: CVarArg...) -> String {
    String(
      format: NSLocalizedString(key, comment: ""), locale: Locale.current, arguments: arguments)
  }
}
