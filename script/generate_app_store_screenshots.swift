import AppKit

guard (3...4).contains(CommandLine.arguments.count) else {
  fputs(
    "usage: generate_app_store_screenshots.swift <settings-image> <output-directory> [en|es]\n",
    stderr)
  exit(2)
}

let settingsImageURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputDirectory = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true)
let spanish = CommandLine.arguments.count == 4 && CommandLine.arguments[3] == "es"
try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

let size = NSSize(width: 1440, height: 900)
let ink = NSColor(calibratedWhite: 0.08, alpha: 1)
let paper = NSColor(calibratedRed: 0.969, green: 0.969, blue: 0.961, alpha: 1)
let accent = NSColor(calibratedRed: 1, green: 0.302, blue: 0, alpha: 1)

func text(_ value: String, size: CGFloat, weight: NSFont.Weight, color: NSColor = ink)
  -> NSAttributedString
{
  NSAttributedString(
    string: value,
    attributes: [
      .font: NSFont.systemFont(ofSize: size, weight: weight),
      .foregroundColor: color,
    ])
}

func write(_ image: NSImage, name: String) throws {
  guard
    let tiff = image.tiffRepresentation,
    let bitmap = NSBitmapImageRep(data: tiff),
    let png = bitmap.representation(using: .png, properties: [:])
  else { throw CocoaError(.fileWriteUnknown) }
  try png.write(to: outputDirectory.appendingPathComponent(name))
}

let selector = NSImage(size: size)
selector.lockFocus()
paper.setFill()
NSRect(origin: .zero, size: size).fill()
text("CopySight", size: 26, weight: .bold).draw(at: NSPoint(x: 72, y: 812))
text(spanish ? "⌃⌘2  ·  arrastra  ·  pega" : "⌃⌘2  ·  drag  ·  paste", size: 56, weight: .bold)
  .draw(at: NSPoint(x: 72, y: 690))
text(
  spanish ? "OCR local con Apple Vision." : "OCR runs locally with Apple Vision.", size: 25,
  weight: .regular, color: .darkGray)
  .draw(at: NSPoint(x: 76, y: 635))

let screen = NSRect(x: 72, y: 90, width: 1296, height: 470)
ink.setFill()
NSBezierPath(roundedRect: screen, xRadius: 14, yRadius: 14).fill()
let lines =
  spanish
  ? [
    "Las imágenes son útiles hasta que sus palabras", "dejan de estar a tu alcance.",
    "CopySight convierte esta región en texto editable.", "La imagen nunca sale de tu Mac.",
  ]
  : [
    "Images are useful until the words inside them", "become unreachable.",
    "CopySight turns this exact region into editable text.", "The image never leaves your Mac.",
  ]
for (index, line) in lines.enumerated() {
  guard index != 2 else { continue }
  text(line, size: 34, weight: .regular, color: NSColor(calibratedWhite: 0.55, alpha: 1))
    .draw(at: NSPoint(x: 165, y: index == 3 ? 160 : 440 - CGFloat(index * 78)))
}
let selection = NSRect(x: 140, y: 248, width: 1115, height: 72)
NSColor(calibratedWhite: 1, alpha: 0.04).setFill()
selection.fill()
accent.setStroke()
let border = NSBezierPath(rect: selection)
border.lineWidth = 3
border.stroke()
text(lines[2], size: 34, weight: .regular, color: .white)
.draw(at: NSPoint(x: 165, y: 262))
text("1115 × 72", size: 16, weight: .medium, color: .white)
  .draw(at: NSPoint(x: 140, y: 216))
text(
  spanish ? "Arrastra sobre el texto  •  Escape para cancelar" : "Drag over text  •  Escape to cancel",
  size: 17, weight: .medium, color: .white
).draw(at: NSPoint(x: 100, y: 500))
selector.unlockFocus()
try write(selector, name: "01-selector.png")

guard let settingsSource = NSImage(contentsOf: settingsImageURL) else {
  fputs("Unable to read settings image\n", stderr)
  exit(1)
}

let settings = NSImage(size: size)
settings.lockFocus()
paper.setFill()
NSRect(origin: .zero, size: size).fill()
text(spanish ? "Ajustes de CopySight" : "CopySight settings", size: 26, weight: .bold)
  .draw(at: NSPoint(x: 72, y: 812))
text(spanish ? "Configúralo una vez." : "Set it once.", size: 64, weight: .bold)
  .draw(at: NSPoint(x: 72, y: 655))
text(
  spanish ? "Atajo, idioma, saltos de línea," : "Shortcut, language, line breaks,", size: 27,
  weight: .regular, color: .darkGray)
  .draw(at: NSPoint(x: 76, y: 590))
text(
  spanish ? "portapapeles, sonido e inicio de sesión." : "clipboard, sound, and launch at login.",
  size: 27, weight: .regular, color: .darkGray)
  .draw(at: NSPoint(x: 76, y: 550))
text(
  spanish ? "Sin cuenta. Sin subidas. Sin analítica." : "No account. No uploads. No analytics.",
  size: 22, weight: .semibold)
  .draw(at: NSPoint(x: 76, y: 430))
let destination = NSRect(x: 790, y: 90, width: 572, height: 624)
NSColor(calibratedWhite: 0, alpha: 0.18).setFill()
NSBezierPath(roundedRect: destination.offsetBy(dx: 0, dy: -10), xRadius: 22, yRadius: 22).fill()
settingsSource.draw(in: destination)
settings.unlockFocus()
try write(settings, name: "02-settings.png")
