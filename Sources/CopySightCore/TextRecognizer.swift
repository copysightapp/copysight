import CoreGraphics
import Foundation
import Vision

public enum RecognitionLanguage: String, CaseIterable, Identifiable {
  case automatic
  case english
  case spanish

  public var id: Self { self }

  public var title: String {
    switch self {
    case .automatic: "Automatic"
    case .english: "English"
    case .spanish: "Spanish"
    }
  }

  var visionLanguages: [String]? {
    switch self {
    case .automatic: nil
    case .english: ["en-US"]
    case .spanish: ["es-ES"]
    }
  }
}

public struct RecognitionOptions {
  public let language: RecognitionLanguage
  public let preserveLineBreaks: Bool
  public let languageCorrection: Bool

  public init(
    language: RecognitionLanguage = .automatic,
    preserveLineBreaks: Bool = true,
    languageCorrection: Bool = true
  ) {
    self.language = language
    self.preserveLineBreaks = preserveLineBreaks
    self.languageCorrection = languageCorrection
  }
}

struct RecognizedFragment: Equatable {
  let text: String
  let bounds: CGRect
}

enum OCRTextLayout {
  static func render(_ fragments: [RecognizedFragment], preserveLineBreaks: Bool) -> String {
    let ordered =
      fragments
      .filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
      .sorted {
        let verticalTolerance = max($0.bounds.height, $1.bounds.height) * 0.45
        if abs($0.bounds.midY - $1.bounds.midY) <= verticalTolerance {
          return $0.bounds.minX < $1.bounds.minX
        }
        return $0.bounds.midY > $1.bounds.midY
      }
      .map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }

    return ordered.joined(separator: preserveLineBreaks ? "\n" : " ")
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

public final class TextRecognizer {
  public init() {}

  public func recognize(_ image: CGImage, options: RecognitionOptions = .init()) async throws
    -> String
  {
    try await Task.detached(priority: .userInitiated) {
      try autoreleasepool {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = options.languageCorrection
        request.automaticallyDetectsLanguage = options.language == .automatic
        if let languages = options.language.visionLanguages {
          request.recognitionLanguages = languages
        }

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try handler.perform([request])
        let fragments = (request.results ?? []).compactMap { observation -> RecognizedFragment? in
          guard let candidate = observation.topCandidates(1).first else { return nil }
          return RecognizedFragment(text: candidate.string, bounds: observation.boundingBox)
        }
        return OCRTextLayout.render(fragments, preserveLineBreaks: options.preserveLineBreaks)
      }
    }.value
  }
}
