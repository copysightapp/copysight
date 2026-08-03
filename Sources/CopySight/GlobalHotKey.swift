import Carbon.HIToolbox
import Foundation

struct ShortcutDefinition: Equatable {
  let keyCode: UInt32
  let modifiers: UInt32
  let label: String

  static let defaultValue = Self(
    keyCode: UInt32(kVK_ANSI_2),
    modifiers: UInt32(controlKey | shiftKey),
    label: "⌃⇧2"
  )

  static var current: Self {
    let defaults = UserDefaults.standard
    guard defaults.object(forKey: PreferenceKey.shortcutKeyCode) != nil else {
      return .defaultValue
    }
    return Self(
      keyCode: UInt32(defaults.integer(forKey: PreferenceKey.shortcutKeyCode)),
      modifiers: UInt32(defaults.integer(forKey: PreferenceKey.shortcutModifiers)),
      label: defaults.string(forKey: PreferenceKey.shortcutLabel) ?? defaultValue.label
    )
  }
}

extension Notification.Name {
  static let copySightShortcutChanged = Self("CopySightShortcutChanged")
}

final class GlobalHotKey {
  private var hotKey: EventHotKeyRef?
  private var eventHandler: EventHandlerRef?
  private let action: () -> Void

  convenience init?(shortcut: ShortcutDefinition, action: @escaping () -> Void) {
    self.init(keyCode: shortcut.keyCode, modifiers: shortcut.modifiers, action: action)
  }

  private init?(keyCode: UInt32, modifiers: UInt32, action: @escaping () -> Void) {
    self.action = action
    var eventType = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
    let status = InstallEventHandler(
      GetApplicationEventTarget(),
      Self.callback,
      1,
      &eventType,
      Unmanaged.passUnretained(self).toOpaque(),
      &eventHandler
    )
    guard status == noErr else { return nil }

    let identifier = EventHotKeyID(signature: 0x4350_5354, id: 1)  // CPST
    guard
      RegisterEventHotKey(keyCode, modifiers, identifier, GetApplicationEventTarget(), 0, &hotKey)
        == noErr
    else {
      if let eventHandler { RemoveEventHandler(eventHandler) }
      return nil
    }
  }

  deinit {
    if let hotKey { UnregisterEventHotKey(hotKey) }
    if let eventHandler { RemoveEventHandler(eventHandler) }
  }

  private static let callback: EventHandlerUPP = { _, _, userData in
    guard let userData else { return OSStatus(eventNotHandledErr) }
    let hotKey = Unmanaged<GlobalHotKey>.fromOpaque(userData).takeUnretainedValue()
    DispatchQueue.main.async(execute: hotKey.action)
    return noErr
  }
}
