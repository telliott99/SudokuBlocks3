import Foundation

/*
convenience method
count how many times
a particular IntSet is found in an array
*/

// count the number of elements of any Equatable Type
extension Array {
    func countElements<T: Equatable> (input: T) -> Int {
        var count = 0
        for el in self {
            if el as! T == input {
                count += 1
            }
        }
        return count
    }
}


extension String {
    func divideStringIntoChunks(chunkSize n: Int) -> [String] {
        var ret = [String]()
        var current = self
        while true {
            let m = current.characters.count
            if m == 0 {
                break
            }
            if m < n {
                ret.append(current)
                break
            }
            let i = current.index(current.startIndex, offsetBy: n)
            let front = current.substring(to: i)
            ret.append(front)
            current = current.substring(from: i)
        }
        return ret
    }
    
    
    func insertSeparator(sep: String, every n: Int) -> String {
        let ret = self.divideStringIntoChunks(chunkSize: n)
        return ret.joined(separator: sep)
    }
    
    func stripOccurrencesOfCharactersInList(cL: CharacterView) -> String {
        /*
        get the CharacterView, like an [Character]
        split to chunks on newlines, takes a closure

        the results are not Strings which joined requires,
        so do the conversion for each one with map
        */
        
        var a = [Character]()
        for c in self.characters {
            if cL.contains(c) {
                continue
            }
            a.append(c)
        }
        return a.map{String($0)}.joined(separator: "")
    }

}
