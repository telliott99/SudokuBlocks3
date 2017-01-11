import Foundation

var currentPuzzle = Puzzle(
    title: String(),
    text: String(),
    start:DataDict(),
    dataD:DataDict() )

struct Puzzle {
    let title: String
    let text: String
    let start: DataDict
    var dataD: DataDict
    var description: String {
        get {
            return self.stringRepresentation()
        }
    }
}

/*
text representation on screen
OK since space is not a valid character
(leave out spaces or extra lines when writing to disk)

874 162 395
125 379 864
396 854 172

748 291 653
261 735 489
539 486 217

687 523 941
453 9187 26
912 647 538

*/

extension Puzzle {
    func dataAsOneLineString() -> String {
        var arr = [String]()
        for key in self.dataD.keys.sorted() {
            let data = Array(dataD[key]!)
            if data.count > 1 {
                arr.append("0")
            }
            else {
                arr.append(String(data[0]))
            }
        }
        return arr.joined(separator: "")
    }
    
    func stringRepresentation() -> String {
        // could have done this by enumerating, above
        // just exercising my String extension
        let s = self.dataAsOneLineString()
        var ret = [String]()
        for (i,chunk) in s.divideStringIntoChunks(chunkSize: 3).enumerated() {
            if i != 0 {
                if (i % 3 == 0) {
                    ret.append("\n")
                }
                else {
                    ret.append(" ")
                }
            }

            if i != 0 && (i % 9 == 0) {
                ret.append("\n")
            }

            ret.append(chunk)
        }
        return ret.joined(separator: "")
    }
    
    // no extra spaces for disk storage
    func fileRepresentation() -> String {
        let s = self.dataAsOneLineString()
        var ret = [String]()
        for (i,chunk) in s.divideStringIntoChunks(chunkSize: 9).enumerated() {
            if i != 0 {
                ret.append("\n")
            }
            ret.append(chunk)
        }
        return ret.joined(separator: "")
    }
    
    func getAllIntSets() -> [IntSet] {
        var result = [IntSet]()
        for key in orderedKeys {
            let value = self.dataD[key]!
            result.append(value)
        }
        return result
    }
    
    func getIntSetsForKeyArray(group: [String]) -> [IntSet] {
        var result = [IntSet]()
        for key in group {
            let value = currentPuzzle.dataD[key]!
            result.append(value)
        }
        return result
    }

    func keyForValue(group: [String], value: IntSet, dataD: DataDict) -> String? {
        for key in group {
            if dataD[key]! == value {
                return key
            }
        }
        return nil
    }
}

extension Puzzle {
    func validate() -> [String]? {
        for group in zones + rows + cols {
            // get the data for this group as [IntSet]
            var data = group.map() { currentPuzzle.dataD[$0] }
            
            // get all the determined values
            data = data.filter() { $0!.count == 1 }
            let arr = data.map() { $0!.first! }
            
            if Set(arr).count != arr.count {
                Swift.print("Found a problem with group: \(group)")
                return group
            }
        }
        return nil
    }
}

