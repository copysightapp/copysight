import AppKit
import CopySightCore

@MainActor
final class AppModel {
  enum Phase: Equatable {
    case idle
    case selecting
    case recognizing
    case copied(characterCount: Int)
    case found(characterCount: Int)
    case noText
    case failed(String)

    var message: String {
      switch self {
      case .idle: "Ready"
      case .selecting: "Drag over text; Escape cancels"
      case .recognizing: "Recognizing…"
      case .copied(let count): "Copied \(count) characters"
      case .found(let count): "Found \(count) characters"
      case .noText: "No text found"
      case .failed(let message): message
      }
    }

    var isBusy: Bool {
      self == .selecting || self == .recognizing
    }
  }

  var onChange: (() -> Void)?
  private(set) var phase: Phase = .idle { didSet { onChange?() } }
  private(set) var lastText = "" { didSet { onChange?() } }
  private(set) var hasPreviousSelection = false { didSet { onChange?() } }

  private let overlay = SelectionOverlayController()
  private let screenCapture = ScreenCaptureService()
  private let recognizer = TextRecognizer()
  private var previousSelection: ScreenSelection?

  func captureText() {
    guard !phase.isBusy else { return }
    phase = .selecting
    overlay.present { [weak self] selection in
      guard let self else { return }
      guard let selection else {
        self.phase = .idle
        return
      }
      self.previousSelection = selection
      self.hasPreviousSelection = true
      self.phase = .recognizing
      Task { await self.process(selection) }
    }
  }

  func capturePreviousSelection() {
    guard !phase.isBusy, let previousSelection else { return }
    phase = .recognizing
    Task { await process(previousSelection) }
  }

  func copyLastText() {
    guard !lastText.isEmpty else { return }
    copyToPasteboard(lastText)
    phase = .copied(characterCount: lastText.count)
  }

  func reportHotKeyUnavailable() {
    phase = .failed("Shortcut unavailable; choose another in Settings")
  }

  private func process(_ selection: ScreenSelection) async {
    do {
      // Let WindowServer remove the selection overlay before taking the shot.
      try await Task.sleep(nanoseconds: 80_000_000)
      let image = try await screenCapture.capture(selection)
      let preferences = RecognitionPreferences.current
      let text = try await recognizer.recognize(image, options: preferences.recognitionOptions)
      guard !text.isEmpty else {
        phase = .noText
        NSSound.beep()
        return
      }

      lastText = text
      if preferences.copyAutomatically {
        copyToPasteboard(text)
        phase = .copied(characterCount: text.count)
      } else {
        phase = .found(characterCount: text.count)
      }
      if preferences.playSound {
        NSSound(named: "Tink")?.play()
      }
    } catch is CancellationError {
      phase = .idle
    } catch {
      phase = .failed(error.localizedDescription)
      NSSound.beep()
    }
  }

  private func copyToPasteboard(_ text: String) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
  }

}
