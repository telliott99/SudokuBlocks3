import Cocoa

// sizes for view elements

let sizeD = getSizeDict()

func getSizeDict() -> [String:Int] {
    var D = [String:Int]()
    
    // the smallest elements are atoms
    // one side is N
    let N = 20
    D["N"] = N

    // squares are 3 x 3 atoms w/no space between
    let sq = N*3
    D["sq"] = sq

    // squares are arranged into boxes of 3 x 3
    // don't worry about pad, just stroke rects

    // boxes are arranged into 3 x 3
    let Pad = 10  // P for pad between boxes
    D["Pad"] = Pad

    // offset from origin of whole thing
    let o = 20
    D["o"] = o

    // side of a box is 3*sq
    let box = sq*3
    D["box"] = box

    // offset for a box = 180 + 10 = 190
    let O = box + Pad
    D["O"] = O
    return D
}


// accessory array that measures distance of x or y from o
func constructArrayOfSizes() -> [Int] {
    // distance of the origin of the box 
    // closest to the origin is o
    
    let o = sizeD["o"]!
    let sq = sizeD["sq"]!
    var L: [Int] = [o]         // 20
    L.append(o + sq)           // 80
    L.append(o + 2*sq)         // 140

    L.append(L[0] + 200)
    L.append(L[1] + 200)
    L.append(L[2] + 200)
    
    L.append(L[3] + 200)
    L.append(L[4] + 200)
    L.append(L[5] + 200)
    return L
}

// dictionary with x,y of origin for each square

func constructOriginDict() -> [String:(Int,Int)] {
    let L = constructArrayOfSizes()
    var D = [String:(Int,Int)]()
    
    // flipped origin of MyView
    // at upper left as expected
    for (i,l) in letters.characters.enumerated() {
        for (j,d) in digits.characters.enumerated() {
            let key = String([l,d])
            D[key] = (L[j],L[i])
        }
    }
    return D
}

// dictionary with actual NSRect for each square
func constructRectDict() -> [String:NSRect] {
    let D = constructOriginDict()
    let N = sizeD["N"]!
    var rD = [String:NSRect]()
    for l in letters.characters {
        for d in digits.characters {
            let k = String([l,d])
            let (x,y) = D[k]!
            let r = NSMakeRect(
                CGFloat(x), CGFloat(y),
                CGFloat(Double(3*N)), CGFloat(Double(3*N)) )
            rD[k] = r
        }
    }
    return rD
}

func constructTinyRects() -> [NSRect] {
    // 20 x 20
    
    var a = [NSRect]()
    a.append(NSMakeRect(0,0,20,20))
    a.append(NSMakeRect(20,0,20,20))
    a.append(NSMakeRect(40,0,20,20))
    a.append(NSMakeRect(0,20,20,20))
    a.append(NSMakeRect(20,20,20,20))
    a.append(NSMakeRect(40,20,20,20))
    a.append(NSMakeRect(0,40,20,20))
    a.append(NSMakeRect(20,40,20,20))
    a.append(NSMakeRect(40,40,20,20))
    return a
}

func indexOfTinyRectForPoint(x: CGFloat, y :CGFloat) -> Int {
    // 60 x 60 in Double, 3 x 3 in tinyRects
    var index = 0
    if x <= 20 {
        index += 0
    }
    else if x <= 40 {
        index += 1
    }
    else {
        index += 2
    }
    
    if y <= 20 {
        index += 0
    }
    else if y <= 40 {
        index += 3
    }
    else {
        index += 6
    }
    let R = 0..<9
    assert (R.contains(index))
    return index
}

func getBlueDividerRects() -> [NSRect] {
    // x = 20 + 60*3 + 7, h = 20 + 9 * 60 + 2 * Pad
    var a = [NSRect]()
    let r1 = NSMakeRect(208,20,4,580)
    a.append(r1)
    // add to x:  180 + 6 + 2*2
    let r2 = NSMakeRect(408,20,4,580)
    a.append(r2)
    
    // flip x and y, w and h
    a.append(NSMakeRect(20,208,580,4))
    a.append(NSMakeRect(20,408,580,4))
    return a
}

