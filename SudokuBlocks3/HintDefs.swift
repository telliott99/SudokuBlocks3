import Cocoa

func == (lhs: Hint, rhs: Hint) -> Bool {
    if lhs.key != rhs.key { return false }
    if lhs.iSet != rhs.iSet { return false }
    return true
}

func < (lhs: Hint, rhs: Hint) -> Bool {
    if lhs.hintType != rhs.hintType {
        if lhs.hintType == .one {
            return true
        }
        else {
            if lhs.hintType == .two {
                if rhs.hintType == .one {
                    return false
                }
                else {
                    return true
                }
            }
            return false
        }
    }
    let oka = orderedKeys
    // rewrite to be safer
    return oka.index(of: lhs.key)! < oka.index(of: rhs.key)!
}

typealias KeyArray = [String]

struct Hint: CustomStringConvertible, Hashable, Equatable {
    let key: String
    let iSet: IntSet
    let keyArray: [String]
    let hintType: HintType
    let affectedGroup: [String]
    let kind: GroupType
    
    var description: String {
        get {
            let sortedISet = Array(iSet).sorted()
            // return "\(kp):\n\(k) = \(sortedISet)"
            return "\(key) -> \(sortedISet), type \(self.hintType)"
        }
    }
    
    // forgotten why I needed this
    var hashValue: Int {
        get {
            let ka = orderedKeys
            var n = ka.index(of: key)! * 10
            switch hintType {
            case .one:  n = 1
            case .two:  n += 2
            case .three:  n += 3
            }
            return n
       }
    }
}
