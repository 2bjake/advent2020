//
//  Solver.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

struct Solver {
    var puzzle: [[Tile]]
    private var tiles: TileManager

    init(tiles: TileManager, size: Int) {
        puzzle = Array(repeating: Array(repeating: .placeholder, count: size), count: size)
        self.tiles = tiles
    }

    mutating func fillTopEdge() {
        let cornerIdx = puzzle.count - 1
        for i in 1..<cornerIdx {
            puzzle[0][i] = tiles.findMatch(.edge, matching: puzzle[0][i - 1])!
        }

        if puzzle[0][cornerIdx] == .placeholder {
            puzzle[0][cornerIdx] = tiles.findMatch(.corner, matching: puzzle[0][cornerIdx - 1])!
        }
    }

    mutating func fillRow(_ rowIdx: Int) {
        for i in rowIdx..<(puzzle.count - 1 - rowIdx) {
            guard let match = tiles.findMatch(.regular, matching: puzzle[rowIdx - 1][i]) else { fatalError() }
            tiles.removeCommonEdge(match, puzzle[rowIdx][i - 1])
            puzzle[rowIdx][i] = match
        }
    }

    mutating func placeTiles() {

        guard let corner = tiles.cornerTiles.min(by: { $0.id < $1.id }) else { fatalError("no corner tiles found") }
        puzzle[0][0] = corner


        // fill outside edges
        for _ in 0..<4 {
            fillTopEdge()
            puzzle.rotateLeft()
        }

        // fill inner rings
        var innerRingCount = (puzzle.count - 2) / 2
        if puzzle.count == 3 { // TODO: remove
            innerRingCount += 1
        }
        for i in 1...innerRingCount {
            for _ in 0..<4 {
                fillRow(i)
                puzzle.rotateLeft()
            }
        }

        if puzzle.count == 3 { // TODO: remove
            puzzle[1][1] = tiles.findMatch(.regular, matching: puzzle[0][1])!
        }
    }

    mutating func fixTopEdgeOrientation() {
        let cornerIdx = puzzle.count - 1
        for i in 1..<cornerIdx {
            let edge = tiles.findOutsideEdges(of: puzzle[0][i]).first!
            puzzle[0][i].orientWith(top: edge, left: puzzle[0][i - 1].rightEdge)
        }

        puzzle[0][cornerIdx].rotateEdge(puzzle[0][cornerIdx - 1].rightEdge, to: .left)
        if !tiles.findOutsideEdges(of: puzzle[0][cornerIdx]).contains(puzzle[0][cornerIdx].topEdge) {
            puzzle[0][cornerIdx].flipHorizontally()
        }
    }

    mutating func fixLeftEdgeOrientation() {
        let cornerIdx = puzzle.count - 1
        for i in 1..<cornerIdx {
            let edge = tiles.findOutsideEdges(of: puzzle[i][0]).first!
            puzzle[i][0].orientWith(top: puzzle[i - 1][0].bottomEdge, left: edge)
        }

        puzzle[cornerIdx][0].rotateEdge(puzzle[cornerIdx - 1][0].bottomEdge, to: .top)
        if !tiles.findOutsideEdges(of: puzzle[cornerIdx][0]).contains(puzzle[cornerIdx][0].leftEdge) {
            puzzle[cornerIdx][0].flipVertically()
        }
    }

    mutating func fixRowOrientation(rowIdx: Int) {
        for i in 1..<puzzle.count {
            puzzle[rowIdx][i].orientWith(top: puzzle[rowIdx - 1][i].bottomEdge, left: puzzle[rowIdx][i - 1].rightEdge)
        }
    }

    mutating func rotateTiles() {
        let bottom = puzzle[0][0].commonEdge(with: puzzle[1][0])!
        let right = puzzle[0][0].commonEdge(with: puzzle[0][1])!    
        puzzle[0][0].orientWith(bottom: bottom, right: right)

        fixTopEdgeOrientation()
        fixLeftEdgeOrientation()
        for i in 1..<puzzle.count {
            fixRowOrientation(rowIdx: i)
        }
    }

    func printPuzzleIds() {
        for row in puzzle {
            let values: [String] = row.map {
                if $0 == .placeholder {
                    return "----"
                } else {
                    return "\($0.id)"
                }
            }
            print(values)
        }
    }

    func printPuzzle(showIds: Bool, removeBorders: Bool) {
        var tileSize = puzzle[0][0].data.count
        if removeBorders { tileSize -= 2 }

        for row in puzzle {
            for i in 0..<tileSize {
                var str = ""
                for tile in row {
                    let data = removeBorders ? tile.dataWithoutBorder : tile.data
                    if showIds {
                        str += "\(tile.id) "
                    }
                    str += data[i] + " "
                }
                print(str)
            }
            print()
        }
    }
}
