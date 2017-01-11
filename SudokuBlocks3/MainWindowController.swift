import Cocoa

class MainWindowController: NSWindowController {
    
    // We know these guys exist!
    @IBOutlet weak var popUp: NSPopUpButton!
    @IBOutlet weak var checkbox: NSButton!
    @IBOutlet weak var mainWindowLabelTextField: NSTextField!
    
    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!
    @IBOutlet weak var label4: NSTextField!
    
    @IBOutlet weak var myView: MyView!
    
    let emptyString = ""
    
    override func windowDidLoad() {
        super.windowDidLoad()
        getRandomPuzzle(sender: self)
        // showCurrentState(self)
        label1.textColor = colorForHintType(t: .one)
        label2.textColor = colorForHintType(t: .two)
        label3.textColor = colorForHintType(t: .three)
        label4.textColor = colorForHintType(t: .four)
        popUp.addItem(withTitle: "evil")
    }
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    @IBAction func requestClean(sender: AnyObject) {
        applyConstraintsForFilledSquaresOnce()
        hideHints(sender: self)
        refreshScreen()
    }
    
    
    @IBAction func requestExhaustiveClean(sender: AnyObject) {
        applyConstraintsForFilledSquaresExhaustively()
        hideHints(sender: self)
        // self.window!.display()
    }
    
    @IBAction func getRandomPuzzle(sender: AnyObject) {
        // read popUp
        //let a: [Difficulty] = [.easy, .medium, .hard, .evil]
        //let level = a[popUp.indexOfSelectedItem]
        
        //let result = getRandomDatabasePuzzle(level)
        let result = getRandomDatabasePuzzle(.easy)
        if result == nil { return }
        
        let (key, s) = result!
        let p = constructPuzzleFromKeyAndString(key: key, string:s)
        if p == nil { return }
        currentPuzzle = p!
        
        resetLabelTextField()
        
        if checkbox.state == NSOnState {
            applyConstraintsForFilledSquaresOnce()
        }
        
        hideHints()
    }
    
    
    @IBAction func undo(sender: AnyObject) {
        undoLastMove()
        myView.refreshScreen()
    }
    
    @IBAction func setNewBreakpoint(sender: AnyObject) {
        addNewBreakpoint()
    }
    
    @IBAction func returnToLastBreakpoint(sender: AnyObject) {
        restoreLastBreakpoint()
    }
    
    @IBAction func reset(sender: AnyObject) {
        if moveL.count == 0 {
            return
        }
        resetPuzzle()
        hideHints(sender: self)
    }
    
    func showHints() {
        showHints(sender: self)
    }
    
    @IBAction func showHints(sender: AnyObject) {
        setHintActive(true)
        // self.window!.display()
        myView.refreshScreen()
    }
    
    @IBAction func hideHints(sender: AnyObject) {
        setHintActive(false)    // in HintHelper, see above
        label1.stringValue = emptyString
        label2.stringValue = emptyString
        label3.stringValue = emptyString
        label4.stringValue = emptyString
        // self.window!.display()
        myView.refreshScreen()
    }
    
    // OK b/c different signature than the @IBAction
    // can't call that one from Swift files  why??
    func hideHints() {
        hideHints(sender: self)
        myView.refreshScreen()
    }
    
    @IBAction func showHelp(sender: AnyObject) {
        showHelpAsAlert()
    }
    
    @IBAction func showHintHelp(sender: AnyObject) {
        showHintHelpAsAlert()
    }
    
    @IBAction func showTextWindow(sender: AnyObject) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        
        if let textWindowController = appDelegate.textWindowController {
            textWindowController.showCurrentState()
        }
    }
    
    
    @IBAction func hideTextWindow(sender: AnyObject) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        
        // not the graceful way, should ask confirmation (see docs)
        if let textWindowController = appDelegate.textWindowController {
            textWindowController.close()
        }
    }
    
    func resetLabelTextField() {
        mainWindowLabelTextField.stringValue  = currentPuzzle.title
    }
    
    @IBAction func labelTextFieldEdited(sender: AnyObject) {
        let s = mainWindowLabelTextField.stringValue
        let result = getDatabasePuzzleForRequestedKey(requestedKey: s)
        if nil != result {
            
            let (key, s) = result!
            let p = constructPuzzleFromKeyAndString(key: key, string:s)
            if p == nil { return }
            currentPuzzle = p!
            
            resetLabelTextField()
            
            let c = String(key.characters.first!)
            if let i = ["z","m","h","e"].index(of: c) {
                
                
                popUp.selectItem(at: Int(i))
            } else {
                popUp.selectItem(at: 0)
            }
            
            if checkbox.state == NSOnState {
                applyConstraintsForFilledSquaresOnce()
            }
            hideHints()
        } else {
            _ = runAlert("No puzzle with that title!")
            resetLabelTextField()
        }
        // this doesn't work at present
        unSelectTextField(tf: mainWindowLabelTextField, controller: self)
        // focusOnPuzzleView()
    }
    
    @IBAction func checkPuzzle(sender: AnyObject) {
        if let group = currentPuzzle.validate() {
            let s = group.joined(separator: " ")
            _ = runAlert("Found a problem: \n\(s)")
        }
        else {
            _ = runAlert("No problems found!", style: .informational)
        }
    }
}
