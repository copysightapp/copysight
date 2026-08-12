import AppKit

struct ScreenSelection {
  let screen: NSScreen
  let rect: CGRect
}

@MainActor
final class SelectionOverlayController {
  private var panels: [NSPanel] = []
  private var completion: ((ScreenSelection?) -> Void)?

  func present(completion: @escaping (ScreenSelection?) -> Void) {
    dismiss(result: nil, notify: false)
    self.completion = completion

    panels = NSScreen.screens.map { screen in
      let panel = SelectionPanel(
        contentRect: screen.frame,
        styleMask: .borderless,
        backing: .buffered,
        defer: false,
        screen: screen
      )
      panel.level = .screenSaver
      panel.backgroundColor = .clear
      panel.isOpaque = false
      panel.hasShadow = false
      panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
      panel.contentView = SelectionView(
        frame: CGRect(origin: .zero, size: screen.frame.size),
        select: { [weak self] rect in
          self?.dismiss(result: ScreenSelection(screen: screen, rect: rect))
        },
        cancel: { [weak self] in self?.dismiss(result: nil) }
      )
      panel.makeKeyAndOrderFront(nil)
      return panel
    }

    NSApp.activate(ignoringOtherApps: true)
    panels.first?.makeKey()
  }

  private func dismiss(result: ScreenSelection?, notify: Bool = true) {
    for panel in panels {
      panel.close()
    }
    panels.removeAll(keepingCapacity: false)
    guard notify else { return }
    let callback = completion
    completion = nil
    callback?(result)
  }
}

private final class SelectionPanel: NSPanel {
  override var canBecomeKey: Bool { true }
}

private final class SelectionView: NSView {
  private let select: (CGRect) -> Void
  private let cancel: () -> Void
  private var startPoint: CGPoint?
  private var selectionRect = CGRect.zero

  init(frame: CGRect, select: @escaping (CGRect) -> Void, cancel: @escaping () -> Void) {
    self.select = select
    self.cancel = cancel
    super.init(frame: frame)
    wantsLayer = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  override var acceptsFirstResponder: Bool { true }

  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    window?.makeFirstResponder(self)
  }

  override func resetCursorRects() {
    addCursorRect(bounds, cursor: .crosshair)
  }

  override func mouseDown(with event: NSEvent) {
    startPoint = convert(event.locationInWindow, from: nil)
    selectionRect = .zero
    needsDisplay = true
  }

  override func mouseDragged(with event: NSEvent) {
    guard let startPoint else { return }
    selectionRect = Self.rect(from: startPoint, to: convert(event.locationInWindow, from: nil))
      .intersection(bounds)
    needsDisplay = true
  }

  override func mouseUp(with event: NSEvent) {
    guard let startPoint else { return }
    selectionRect = Self.rect(from: startPoint, to: convert(event.locationInWindow, from: nil))
      .intersection(bounds)
    self.startPoint = nil
    selectionRect.width >= 8 && selectionRect.height >= 8 ? select(selectionRect) : cancel()
  }

  override func rightMouseDown(with event: NSEvent) {
    cancel()
  }

  override func keyDown(with event: NSEvent) {
    event.keyCode == 53 ? cancel() : super.keyDown(with: event)
  }

  override func draw(_ dirtyRect: NSRect) {
    NSColor.black.withAlphaComponent(0.28).setFill()
    bounds.fill()

    guard !selectionRect.isEmpty else {
      drawInstruction()
      return
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current?.compositingOperation = .copy
    NSColor.clear.setFill()
    NSBezierPath(rect: selectionRect).fill()
    NSGraphicsContext.restoreGraphicsState()
    let border = NSBezierPath(rect: selectionRect.insetBy(dx: 0.5, dy: 0.5))
    border.lineWidth = 1
    NSColor.controlAccentColor.setStroke()
    border.stroke()
    drawDimensions()
  }

  private func drawInstruction() {
    let text = L10n.text("overlay.instruction") as NSString
    let attributes: [NSAttributedString.Key: Any] = [
      .font: NSFont.systemFont(ofSize: 13, weight: .medium),
      .foregroundColor: NSColor.white,
      .backgroundColor: NSColor.black.withAlphaComponent(0.72),
    ]
    let size = text.size(withAttributes: attributes)
    text.draw(at: CGPoint(x: 18, y: bounds.maxY - size.height - 18), withAttributes: attributes)
  }

  private func drawDimensions() {
    let text = "\(Int(selectionRect.width)) × \(Int(selectionRect.height))" as NSString
    let attributes: [NSAttributedString.Key: Any] = [
      .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .medium),
      .foregroundColor: NSColor.white,
      .backgroundColor: NSColor.black.withAlphaComponent(0.72),
    ]
    let size = text.size(withAttributes: attributes)
    let y = max(8, selectionRect.minY - size.height - 6)
    text.draw(at: CGPoint(x: selectionRect.minX, y: y), withAttributes: attributes)
  }

  private static func rect(from start: CGPoint, to end: CGPoint) -> CGRect {
    CGRect(
      x: min(start.x, end.x), y: min(start.y, end.y), width: abs(end.x - start.x),
      height: abs(end.y - start.y))
  }
}
