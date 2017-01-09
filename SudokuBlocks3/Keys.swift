import Foundation

let letters = "ABCDEFGHI"
// let letterArray = Array(arrayLiteral: letters)

let digits =  "123456789"
// let digitArray = Array(arrayLiteral: digits)

// actually, .sort() gives the 
// correct sorted order A1 A2..B1 B2 ..

let orderedKeys = getOrderedKeys()

func getOrderedKeys() -> [String] {
    var kL = [String]()
    for l in letters.characters {
        for d in digits.characters {
            kL.append(String([l,d]))
        }
    }
    return kL
}
