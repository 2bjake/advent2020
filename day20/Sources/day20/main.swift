import Foundation

var tiles = TileManager(input)
let cornerTileProduct = tiles.cornerTiles.map(\.id).reduce(1, *)
print("answer to part one: \(cornerTileProduct)") // 4006801655873

var solver = Solver(tiles: tiles, size: 12)
solver.placeTiles()
solver.puzzle.rotateRight()
solver.puzzle.flipHorizontally()
solver.rotateTiles()
solver.printFullPuzzle(showIds: true)


