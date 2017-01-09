// https://www.mikeash.com/pyblog/friday-qa-2012-08-31-obtaining-and-interpreting-image-data.html

import Cocoa

let imgLoad = NSImage(contentsOfFile: "sudoku.png")

// it's an Optional
if imgLoad == nil { exit(0) }
let img = imgLoad!

print(img.className)
print(img.size)

// NSImage is a container for one or more image representations

print(img.representations.count)

// how do we know it is a NSBitmapImageRep ??
let tmp = img.representations[0] as! NSBitmapImageRep
print(tmp.className)

/*
typically each pixel is 4 bytes:  red, green, blue, alpha
other orderings are possible
also they can be stored separately:  that's called planar

above code is *not* a good way to get it b/c
we don't know what the pixel format is or how to handle cases

None of these works with this image in the playground:

imgRep.bitmapFormat
imgRep.bytesPerPlane
imgRep.bytesPerRow
imgRep.planar
imgRep.samplesPerPixel
let data = imgRep.bitmapData

but they do work with a plain Swift script:

*/

func test(_ imgRep: NSBitmapImageRep) {
    print(imgRep.bitmapFormat)
    print(imgRep.bytesPerPlane)
    print(imgRep.bytesPerRow)
    print(imgRep.isPlanar)
    print(imgRep.samplesPerPixel)
    print(imgRep.bitsPerSample)
    
    let data = imgRep.bitmapData
    print(type(of: data!))
}


//test(tmp)

/*

Mike Ash:
using the bit map obtained in this way is "not reliable"
what we do instead is to set up a bit map representation
and then draw into it

assuming this size corresponds to pixels (it may not):

*/

let w = Int(img.size.width)
let h = Int(img.size.height)

let imgRep = NSBitmapImageRep(
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

if imgRep == nil { exit(0) }
let ir = imgRep!

// ---------------------------------------

// Next we need to draw the image into the ir
// to do this use a graphics context

let ctx = NSGraphicsContext(bitmapImageRep: ir)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.setCurrent(ctx)

// old:
// let op = NSCompositingOperation.CompositeCopy

// let op = NSCompositingOperation.sourceOver
let op = NSCompositingOperation.sourceOver
let f = CGFloat(1.0)

// draw the image! not the imageRep
// NSZeroRect draws the whole thing as default

// img.draw(at: NSZeroPoint, from: NSZeroRect, operation: op, fraction: f)
// the above works

// I want to change the size:

// old:
// let r = CGRectMake(0, 0, CGFloat(w)/2, CGFloat(h)/2)
let r = CGRect(x: 0, y: 0, width: CGFloat(w)/2, height: CGFloat(h)/2)
// let r = CGRect(x: 0, y: 0, width: 64, height: 64)

img.draw(in: r, from: NSZeroRect, operation: op, fraction: f)
// img.draw(in: r) is also available

// good hygiene
ctx?.flushGraphics()
NSGraphicsContext.restoreGraphicsState()

// now we can use the imageRep's bitmapData
// an 'UnsafeMutablePointer<UInt8>'

// Mike Ash does this:

struct Pixel {
    let r,g,b,z: UInt8
}

// but I wasn't not sure how to do that

// ??
// let cgi = ir.cgImage
// print(cgi!)

// old:
// let data2 = ir.representationUsingType(
//    .NSPNGFileType,

let data = ir.representation(
    using: NSBitmapImageFileType.PNG,
    properties: [:])

// old:
// data2!.writeToFile("out.png", atomically: true)

let home = NSHomeDirectory()
// must have:  "file://"
let d = "file://" + home + "/Desktop/out.png"
let path = NSURL(string: d) as URL?
print(path!)

do { try data!.write(to: path!, options: .atomic) }
catch { print("Oops.  Error info: \(error)") }

// This almost works
// But it gives a half-size image with Dimensions:607x607 --- full size

// you can change the imageRep's dimensions, but when you write the file
// it still gives a strange result.


extension NSImage {
    func resizeImage(w width: CGFloat, h height: CGFloat) -> NSImage {
        let sz = CGSize(width: w, height: h)
        let img = NSImage(size: sz)
        img.lockFocus()
        let ctx = NSGraphicsContext.current()
        ctx?.imageInterpolation = .high
        let r1 = NSMakeRect(0, 0, width, height)
        let r2 = NSMakeRect(0, 0, size.width, size.height)
        self.draw(in: r1, from: r2, operation: .copy, fraction: 1)
        img.unlockFocus()
        return img
    }
}

let img2 = img.resizeImage(w: 64, h: 64)
print(type(of: img2))
// this returns nil
let imgRep2 = img2.representations[0] as? NSBitmapImageRep
// print(type(of: imgRep2!))

/*
 

let data2 = imgRep2.representation(
    using: NSBitmapImageFileType.PNG,
    properties: [:])

do { try data2!.write(to: path!, options: .atomic) }
catch { print("Oops.  Error info: \(error)") }
*/
