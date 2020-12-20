import Foundation

let sorter = TileSorter(input)
let cornerTileProduct = sorter.cornerTiles.map(\.id).reduce(1, *)
print("answer to part one: \(cornerTileProduct)") // 4006801655873

var puzzle: [[Tile?]] = Array(repeating: Array(repeating: nil, count: 12), count: 12)

puzzle[0][0] = sorter.cornerTiles.randomElement()

//func fillTopEdge() {
//    for i in 1..<(puzzle.count - 1) {
//
//    }
//}
