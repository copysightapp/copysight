import AppKit
import CopySightCore
import CoreGraphics

@MainActor
final class SettingsWindowController: NSWindowController, NSWindowDelegate {
  private let defaults = UserDefaults.standard
  private let language = NSPopUpButton()
  private let launchAtLogin = NSButton(
    checkboxWithTitle: L10n.text("settings.open_at_login"), target: nil, action: nil)
  private let permissionStatus = NSTextField(labelWithString: "")

  convenience init() {
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 440, height: 480),
      styleMask: [.titled, .closable],
      backing: .buffered,
      defer: false
    )
    window.title = L10n.text("settings.title")
    window.isReleasedWhenClosed = false
    window.center()
    self.init(window: window)
    window.delegate = self
    window.contentView = makeContentView()
  }

  func windowDidBecomeKey(_ notification: Notification) {
    updateLaunchAtLoginStatus()
    updatePermissionStatus()
  }

  private func makeContentView() -> NSView {
    let content = NSView()
    let stack = NSStackView()
    stack.orientation = .vertical
    stack.alignment = .leading
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    content.addSubview(stack)

    stack.addArrangedSubview(sectionTitle(L10n.text("settings.general")))
    launchAtLogin.target = self
    launchAtLogin.action = #selector(toggleLaunchAtLogin)
    stack.addArrangedSubview(launchAtLogin)
    stack.addArrangedSubview(separator())

    stack.addArrangedSubview(sectionTitle(L10n.text("settings.recognition")))
    language.addItems(
      withTitles: RecognitionLanguage.allCases.map { L10n.text("language.\($0.rawValue)") })
    language.selectItem(at: RecognitionLanguage.allCases.firstIndex(of: currentLanguage) ?? 0)
    language.target = self
    language.action = #selector(languageChanged)
    stack.addArrangedSubview(row(label: L10n.text("settings.language"), control: language))
    stack.addArrangedSubview(
      checkbox(
        L10n.text("settings.language_correction"), key: PreferenceKey.languageCorrection,
        defaultValue: true)
    )
    stack.addArrangedSubview(
      checkbox(
        L10n.text("settings.line_breaks"), key: PreferenceKey.preserveLineBreaks,
        defaultValue: true))
    stack.addArrangedSubview(separator())

    stack.addArrangedSubview(sectionTitle(L10n.text("settings.result")))
    stack.addArrangedSubview(
      checkbox(
        L10n.text("settings.copy_automatically"), key: PreferenceKey.copyAutomatically,
        defaultValue: true))
    stack.addArrangedSubview(
      checkbox(L10n.text("settings.sound"), key: PreferenceKey.playSound, defaultValue: true))
    stack.addArrangedSubview(separator())

    stack.addArrangedSubview(sectionTitle(L10n.text("settings.shortcut")))
    let shortcut = ShortcutButton(frame: NSRect(x: 0, y: 0, width: 130, height: 28))
    shortcut.onChange = { definition in
      let defaults = UserDefaults.standard
      defaults.set(Int(definition.keyCode), forKey: PreferenceKey.shortcutKeyCode)
      defaults.set(Int(definition.modifiers), forKey: PreferenceKey.shortcutModifiers)
      defaults.set(definition.label, forKey: PreferenceKey.shortcutLabel)
      NotificationCenter.default.post(name: .copySightShortcutChanged, object: nil)
    }
    stack.addArrangedSubview(row(label: L10n.text("menu.capture_text"), control: shortcut))
    stack.addArrangedSubview(separator())

    stack.addArrangedSubview(sectionTitle(L10n.text("settings.screen_recording")))
    let permissionButton = NSButton(
      title: L10n.text("settings.open_system_settings"), target: self,
      action: #selector(openPermissionSettings))
    stack.addArrangedSubview(
      row(label: L10n.text("settings.permission"), control: permissionStatus))
    stack.addArrangedSubview(permissionButton)

    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
      stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
      stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 22),
    ])
    updateLaunchAtLoginStatus()
    updatePermissionStatus()
    return content
  }

  private var currentLanguage: RecognitionLanguage {
    RecognitionLanguage(rawValue: defaults.string(forKey: PreferenceKey.language) ?? "")
      ?? .automatic
  }

  private func sectionTitle(_ title: String) -> NSTextField {
    let label = NSTextField(labelWithString: title)
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    return label
  }

  private func row(label title: String, control: NSView) -> NSStackView {
    let label = NSTextField(labelWithString: title)
    let spacer = NSView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    let row = NSStackView(views: [label, spacer, control])
    row.orientation = .horizontal
    row.alignment = .centerY
    row.widthAnchor.constraint(equalToConstant: 392).isActive = true
    return row
  }

  private func separator() -> NSBox {
    let box = NSBox()
    box.boxType = .separator
    box.widthAnchor.constraint(equalToConstant: 392).isActive = true
    return box
  }

  private func checkbox(_ title: String, key: String, defaultValue: Bool) -> NSButton {
    let button = NSButton(checkboxWithTitle: title, target: self, action: #selector(toggleChanged))
    button.identifier = NSUserInterfaceItemIdentifier(key)
    button.state = bool(forKey: key, defaultValue: defaultValue) ? .on : .off
    return button
  }

  private func bool(forKey key: String, defaultValue: Bool) -> Bool {
    defaults.object(forKey: key) as? Bool ?? defaultValue
  }

  @objc private func languageChanged() {
    defaults.set(
      RecognitionLanguage.allCases[language.indexOfSelectedItem].rawValue,
      forKey: PreferenceKey.language)
  }

  @objc private func toggleChanged(_ sender: NSButton) {
    guard let key = sender.identifier?.rawValue else { return }
    defaults.set(sender.state == .on, forKey: key)
  }

  @objc private func toggleLaunchAtLogin(_ sender: NSButton) {
    do {
      try LaunchAtLogin.setEnabled(sender.state == .on)
    } catch {
      let alert = NSAlert(error: error)
      alert.messageText = L10n.text("settings.login_error")
      alert.runModal()
    }
    updateLaunchAtLoginStatus()
  }

  @objc private func openPermissionSettings() {
    if !CGPreflightScreenCaptureAccess() { _ = CGRequestScreenCaptureAccess() }
    if let url = URL(
      string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")
    {
      NSWorkspace.shared.open(url)
    }
    updatePermissionStatus()
  }

  private func updatePermissionStatus() {
    permissionStatus.stringValue =
      CGPreflightScreenCaptureAccess()
      ? L10n.text("settings.allowed") : L10n.text("settings.required")
    permissionStatus.textColor =
      CGPreflightScreenCaptureAccess() ? .secondaryLabelColor : .controlAccentColor
  }

  private func updateLaunchAtLoginStatus() {
    launchAtLogin.state = LaunchAtLogin.isEnabled ? .on : .off
  }
}
