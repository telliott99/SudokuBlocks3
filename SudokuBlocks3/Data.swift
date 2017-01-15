/*
A Sudoku board is represented as
a Dictionary of String:Set<Int>
e.g. D["A1"] = {1,2,3}
dataD

The advantage of using a set to hold the data:
s.remove(1) is only for sets
s.contains(1) is for both arrays and sets

set init syntax:
s = Set(1..<10) or 
s = Set([1,2,3])

When necessary to convert to sorted array:
a = Array(s).sort()
*/

func constructZeroedDataDict() -> DataDict {
    // mostly, we will count starting from 1
    // the cells are [1,2,3,4,5,6,7,8,9] == 1..<10
    
    var D = DataDict()
    for key in orderedKeys {
        D[key] = Set(1..<10)
    }
    return D
}

func convertStringToDataSet(s: String) -> DataDict? {
    
    // we must remove spaces (in showing data, we put them there!)
    // newlines too
    
    let s2 = s.stripOccurrencesOfCharactersInList(cL: " \n".characters)
    let sc = s2.characters
    let start = sc.startIndex
    
    var dataD = constructZeroedDataDict()

    // want to enumerate but we need an "Index", it's awkward
    
    for (i,key) in orderedKeys.enumerated() {
        // data from the input string
        
        let idx = sc.index(start, offsetBy: i)
        let v = sc[idx]
        // let v = sc[index.advancedBy(i)]
        
        // we accept "." or "0"
        // the Set<Int> is already good in this case
        
        if ".0".characters.contains(v) { continue }
        
        // attempt conversion to Int
        let m = Int(String(v))
        assert (m != nil,
            "int conversion for \(v) at index \(i) failed.")
        
        let n = m!
        
        // check for the proper range
        let R = 1..<10
        guard ( R.contains(n) ) else {
            Swift.print("invalid digit in new puzzle:  \(v)")
            return nil
        }
        // data storage for this cell of the puzzle
        dataD[key] = Set([n])
    }
    
    return dataD
}
