import Cocoa

let imgLoad = NSImage(contentsOfFile: "sudoku.png")

// it's an Optional
if imgLoad == nil { exit(0) }
let img = imgLoad!

print(img.className)
print(img.size)

// NSImage is a container for one or more image representations
print(img.representations.count)

// both as! and as? give the new type
// as? will give nil on failure, while as! just crashes
let tmp = img.representations[0] as! NSBitmapImageRep
print(tmp.className)

// various pieces of data are available, see the annotated file

/*
Mike Ash:
using the bit map obtained in this way is "not reliable"
what we do instead is to set up a bit map representation
and then draw into it
*/

// we are basically initializing storage here

let width = Int(img.size.width)
let height = Int(img.size.height)

//let w = width/2
//let h = height/2

let w = 256
let h = 256

let imgRepOptional = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: w,
    pixelsHigh: h,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: NSCalibratedRGBColorSpace,
    bytesPerRow: w * 4,
    bitsPerPixel: 32)

// another Optional

if imgRepOptional == nil { exit(0) }
let imageRep = imgRepOptional!

// ---------------------------------------

// Next we need to draw the image into the imageRep
// to do this use a graphics context

let ctx = NSGraphicsContext(bitmapImageRep: imageRep)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.setCurrent(ctx)

// operation could be .sourceOver or .copy or
let op = NSCompositingOperation.copy
let f = CGFloat(1.0)

// draw the image!
// from: NSZeroRect draws the whole source
// in: NSZeroPoint fills the same size dst as the src

// full size:
// img.draw(at: NSZeroPoint, from: NSZeroRect, operation: op, fraction: f)

// But I want to reduce the size:
let r = CGRect(x: 0, y: 0, width: CGFloat(w), height: CGFloat(h))

img.draw(in: r, from: NSZeroRect, operation: op, fraction: f)
// img.draw(in: r) is also available

ctx?.flushGraphics()
NSGraphicsContext.restoreGraphicsState()

// ---------------------------------------

// now we can use the imageRep's bitmapData
// an 'UnsafeMutablePointer<UInt8>'

// ??
// let cgi = ir.cgImage
// print(cgi!)

let data = imageRep.representation(
    using: NSBitmapImageFileType.PNG,
    properties: [:])

// must have:  "file://"
let d = "file://" + NSHomeDirectory() + "/Desktop/out.png"
let path = NSURL(string: d) as URL?

do { try data!.write(to: path!, options: .atomic) }
catch { print("Oops.  Error info: \(error)") }
