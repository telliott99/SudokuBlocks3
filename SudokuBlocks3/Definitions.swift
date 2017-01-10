//
//  Defs.swift
//  SudokuBlocks3
//
//  Created by Tom Elliott on 1/10/17.
//  Copyright © 2017 Tom Elliott. All rights reserved.
//

import Foundation

typealias IntSet = Set<Int>
typealias DataSet = [String:IntSet]




struct Breakpoint {
    var a: [Move]
    var D: DataSet
    init(arr: [Move] = [], dict: DataSet = DataSet() ) {
        a = arr
        D = dict
    }
}
