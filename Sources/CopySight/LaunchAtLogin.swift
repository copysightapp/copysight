import ServiceManagement

enum LaunchAtLogin {
  static var isEnabled: Bool {
    switch SMAppService.mainApp.status {
    case .enabled, .requiresApproval: true
    default: false
    }
  }

  static func setEnabled(_ enabled: Bool) throws {
    if enabled {
      guard !isEnabled else { return }
      try SMAppService.mainApp.register()
    } else {
      guard isEnabled else { return }
      try SMAppService.mainApp.unregister()
    }
  }
}
