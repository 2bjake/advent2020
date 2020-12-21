import Foundation

var tiles = TileManager(input)
let cornerTileProduct = tiles.cornerTiles.map(\.id).reduce(1, *)
print("answer to part one: \(cornerTileProduct)") // 4006801655873

var solver = Solver(tiles: tiles, size: 12)
solver.placeTiles()
solver.rotateTiles()

var hunter = MonsterHunter(tiles: solver.puzzle)
hunter.photo.flipVertically()
let (_, roughnessCount) = hunter.analyzePhoto()
hunter.printPhoto()
print("answer to part two: \(roughnessCount)") // 1838
