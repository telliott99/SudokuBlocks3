import Cocoa

// makes refresh available to Swift files

// something has changed
// this no longer works all the time

// found the right syntax to do it from MyView
// but other code can't call MyView functions!

let ad = NSApplication.shared().delegate as! AppDelegate

func refreshScreen() {
    // Swift.print("ScreenUtilities:  refreshScreen")

    if let mwc = ad.mainWindowController {
        mwc.myView.refreshScreen()
    }
}



func unSelectTextField(tf: NSTextField, controller: NSWindowController) {
    // Swift.print("unSelect \(tf) \(controller)")
    if let window = controller.window {
        let textEditor = window.fieldEditor(true, for: tf)!
        let range = NSRange(0..<0)
        textEditor.selectedRange = range
    }
}

func commandKeyWasPressed(with event: NSEvent) -> Bool {
    /*
    docs aren't particularly clear
    by examining theEvent.modifierFlags.rawValue
    
    CommandKeyMask bit is set in 1048576
    >>> bin(1048576)  # 2**20
    '0b100000000000000000000'
    
    so... just do
    1048576 & theEvent.modifierFlags.rawValue
    if its non-zero, CommandKeyMask bit is set
    
    also saw 1048584
    in Playground
    1048584 & 1048576    // 1048576
    */
    
    let n = event.modifierFlags.rawValue
    return ((n & 1048576) != 0)
}



