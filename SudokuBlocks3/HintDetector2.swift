import Foundation

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
            if arr.elementCountGeneric(input: value) == 1 {
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
