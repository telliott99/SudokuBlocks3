import Foundation

/*
 Type Four situation
 we have 3 instances of 3 of a kind
 */

func getTypeFourHints() -> [Hint]? {
    var ret = [Hint]()
    
    // typealias DataDict = [String:IntSet]
    let dataD = currentPuzzle.dataD
    
    for (group,kind) in getAllGroups() {
        
        // [KeyArray]?
        if let results = threeRepeatedTriples(group: group) {
            
            for keyArray in results {
                let repKey = keyArray[0]
                
                let repIntSet = dataD[repKey]!
                
                // test each square in each group
                for key in group {
                    
                    // skip the ones that are repeated threes
                    if keyArray.contains(key) {
                        continue
                    }

                    // Set<Int>
                    var iSet = dataD[key]!
                    
                    // test if any of repeated values is present
                    if repIntSet.intersection(iSet).count > 0 {
                        
                        iSet.subtract(repIntSet)
                        // subtract works even if one of the values is missing
                        
                        // and construct the hint
                        let h = Hint(
                            key: key,
                            iSet: iSet,
                            keyArray: keyArray,
                            hintType: .four,
                            affectedGroup: group,
                            kind: kind )
                        
                        ret.append(h)
                    }
                }
            }
        }
    }
    if ret.count == 0 {
        return nil
    }
    return Array(Set(ret))
}

func threeRepeatedTriples(group: [String]) -> [KeyArray]? {
    
    // [IntSet]
    let arr = currentPuzzle.getIntSetsForKeyArray(group: group)
    
    // filter for 3 elements
    let threes = arr.filter( { $0.count == 3 } )
    
    // repeatsThrice contains IntSets that occur 3x
    var repeatsThrice = [IntSet]()
    
    for iSet in threes {
        if arr.elementCountGeneric(input: iSet) == 3 {
            repeatsThrice.append(iSet)
        }
    }
    
    // above logic puts 3 copies of the repeated set into array
    repeatsThrice = Array(Set(repeatsThrice))
    
    // now we need the corresponding keys, we return *both* keys
    var ret = [KeyArray]()
    for iSet in repeatsThrice {
        let t = group.filter( { iSet == currentPuzzle.dataD[$0] } )
        ret.append(t)
    }
    if ret.count == 0 {
        return nil
    }

    // [KeyArray]
    // Swift.print("returning: \(ret)")
    // returning: [["G2", "G3", "I3"]]
    return ret
}


