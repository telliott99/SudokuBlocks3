import Cocoa

 /*
 These appear to be broken
 something about "Logged out - iCloud Drive is not configured"
 */

func loadFileHandler() -> String? {
    let op = NSOpenPanel()
    
    op.prompt = "Open File:"
    // op.title = "A title"
    // op.message = "A message"
    // op.canChooseFiles = true  // default
    // op.worksWhenModal = true  // default
    
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = true  // default
    op.resolvesAliases = true
    op.allowedFileTypes = ["txt"]

    let home = NSHomeDirectory()
    let d = home + "/Desktop/"
    op.directoryURL = NSURL(string: d) as URL?
    op.runModal()
    // op.orderOut()
    
    // op.URL contains the user's choice
    if op.url == nil {
        return nil
    }
    var s: String
    do {
        s = try String(contentsOf: op.url!, encoding: String.Encoding.utf8)
    }
    catch {
        // this doesn't work, alert disappears with return..
        // runAlert("Unable to load a puzzle from that file!")
        return nil
    }
    let vs = validatedPuzzleString(s)
    return vs
}

func savePuzzleDataToFile(s: String) {
    let sp = NSSavePanel()
    
    sp.prompt = "Save File:"
    sp.title = "A title"
    sp.message = "A message"
    // sp.worksWhenModal = true  // default
    
    let home = NSHomeDirectory()
    let d = home + "/Desktop/"
    sp.directoryURL = NSURL(string: d) as URL?
    sp.allowedFileTypes = ["txt"]

    //sp.runModal()
    
    sp.begin(completionHandler: { (result: Int) -> Void in
        // Swift.print(result)
        if result == NSFileHandlingPanelOKButton {
            let exportedFileURL = sp.url!
            do { try s.write(to: exportedFileURL, atomically:true,
                encoding:String.Encoding.utf8) }
            catch { _ = runAlert("Unable to save!") }
        }
    } )
}
