import AppKit
import Carbon.HIToolbox

final class ShortcutButton: NSButton {
  var onChange: ((ShortcutDefinition) -> Void)?
  var shortcut = ShortcutDefinition.current { didSet { updateTitle() } }
  private var isRecording = false

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    bezelStyle = .rounded
    target = self
    action = #selector(beginRecording)
    updateTitle()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  override var acceptsFirstResponder: Bool { true }

  @objc private func beginRecording() {
    isRecording = true
    title = L10n.text("shortcut.record")
    window?.makeFirstResponder(self)
  }

  override func resignFirstResponder() -> Bool {
    isRecording = false
    updateTitle()
    return super.resignFirstResponder()
  }

  override func keyDown(with event: NSEvent) {
    guard isRecording else {
      super.keyDown(with: event)
      return
    }
    if event.keyCode == UInt16(kVK_Escape) {
      window?.makeFirstResponder(nil)
      return
    }

    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    guard
      flags.contains(.command) || flags.contains(.control) || flags.contains(.option)
        || flags.contains(.shift),
      let key = Self.keyLabel(for: event), !key.isEmpty
    else {
      NSSound.beep()
      return
    }

    let value = ShortcutDefinition(
      keyCode: UInt32(event.keyCode),
      modifiers: Self.carbonModifiers(from: flags),
      label: Self.modifierLabel(for: flags) + key
    )
    shortcut = value
    onChange?(value)
    window?.makeFirstResponder(nil)
  }

  private func updateTitle() {
    title = shortcut.label
  }

  private static func carbonModifiers(from flags: NSEvent.ModifierFlags) -> UInt32 {
    var result: UInt32 = 0
    if flags.contains(.control) { result |= UInt32(controlKey) }
    if flags.contains(.option) { result |= UInt32(optionKey) }
    if flags.contains(.shift) { result |= UInt32(shiftKey) }
    if flags.contains(.command) { result |= UInt32(cmdKey) }
    return result
  }

  private static func modifierLabel(for flags: NSEvent.ModifierFlags) -> String {
    (flags.contains(.control) ? "⌃" : "")
      + (flags.contains(.option) ? "⌥" : "")
      + (flags.contains(.shift) ? "⇧" : "")
      + (flags.contains(.command) ? "⌘" : "")
  }

  private static func keyLabel(for event: NSEvent) -> String? {
    switch Int(event.keyCode) {
    case kVK_Return: return "↩"
    case kVK_Tab: return "⇥"
    case kVK_Space: return L10n.text("shortcut.space")
    case kVK_Delete: return "⌫"
    case kVK_LeftArrow: return "←"
    case kVK_RightArrow: return "→"
    case kVK_UpArrow: return "↑"
    case kVK_DownArrow: return "↓"
    default: return event.charactersIgnoringModifiers?.uppercased()
    }
  }
}
