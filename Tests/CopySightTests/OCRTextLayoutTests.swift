import CoreGraphics
import CoreText
import XCTest

@testable import CopySight
@testable import CopySightCore

final class OCRTextLayoutTests: XCTestCase {
  func testOrdersLinesFromTopToBottom() {
    let fragments = [
      RecognizedFragment(text: "second", bounds: CGRect(x: 0.1, y: 0.2, width: 0.4, height: 0.1)),
      RecognizedFragment(text: "first", bounds: CGRect(x: 0.1, y: 0.8, width: 0.4, height: 0.1)),
    ]

    XCTAssertEqual(OCRTextLayout.render(fragments, preserveLineBreaks: true), "first\nsecond")
  }

  func testOrdersFragmentsOnTheSameLineFromLeftToRight() {
    let fragments = [
      RecognizedFragment(text: "world", bounds: CGRect(x: 0.5, y: 0.8, width: 0.2, height: 0.1)),
      RecognizedFragment(text: "hello", bounds: CGRect(x: 0.1, y: 0.81, width: 0.2, height: 0.1)),
    ]

    XCTAssertEqual(OCRTextLayout.render(fragments, preserveLineBreaks: false), "hello world")
  }

  func testConvertsBottomLeftSelectionToTopLeftCaptureCoordinates() {
    let selection = CGRect(x: 20, y: 100, width: 300, height: 80)
    XCTAssertEqual(
      CaptureGeometry.sourceRect(for: selection, displayHeight: 900),
      CGRect(x: 20, y: 720, width: 300, height: 80)
    )
  }

  func testVisionRecognizesRenderedText() async throws {
    let image = makeTextImage("CopySight 2026")
    let options = RecognitionOptions(
      language: .english,
      preserveLineBreaks: true,
      languageCorrection: true
    )

    let result = try await TextRecognizer().recognize(image, options: options)

    XCTAssertTrue(result.contains("CopySight"), "Vision returned: \(result)")
    XCTAssertTrue(result.contains("2026"), "Vision returned: \(result)")
  }

  private func makeTextImage(_ text: String) -> CGImage {
    let width = 900
    let height = 180
    let context = CGContext(
      data: nil,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    context.setFillColor(CGColor(gray: 1, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key(kCTFontAttributeName as String): CTFontCreateWithName(
        "Helvetica" as CFString, 72, nil),
      NSAttributedString.Key(kCTForegroundColorAttributeName as String): CGColor(gray: 0, alpha: 1),
    ]
    let line = CTLineCreateWithAttributedString(
      NSAttributedString(string: text, attributes: attributes))
    context.textPosition = CGPoint(x: 30, y: 55)
    CTLineDraw(line, context)
    return context.makeImage()!
  }
}
