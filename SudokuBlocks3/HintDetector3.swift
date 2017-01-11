import Foundation

/*
 Type Three Situation
 we have a cycle like [1,2] [2,3] [3,1]
 so any other occurrence of 1, 2, or 3 deserves a hint
 */


func getTypeThreeHints() -> [Hint]? {
    // return an array of Hint objects if we find any
    var ret = [Hint]()
    let dataD = currentPuzzle.dataD
    for (group,kind) in getAllGroups() {
        
        let values : [IntSet] = group.map( { dataD[$0]! } )
        let setsWithTwo = values.filter( { $0.count == 2 } )
        if setsWithTwo.count < 3 { continue }
        
        var cycleList = [IntSet]()
        
        // better or worse than enumeration?
        for set1 in setsWithTwo {
            for set2 in setsWithTwo {
                if set1 == set2 { continue }
                for set3 in setsWithTwo {
                    if set1 == set3 { continue }
                    if set2 == set3 { continue }
                    
                    // Swift.print("Got 3:  \(set1) \(set2) \(set3)")
                    if Set(set1.union(set2).union(set3)).count != 3 {
                        continue
                    }
                    cycleList = [set1,set2,set3]
                }
            }
        }
        
        // we have one cycle (perhaps not all of them, but ignore this)
        
        // now find an affected set
        for key in group {
            let set = dataD[key]!
            
            // for each set of the array and each set in the cycle
            // if the set is not in the cycle
            // but shares at least one element, possibly two
            
            if cycleList.contains(set) { continue }
            for set2 in cycleList {
                if !set.intersection(set2).isEmpty {
                    
                    // find the keys for the sets in the cycle list
                    let k1 = currentPuzzle.keyForValue(
                        group: group, value: cycleList[0], dataD: dataD)!
                    let k2 = currentPuzzle.keyForValue(
                        group: group, value: cycleList[1], dataD: dataD)!
                    let k3 = currentPuzzle.keyForValue(
                        group: group, value: cycleList[2], dataD: dataD)!
            
                    let h = Hint(
                        key: key,
                        iSet: set,
                        keyArray: [k1,k2,k3],
                        hintType: .three,
                        affectedGroup: group.sorted(),
                        kind: kind )
                    
                    ret.append(h)
                }
            }
        }
    }
    return Array(Set(ret))
}
