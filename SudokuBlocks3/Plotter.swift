import Cocoa

let rectD = constructRectDict()
let tiny_rectL = constructTinyRects()
let divL = getBlueDividerRects()

let lw = CGFloat(6)  // line width

func drawDividers() {
    let dividerColor = NSColor.blue
    dividerColor.set()
    for r in divL {
        NSBezierPath.fill(r)
    }
}

func retrieveAndPlotData() {
    // Swift.print("retrieveAndPlotData")
    let dataD = currentPuzzle.dataD
    for key in orderedKeys {
        // any Dictionary access returns an Optional
        let r = rectD[key]!
        let data = dataD[key]!
        plotRects(data, rect: r, key: key)
    }
}

func plotRects(_ data: Set<Int>, rect: NSRect, key: String) {
    if data.count == 1 {
        let i = Array(data)[0]
        
        // adjust for 0-based indexing
        let col = cL[i-1]
        col.set()
        NSBezierPath.fill(rect)
        
        NSBezierPath.setDefaultLineWidth(2)
        outlineColor.set()
        NSBezierPath.stroke(rect)
    }
    else {
        plotTinyRects(data, rect: rect, key: key)
    }
}

func plotTinyRects(_ data: Set<Int>, rect: NSRect, key: String) {
    var a = tiny_rectL
    for n in Array(data).sorted() {
        // n is in the range 1 to 9
        let i = n - 1
        var r = a[i]
        
        r.origin.x += rect.origin.x
        r.origin.y += rect.origin.y
        let col = cL[i]
        col.set()
        NSBezierPath.fill(r)
    }
    NSBezierPath.setDefaultLineWidth(2)
    outlineColor.set()
    NSBezierPath.stroke(rect)
}


func outlineHintSquares(){
    let lineWidth = CGFloat(6)
    if hintList.count == 0 {
        return
    }
    let h = hintList[selectedHint]
    let key = h.key
    let group = h.affectedGroup
    
    // most of this is to put a dashed rect around the group
    let rectList = group.map() { rectD[$0]! }
    let xList = rectList.map() { $0.origin.x }.sorted()
    let x1 = xList.first!
    let x2 = xList.last!
    
    let yList = rectList.map() { $0.origin.y }.sorted()
    let y1 = yList.first!
    let y2 = yList.last!
    
    NSBezierPath.setDefaultLineWidth(lineWidth)
    let o = CGFloat(sizeD["sq"]!)
    let r = NSMakeRect(x1,y1,x2-x1+o,y2-y1+o)
    let p = NSBezierPath(rect: r)
    
    // this was hard to figure out!
    let dash_pattern = [CGFloat(15.0), CGFloat(9.0)]
    p.setLineDash(dash_pattern, count: dash_pattern.count, phase: 20)
    
    let col = colorForHintType(t: h.hintType)
    col.set()
    
    // now finally we show the key square
    p.stroke()
    NSBezierPath.stroke(rectD[key]!)
}


