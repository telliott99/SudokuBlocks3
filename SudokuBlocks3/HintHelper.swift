import Cocoa

var hintActive = false
var selectedHint = 0
var hintList = [Hint]()

func calculateHintsForThisPosition() -> Bool {
    if let hints = getTypeOneHints() {
        hintList += hints
    }
    if let hints = getTypeTwoHints() {
        hintList += hints
    }
    if let hints = getTypeThreeHints() {
        hintList += hints
    }
    if let hints = getTypeFourHints() {
        hintList += hints
    }
    if hintList.count == 0 {
        _ = runAlert("no hints right now")
        setHintActive(false)
        return false
    }
    
    hintList = removeDuplicateHints(hintList: hintList)
    
    hintList = hintList.sorted( by: { $0 < $1 } )
    return hintList.count > 0
}

func setHintActive(_ flag: Bool) {
    hintActive = flag
    selectedHint = 0
    if !flag {
        hintList = [Hint]()
    }
    else {
        _ = calculateHintsForThisPosition()
    }
}

func getHintCount() -> (Int,Int,Int,Int) {
    var m = 0
    var n = 0
    var o = 0
    var p = 0
    
    for hint in hintList {
        switch  hint.hintType {
        case .one:   m += 1
        case .two:   n += 1
        case .three: o += 1
        case .four:  p += 1
        }
    }
    // Swift.print("hints: \(m) \(n) \(o) \(p)")
    return (m,n,o,p)
}

func removeDuplicateHints(hintList: [Hint]) -> [Hint] {
    var a = Set<String>()
    var ret = [Hint]()
    // try to save type 3's
    for h in hintList.reversed() {
        let key = h.key
        if a.contains(key) {
            continue
        }
        a.insert(key)
        ret.append(h)
    }
    return ret
}

func displayHints() {
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    let wc = appDelegate.mainWindowController
    
    if hintActive {
        outlineHintSquares()
        let (c1,c2,c3,c4) = getHintCount()
        
        if wc != nil {
            wc!.label1.stringValue = String(c1)
            wc!.label2.stringValue = String(c2)
            wc!.label3.stringValue = String(c3)
            wc!.label4.stringValue = String(c4)
       }
    }
        
    else {
        if wc != nil {
            wc!.label1.stringValue = String("")
            wc!.label2.stringValue = String("")
            wc!.label3.stringValue = String("")
            wc!.label4.stringValue = String("")
        }
    }
}


