import Foundation

var mySorter = TileSorter(input)
let cornerTileProduct = mySorter.cornerTiles.map(\.id).reduce(1, *)
print("answer to part one: \(cornerTileProduct)") // 4006801655873

var solver = Solver(sorter: mySorter, size: 12)
solver.placeTiles()
solver.printPuzzle()
