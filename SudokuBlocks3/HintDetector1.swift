import Foundation
/*
Type One situation, we have

group:  [ {1,2}, .. {1,2}, .. {1,2,3} ]
so the last one should be {3}
 
or
group:  [ {1,2}, .. {1,2}, .. {1,3} ]
so the last one should be {3}
*/

func getTypeOneHints() -> [Hint]? {
    var ret = [Hint]()
    
    // typealias DataDict = [String:IntSet]
    let dataD = currentPuzzle.dataD
    
    // let v = dataD["A1"]
    // Swift.print("dataD[A1] \(v!) \(type(of: v!))")
    // dataD[A1] [4, 5, 6] Set<Int>
    
    // for each group in the entire puzzle
    for (group,kind) in getAllGroups() {
        
        // [KeyArray]?
        if let results = twoRepeatedDoubles(group: group) {
            
            for keyArray in results {
                let repKey = keyArray[0]
                
                // Set<Int>
                let repIntSet = dataD[repKey]!
                
                // test each square in each group
                for key in group {
                    
                    // skip the ones with repeated twos
                    if keyArray.contains(key) {
                         continue
                    }

                    // Set<Int>
                    var iSet = dataD[key]!
                    
                    // if either of repeated values is present
                    if repIntSet.intersection(iSet).count > 0 {
                    
                        //Swift.print("\(iSet) \(repIntSet)")
                        iSet.subtract(repIntSet)
                        //Swift.print("after subtract \(iSet)")
                        
                        // subtract works even if one of the values is missing
                        // [4, 9, 3] [2, 3]
                        // after subtract [4, 9]

                        // and construct the hint
                        let h = Hint(
                            key: key,
                            iSet: iSet,
                            keyArray: keyArray,
                            hintType: .one,
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


func twoRepeatedDoubles(group: [String]) -> [KeyArray]? {
    
    // [IntSet]
    let arr = currentPuzzle.getIntSetsForKeyArray(group: group)
    let twos = arr.filter( { $0.count == 2 } )
    
    // repeatsTwice will contain IntSets that occur twice
    var repeatsTwice = [IntSet]()
    
    for iSet in twos {
        if arr.elementCountGeneric(input: iSet) == 2 {
            repeatsTwice.append(iSet)
        }
    }
    
    // above logic puts both copies of the repeated set into array
    repeatsTwice = Array(Set(repeatsTwice))
    // Swift.print("repeatsTwice: \(repeatsTwice)")
    
    // now we need the corresponding keys, we return *both* keys
    var ret = [KeyArray]()
    for iSet in repeatsTwice {
        let t = group.filter( { iSet == currentPuzzle.dataD[$0] } )
        ret.append(t)
    }
    if ret.count == 0 {
        return nil
    }
    
    // [KeyArray]
    // Swift.print("returning: \(ret)")
    // returning: [["G3", "H3"], ["E3", "F3"]]
    return ret
}

