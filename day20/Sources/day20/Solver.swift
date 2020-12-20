//
//  Solver.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

struct Solver {
    private var puzzle: [[Tile?]]
    private var sorter: TileSorter

    init(sorter: TileSorter, size: Int) {
        puzzle = Array(repeating: Array(repeating: nil, count: size), count: size)
        self.sorter = sorter
    }

    mutating func fillTopEdge() {
        let cornerIdx = puzzle.count - 1
        for i in 1..<cornerIdx {
            puzzle[0][i] = sorter.findMatch(.edge, matching: puzzle[0][i - 1]!)
        }

        if puzzle[0][cornerIdx] == nil {
            puzzle[0][cornerIdx] = sorter.findMatch(.corner, matching: puzzle[0][cornerIdx - 1]!)
        }
    }

    mutating func fillRow(_ rowIdx: Int) {
        for i in rowIdx..<(puzzle.count - 1 - rowIdx) {
            guard let match = sorter.findMatch(.regular, matching: puzzle[rowIdx - 1][i]!) else { fatalError() }
            sorter.removeCommonEdge(match, puzzle[rowIdx][i - 1]!)
            puzzle[rowIdx][i] = match
        }
    }

    mutating func placeTiles() {
        puzzle[0][0] = sorter.cornerTiles.first
        
        for _ in 0..<4 {
            fillTopEdge()
            puzzle.rotateLeft()
        }

        for i in 1...((puzzle.count - 2) / 2) {
            for _ in 0..<4 {
                fillRow(i)
                puzzle.rotateLeft()
            }
        }
    }

    func printPuzzle() {
        for row in puzzle {
            let values: [String] = row.map {
                if let id = $0?.id {
                    return "\(id)"
                } else {
                    return "----"
                }
            }
            print(values)
        }
    }
}
