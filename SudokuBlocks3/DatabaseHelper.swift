import Foundation

/*
this part could definitely be fancier, like
a TableView with keys then pick
current choices are easy, medium, hard, evil
not sure where the ratings came from now, some are iffy
*/

/*
Note:  original labels were "z": easy .. "e": evil
I changed these by hand to  "e": easy .. "v": evil
*/

func loadDatabaseDictionary() -> [String:String] {
    let path = Bundle.main.path(forResource:"db", ofType: "plist")

    // pretty confident, aren't we
    let input = NSDictionary(contentsOfFile: path!)!
    // Swift.print(input)
    
    // input is [AnyObject:AnyObject]
    var D = [String:String]()
    for key in input.allKeys {
        let k = key as! String
        let v = input.object(forKey: k) as! String
        D[k] = v
    }
    // Swift.print("\(D.dynamicType)")
    return D
}

let databaseD = loadDatabaseDictionary()

func getRandomDatabasePuzzle(_ level: Difficulty) -> (String, String)? {
    
    let D = databaseD
    
    // needed because D.keys is a special kind of Collection
    var kL = Array(D.keys)
    
    // filter kL based on Difficulty
    switch level {
    case .easy:
        kL = kL.filter() { $0.characters.first! == "e" }
    case .medium:
        kL = kL.filter() { $0.characters.first! == "m" }
    case .hard:
        kL = kL.filter() { $0.characters.first! == "h" }
    case .evil:
        kL = kL.filter() { $0.characters.first! == "v" }
    }
    
    let i = Int(arc4random_uniform(UInt32(kL.count)))
    let k = kL[i]
    return (k, D[k]!)
}

func getDatabasePuzzleForRequestedKey(requestedKey: String) -> (String,String)? {
    if databaseD.keys.contains(requestedKey) {
        let k = requestedKey
        return (k,databaseD[k]!)
    }
    return nil
}
