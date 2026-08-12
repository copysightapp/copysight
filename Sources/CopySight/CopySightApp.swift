import AppKit

@main
enum CopySightMain {
  static func main() {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
    _ = delegate
  }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
  let model = AppModel()
  private var statusBarItem: NSStatusItem!
  private var hotKey: GlobalHotKey?
  private var shortcutObserver: NSObjectProtocol?
  private var settingsController: SettingsWindowController?
  private let phaseItem = NSMenuItem()
  private let shortcutItem = NSMenuItem()
  private let previousItem = NSMenuItem(
    title: L10n.text("menu.capture_previous"), action: #selector(capturePrevious), keyEquivalent: ""
  )
  private let copyItem = NSMenuItem(
    title: L10n.text("menu.copy_last"), action: #selector(copyLast), keyEquivalent: "")

  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    configureStatusBar()
    installHotKey()
    model.onChange = { [weak self] in self?.refreshMenu() }
    shortcutObserver = NotificationCenter.default.addObserver(
      forName: .copySightShortcutChanged,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor in
        self?.installHotKey()
        self?.refreshMenu()
      }
    }
  }

  func applicationWillTerminate(_ notification: Notification) {
    if let shortcutObserver {
      NotificationCenter.default.removeObserver(shortcutObserver)
    }
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
  {
    showSettings()
    return true
  }

  func menuWillOpen(_ menu: NSMenu) {
    refreshMenu()
  }

  private func configureStatusBar() {
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    statusBarItem.button?.image = NSImage(
      systemSymbolName: "text.viewfinder", accessibilityDescription: "CopySight")
    statusBarItem.button?.toolTip = "CopySight"

    let menu = NSMenu()
    menu.delegate = self
    menu.addItem(menuItem(L10n.text("menu.capture_text"), action: #selector(capture)))
    menu.addItem(previousItem)
    menu.addItem(.separator())
    phaseItem.isEnabled = false
    shortcutItem.isEnabled = false
    menu.addItem(phaseItem)
    menu.addItem(shortcutItem)
    menu.addItem(.separator())
    menu.addItem(copyItem)
    menu.addItem(.separator())
    menu.addItem(
      menuItem(L10n.text("menu.settings"), action: #selector(showSettings), keyEquivalent: ","))
    menu.addItem(menuItem(L10n.text("menu.quit"), action: #selector(quit), keyEquivalent: "q"))
    statusBarItem.menu = menu
    refreshMenu()
  }

  private func menuItem(_ title: String, action: Selector, keyEquivalent: String = "") -> NSMenuItem
  {
    let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
    item.target = self
    return item
  }

  private func refreshMenu() {
    phaseItem.title = model.phase.message
    shortcutItem.title = L10n.text("menu.shortcut", ShortcutDefinition.current.label)
    previousItem.isEnabled = model.hasPreviousSelection && !model.phase.isBusy
    copyItem.isEnabled = !model.lastText.isEmpty
    statusBarItem?.button?.toolTip = "CopySight — \(model.phase.message)"
  }

  private func installHotKey() {
    hotKey = nil
    hotKey = GlobalHotKey(shortcut: .current) { [weak model] in model?.captureText() }
    if hotKey == nil { model.reportHotKeyUnavailable() }
  }

  @objc private func capture() { model.captureText() }
  @objc private func capturePrevious() { model.capturePreviousSelection() }
  @objc private func copyLast() { model.copyLastText() }

  @objc private func showSettings() {
    if settingsController == nil {
      settingsController = SettingsWindowController { [weak self] in
        self?.settingsController = nil
      }
    }
    settingsController?.showWindow(nil)
    NSApp.activate(ignoringOtherApps: true)
    settingsController?.window?.makeKeyAndOrderFront(nil)
  }

  @objc private func quit() { NSApp.terminate(nil) }
}
