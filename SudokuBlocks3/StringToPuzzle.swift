// deal with puzzle data in the form of Strings


import Cocoa

func validatedPuzzleString(_ s: String) -> String? {
    // let ws = NSCharacterSet.whitespaceAndNewlineCharacterSet()
    // doesn't work properly for \n
    
    var a = [Character]()
    
    let whitespace = " \n".characters
    for c in s.characters {
        if whitespace.contains(c) {
            continue
        }
        a.append(c)
    }
    // Swift.print("validatedPuzzleString\n \(a)")
    
    if !(a.count == 81) {
        return nil
    }
    
    let validPuzzleChars = Set(".0123456789".characters)
    if !Set(a).isSubset(of: validPuzzleChars) {
        return nil
    }
    return String(a)
}

// returns true for success

func loadPuzzleDataFromString(_ title: String, s: String) -> Bool {
    let ns = validatedPuzzleString(s)
    if ns == nil {
        let _ = runAlert("something wrong with that one")
        Swift.print(s)
        //Swift.print(ns)
        return false
    }
    
    let dataD = convertStringToDataSet(s: s)
    if dataD == nil { return false }
    
    currentPuzzle = Puzzle(
        title: title,
        text: s,
        start: dataD!,
        dataD: dataD! )
    
    refreshScreen()
    return true
}

func constructPuzzleFromKeyAndString(key: String, string: String) -> Puzzle? {
    let dataD = convertStringToDataSet(s: string)
    if dataD == nil { return nil }
    
    return Puzzle(
        title: key, text: string,
        start: dataD!,
        dataD: dataD! )
}


