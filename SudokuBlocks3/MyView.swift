//
//  MyView.swift
//  SudokuBlocks3
//
//  Created by Tom Elliott on 1/7/17.
//  Copyright © 2017 Tom Elliott. All rights reserved.
//

import Cocoa

class MyView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        // super.draw(dirtyRect)
        // Swift.print("MyView:  draw")

        let backgroundColor = NSColor.white
        backgroundColor.set()
        NSBezierPath.fill(bounds)
        drawDividers()
        retrieveAndPlotData()
        displayHints()
    }
    
    func refreshScreen() {
        // Swift.print("MyView:  refreshScreen")
        self.needsDisplay = true
    }
    
    // this means we draw starting from upper left
    override var isFlipped: Bool { return true }

    // detect the clicks that affect blocks
    override func mouseDown(with event: NSEvent) {
        // immediately turn off display of hints
        setHintActive(false)
        
        let f = commandKeyWasPressed(with: event)
        
        let q = event.locationInWindow
        let p = self.convert(q, from:self.superview)
        //Swift.print("\(p)")
        
        // stupid, but reliable
        // k,v enumeration through the Dictionary
        for (key,r) in rectD {
            if r.contains(p) {
                //Swift.print("\(key)")
                respondToClick(key: key, point: p, rect: r, cmd: f)
                refreshScreen()
                return
            }
        }
    }
    
    // we do this to get key events
    override var acceptsFirstResponder: Bool { return true }
    
    // detect CMD+z, spacebar and left & right arrows
    @IBAction override func keyDown(with event: NSEvent) {
        
        super.keyDown(with: event)
        // Swift.print(event.keyCode)
        
        if event.keyCode == 6 && commandKeyWasPressed(with: event) {
            undoLastMove()
            refreshScreen()
            return
        }
        
        let n = hintList.count
        
        if event.keyCode == 49 {
            _ = calculateHintsForThisPosition()
            // Swift.print("spacebar handler, \(hintList.count) hints, active: \(hintActive)")
            
            
            if hintActive {
                // couldn't figure out yet how to save this reference
                
                let appDelegate = NSApplication.shared().delegate as! AppDelegate
                if let mwc = appDelegate.mainWindowController as MainWindowController! {
                    mwc.hideHints(sender: self)
                }
            }
            else {
                let appDelegate = NSApplication.shared().delegate as! AppDelegate
                if let mwc = appDelegate.mainWindowController as MainWindowController! {
                    mwc.showHints()
                }
            }
            
            refreshScreen()
            return
        }
        
        if n == 0 {
            Swift.print("no hintList")
            return
        }
        
        if event.keyCode == 123 {
            // Swift.print("left arrow handler")
            // left arrow
            if selectedHint == 0 {
                selectedHint = n - 1
            }
            else {
                selectedHint -= 1
            }
            refreshScreen()
            return
        }
        
        if event.keyCode == 124 {
            // Swift.print("right arrow handler")
            // right arrow
            if selectedHint == n - 1 {
                selectedHint = 0
            }
            else {
                selectedHint += 1
            }
            refreshScreen()
            return
        }
    }
    
    func talktome() {
        // Swift.print("here")
    }
}
