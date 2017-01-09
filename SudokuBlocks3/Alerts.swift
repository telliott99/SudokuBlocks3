import Cocoa

/*
enum NSAlertStyle : UInt {
case .warning
case .informational
case .critical
}
*/

func runAlert(_ s: String, style: NSAlertStyle = .warning) -> Bool {
    let a: NSAlert = NSAlert()
    // Swift.print(a.window.frame.origin)
    
    a.messageText = s
    //a.informativeText = text
    
    a.alertStyle = style
    a.addButton(withTitle: "OK")
    //a.addButtonWithTitle("Cancel")
    
    let result = a.runModal()
    if result == NSAlertFirstButtonReturn {
        return true
    }
    return false
}

func showHelpAsAlert() {
    let sL = [
        "Click to delete a single value",
        "Command-click to select one value",
        "Command-z to go back one",
        "(a single move or a constraint cycle)\n",
        "Note: applying constraints may uncover",
        "a problem with a previous move" ]
    
    let s = sL.joined(separator: "\n")
    _ = runAlert(s, style: .informational)
}

func showHintHelpAsAlert() {
    let sL = [
        "Press spacebar to show/hide hints",
        "Hint types are color-coded\n",
        "Arrows cycle through hints",
        "Hints based on analysis of a group",
        "\t(rows, cols or boxes)\n",
        "Types:",
        "1:  repeated twos [1,2] .. [1,2]",
        "2:  unique value for group",
        "3:  a cycle [1,2] .. [2,3] .. [3,1]" ]
        
    let s = sL.joined(separator: "\n")
    _ = runAlert(s, style: .informational)
}


