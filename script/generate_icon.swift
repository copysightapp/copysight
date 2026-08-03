import AppKit

guard CommandLine.arguments.count == 2 else {
  FileHandle.standardError.write(Data("usage: generate_icon.swift <output.png>\n".utf8))
  exit(2)
}

let size = 1024
guard
  let bitmap = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: size,
    pixelsHigh: size,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
  )
else { exit(1) }

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
let canvas = NSRect(x: 64, y: 64, width: 896, height: 896)
NSColor(calibratedWhite: 0.96, alpha: 1).setFill()
NSBezierPath(roundedRect: canvas, xRadius: 205, yRadius: 205).fill()

let frame = NSRect(x: 236, y: 264, width: 552, height: 496)
NSColor(calibratedRed: 1, green: 0.24, blue: 0, alpha: 1).setStroke()
let selection = NSBezierPath(rect: frame)
selection.lineWidth = 28
selection.stroke()

NSColor(calibratedWhite: 0.08, alpha: 1).setFill()
for rect in [
  NSRect(x: 316, y: 610, width: 392, height: 34),
  NSRect(x: 316, y: 490, width: 300, height: 34),
  NSRect(x: 316, y: 370, width: 350, height: 34),
] {
  NSBezierPath(roundedRect: rect, xRadius: 17, yRadius: 17).fill()
}
NSGraphicsContext.restoreGraphicsState()

guard let data = bitmap.representation(using: .png, properties: [:]) else { exit(1) }
try data.write(to: URL(fileURLWithPath: CommandLine.arguments[1]), options: .atomic)
