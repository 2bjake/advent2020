import Foundation

var sorter = TileSorter(input)
let cornerTileProduct = sorter.cornerTiles.map(\.id).reduce(1, *)
print("answer to part one: \(cornerTileProduct)") // 4006801655873

var puzzle: [[Tile?]] = Array(repeating: Array(repeating: nil, count: 12), count: 12)

puzzle[0][0] = sorter.cornerTiles.first

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

func fillTopEdge() {
    let cornerIdx = puzzle.count - 1
    for i in 1..<cornerIdx {
        puzzle[0][i] = sorter.findMatch(.edge, matching: puzzle[0][i - 1]!)
    }

    if puzzle[0][cornerIdx] == nil {
        puzzle[0][cornerIdx] = sorter.findMatch(.corner, matching: puzzle[0][cornerIdx - 1]!)
    }
}

func fillRow(_ rowIdx: Int) {
    for i in rowIdx..<(puzzle.count - 1 - rowIdx) {
        guard let match = sorter.findMatch(.regular, matching: puzzle[rowIdx - 1][i]!) else { fatalError() }
        sorter.removeCommonEdge(match, puzzle[rowIdx][i - 1]!)
        puzzle[rowIdx][i] = match
    }
}

for _ in 0..<4 {
    fillTopEdge()
    puzzle.rotateLeft()
}

for i in 1...5 {
    for _ in 0..<4 {
        fillRow(i)
        puzzle.rotateLeft()
    }
}
printPuzzle()

let ids = puzzle.flatMap { $0 }.map { $0!.id }
print(ids.count)
print(Set(ids).count)

// 2789

