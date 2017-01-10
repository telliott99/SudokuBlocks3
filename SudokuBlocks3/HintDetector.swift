import Foundation

/*
typealias IntSet = Set<Int>
typealias DataSet = [String:IntSet]
*/

var a = [IntSet]()

func findRepeatedTwos(neighbors: [String]) -> [KeyArray]? {
    let arr = currentPuzzle.getIntSetsForKeyArray(group: neighbors)
    
    // filter for 2 elements
    let twos = arr.filter( { $0.count == 2 } )
    
    // repeatsTwice contains IntSets that occur twice
    var repeatsTwice = [IntSet]()
    for set in Set(twos) {
        if arr.elementCount(input: set) == 2 {
            repeatsTwice.append(set)
        }
    }
    
    var results = [KeyArray]()
    
    // now we need the corresponding keys, we return *both* keys
    for set in repeatsTwice {
        let t = neighbors.filter( { set == currentPuzzle.dataD[$0] } )
        results.append(t)
    }
    if results.count == 0 {
        return nil
    }
    return results
}

/*
Type One situation, we have

neighbors:  [ {1,2}, .. {1,2}, .. {1,2,3} ]
so the last one must be {3}
ss
or
neighbors:  [ {1,2}, .. {1,2}, .. {1,3} ]
so the last one cannot be {1}

*/

// return a set of Hint objects if we find any
func getTypeOneHints() -> [Hint]? {
    var ret = [Hint]()
    let dataD = currentPuzzle.dataD
    
    for (group,kind) in getAllGroups() {
        if let results = findRepeatedTwos(neighbors: group) {
            for keysForRepeatedTwos in results {
                let first = keysForRepeatedTwos[0]
                let repeatedIntSet = dataD[first]!
                
                // test each square in the groups
                for key in group {
                    // skip the ones with repeated twos
                    if keysForRepeatedTwos.contains(key) {
                         continue
                    }
                    // we will use set operations on the data
                    let st = Set(dataD[key]!)
                    
                    // test if both repeated values are present
                    if repeatedIntSet.isSubset(of: st) {
                        
                        // we re-use st, so make a copy
                        var iSet = st
                        iSet.subtract(repeatedIntSet)
                        
                        // and construct the hint
                        let h = Hint(
                            key: key,
                            iSet: iSet,
                            keyArray: keysForRepeatedTwos,
                            hintType: .one,
                            affectedGroup: group,
                            kind: kind )
                        
                        ret.append(h)
                    }
                    
                    // if only one of the two values is present
                    // n is an Int
                    
                    for n in repeatedIntSet {
                        if st.contains(n) {
                            let intersection = st.intersection(repeatedIntSet)
                            
                            var iSet = st
                            iSet.subtract(intersection)
                            
                            let h = Hint(
                                key: key,
                                iSet: iSet,
                                keyArray: keysForRepeatedTwos,
                                hintType: .one,
                                affectedGroup: group,
                                kind: kind)
                            
                            ret.append(h)
                         }
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

/*
Type Two situation
we have one value that is the only one of its type
for a box row or col
*/

// return a set of Hint objects if we find any
func getTypeTwoHints() -> [Hint]? {
    var ret = [Hint]()
    let dataD = currentPuzzle.dataD
    
    for (group,kind) in getAllGroups() {
        
        // gather all the values
        var arr = [Int]()
        for key in group {
            arr += Array(dataD[key]!)
        }
        
        // get the singletons
        var setsWithOne = [Int]()
        for value in [1,2,3,4,5,6,7,8,9] {
            if arr.elementCount(input: value) == 1 {
                setsWithOne.append(value)
            }
        }
        
        // find the affected keys
        for value in setsWithOne {
            for key in group {
                let data = dataD[key]!
                
                if data.count > 1 && data.contains(value) {
                    let set = Set([value])
                    
                    // this KeyArray is meaningless for .two
                    let h = Hint(
                        key: key,
                        iSet: set,
                        keyArray: [] as KeyArray,
                        hintType: .two,
                        affectedGroup: group.sorted(),
                        kind: kind)
                    
                    ret.append(h)
                }
            }
        }
    }
    return Array(Set(ret))
}


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
                    let k1 = currentPuzzle.keyForValue(group: group,
                        value: cycleList[0],
                        dataD: dataD)!
                    let k2 = currentPuzzle.keyForValue(group: group,
                        value: cycleList[1],
                        dataD: dataD)!
                    let k3 = currentPuzzle.keyForValue(group: group,
                        value: cycleList[2],
                        dataD: dataD)!
                    
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


/*
Type Four situation
we have 3 instances of 3 of a kind
*/


