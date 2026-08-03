import AppKit
import CoreGraphics
import ScreenCaptureKit

enum CaptureError: LocalizedError {
  case displayUnavailable
  case invalidSelection

  var errorDescription: String? {
    switch self {
    case .displayUnavailable: "The selected display is no longer available."
    case .invalidSelection: "The selected area is too small to capture."
    }
  }
}

struct CaptureGeometry {
  static func sourceRect(for selection: CGRect, displayHeight: CGFloat) -> CGRect {
    CGRect(
      x: selection.minX,
      y: displayHeight - selection.maxY,
      width: selection.width,
      height: selection.height
    )
  }
}

@MainActor
final class ScreenCaptureService {
  func capture(_ selection: ScreenSelection) async throws -> CGImage {
    guard selection.rect.width >= 1, selection.rect.height >= 1 else {
      throw CaptureError.invalidSelection
    }
    let content = try await SCShareableContent.excludingDesktopWindows(
      false, onScreenWindowsOnly: true)
    guard let displayID = selection.screen.displayID,
      let display = content.displays.first(where: { $0.displayID == displayID })
    else {
      throw CaptureError.displayUnavailable
    }

    let filter: SCContentFilter
    if let ownApp = content.applications.first(where: {
      $0.processID == ProcessInfo.processInfo.processIdentifier
    }) {
      filter = SCContentFilter(
        display: display, excludingApplications: [ownApp], exceptingWindows: [])
    } else {
      filter = SCContentFilter(display: display, excludingWindows: [])
    }

    let configuration = SCStreamConfiguration()
    configuration.sourceRect = CaptureGeometry.sourceRect(
      for: selection.rect, displayHeight: selection.screen.frame.height)
    let horizontalScale = CGFloat(display.width) / selection.screen.frame.width
    let verticalScale = CGFloat(display.height) / selection.screen.frame.height
    configuration.width = max(1, Int((selection.rect.width * horizontalScale).rounded(.up)))
    configuration.height = max(1, Int((selection.rect.height * verticalScale).rounded(.up)))
    configuration.showsCursor = false
    configuration.scalesToFit = true

    return try await SCScreenshotManager.captureImage(
      contentFilter: filter, configuration: configuration)
  }
}

extension NSScreen {
  fileprivate var displayID: CGDirectDisplayID? {
    (deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value
  }
}
