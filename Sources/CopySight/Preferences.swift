import CopySightCore
import Foundation

enum PreferenceKey {
  static let language = "recognitionLanguage"
  static let preserveLineBreaks = "preserveLineBreaks"
  static let languageCorrection = "languageCorrection"
  static let copyAutomatically = "copyAutomatically"
  static let playSound = "playSound"
  static let shortcutKeyCode = "shortcutKeyCode"
  static let shortcutModifiers = "shortcutModifiers"
  static let shortcutLabel = "shortcutLabel"
}

struct RecognitionPreferences {
  let language: RecognitionLanguage
  let preserveLineBreaks: Bool
  let languageCorrection: Bool
  let copyAutomatically: Bool
  let playSound: Bool

  var recognitionOptions: RecognitionOptions {
    RecognitionOptions(
      language: language,
      preserveLineBreaks: preserveLineBreaks,
      languageCorrection: languageCorrection
    )
  }

  static var current: Self {
    let defaults = UserDefaults.standard
    return Self(
      language: RecognitionLanguage(rawValue: defaults.string(forKey: PreferenceKey.language) ?? "")
        ?? .automatic,
      preserveLineBreaks: defaults.object(forKey: PreferenceKey.preserveLineBreaks) as? Bool
        ?? true,
      languageCorrection: defaults.object(forKey: PreferenceKey.languageCorrection) as? Bool
        ?? true,
      copyAutomatically: defaults.object(forKey: PreferenceKey.copyAutomatically) as? Bool ?? true,
      playSound: defaults.object(forKey: PreferenceKey.playSound) as? Bool ?? true
    )
  }
}
