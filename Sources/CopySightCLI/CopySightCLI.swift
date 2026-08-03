import CopySightCore
import CoreGraphics
import Darwin
import Foundation
import ImageIO

@main
enum CopySightCLI {
  static let version = "1.0.0"

  static func main() async {
    do {
      let command = try parse(Array(CommandLine.arguments.dropFirst()))
      switch command {
      case .help:
        print(help)
      case .version:
        print("copysight \(version)")
      case .recognize(let path, let options):
        let image = try loadImage(path: path)
        let text = try await TextRecognizer().recognize(image, options: options)
        guard !text.isEmpty else { throw CLIError.noText }
        print(text)
      }
    } catch {
      writeError("copysight: \(error.localizedDescription)")
      writeError("Run 'copysight --help' for usage.")
      exit(1)
    }
  }

  private enum Command {
    case help
    case version
    case recognize(path: String, options: RecognitionOptions)
  }

  private enum CLIError: LocalizedError {
    case missingImage
    case multipleImages
    case unknownOption(String)
    case missingLanguage
    case unsupportedLanguage(String)
    case unreadableImage(String)
    case noText

    var errorDescription: String? {
      switch self {
      case .missingImage: "missing image path"
      case .multipleImages: "only one image can be recognized at a time"
      case .unknownOption(let option): "unknown option '\(option)'"
      case .missingLanguage: "--language requires auto, en, or es"
      case .unsupportedLanguage(let language): "unsupported language '\(language)'"
      case .unreadableImage(let path): "cannot read an image from '\(path)'"
      case .noText: "no text found"
      }
    }
  }

  private static func parse(_ arguments: [String]) throws -> Command {
    if arguments == ["--help"] || arguments == ["-h"] { return .help }
    if arguments == ["--version"] || arguments == ["-v"] { return .version }

    var language = RecognitionLanguage.automatic
    var preserveLineBreaks = true
    var languageCorrection = true
    var imagePath: String?
    var index = 0

    while index < arguments.count {
      let argument = arguments[index]
      switch argument {
      case "--language", "-l":
        index += 1
        guard index < arguments.count else { throw CLIError.missingLanguage }
        switch arguments[index].lowercased() {
        case "auto", "automatic": language = .automatic
        case "en", "english": language = .english
        case "es", "spanish": language = .spanish
        default: throw CLIError.unsupportedLanguage(arguments[index])
        }
      case "--single-line": preserveLineBreaks = false
      case "--no-correction": languageCorrection = false
      default:
        if argument.hasPrefix("-") { throw CLIError.unknownOption(argument) }
        guard imagePath == nil else { throw CLIError.multipleImages }
        imagePath = argument
      }
      index += 1
    }

    guard let imagePath else { throw CLIError.missingImage }
    return .recognize(
      path: imagePath,
      options: RecognitionOptions(
        language: language,
        preserveLineBreaks: preserveLineBreaks,
        languageCorrection: languageCorrection
      )
    )
  }

  private static func loadImage(path: String) throws -> CGImage {
    let url = URL(fileURLWithPath: path).standardizedFileURL
    guard
      let source = CGImageSourceCreateWithURL(url as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
    else {
      throw CLIError.unreadableImage(path)
    }
    return image
  }

  private static func writeError(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
  }

  private static let help = """
    CopySight CLI — local OCR for macOS

    USAGE
      copysight [options] <image>

    OPTIONS
      -l, --language <auto|en|es>  Recognition language (default: auto)
          --single-line            Replace line breaks with spaces
          --no-correction          Disable language correction
      -v, --version                Print the version
      -h, --help                   Show this help

    EXAMPLES
      copysight screenshot.png
      copysight --language es scan.jpg
      copysight --single-line document.heic

    Images are processed on this Mac and are never uploaded.
    """
}
