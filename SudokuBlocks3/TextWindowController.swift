import Cocoa

class TextWindowController: NSWindowController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var labelTextField: NSTextField!

    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override var windowNibName: String {
        return "TextWindowController"
    }
    
    @IBAction func loadTextAsPuzzle(sender: AnyObject) {
        let s = textField.stringValue
        // print("textField.stringValue: \(s)")
        
        let result = loadPuzzleDataFromString("", s: s)
        if result {
            labelTextField.stringValue = "?"
            
            if let w = mainWindowController.window {
                mainWindowController.requestClean(sender: self)
                mainWindowController.resetLabelTextField()
                w.orderFront(self)
                w.display()
            }
        }
    }
    
    func showCurrentState() {
        let s = currentPuzzle.stringRepresentation()  // has newlines
        // appDelegate obtained from Mutators
        appDelegate.mainWindowController!.hideHints()
        
        // needed so that textField != nil etc.
        self.window!.display()
        
        textField.stringValue = String(describing: currentPuzzle)
        labelTextField.stringValue = currentPuzzle.title
        unSelectTextField(tf: textField, controller: self)
        
        mainWindowController.resetLabelTextField()

        if let w = self.window {
            if nil != self.textField {
                self.textField.stringValue = s
            }
            w.orderFront(self)
            w.makeKey()
            w.display()
        }
    }
        
    @IBAction func writeToFile(sender: AnyObject) {
        let s = currentPuzzle.fileRepresentation()
        savePuzzleDataToFile(s: s)
        if let w = self.window {
            w.orderOut(self)
            }
    }
   
    // shows an alert on failure
    @IBAction func loadFile(sender: AnyObject) {
        if let s = loadFileHandler() {
            let f = loadPuzzleDataFromString("", s: s)
            if !f {
                _ = runAlert("Had a problem with that file!")
                return
            }
            if let w = self.window {
                w.orderOut(self)
            }
            if let w = mainWindowController.window {
                w.display()
            }
            mainWindowController.resetLabelTextField()
            mainWindowController.hideHints()
         }
    }

    @IBAction func cancel(sender: AnyObject) {
        if let w = self.window {
            w.orderOut(self)
        }
    }

}
