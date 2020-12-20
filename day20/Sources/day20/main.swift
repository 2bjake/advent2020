import Foundation

let tiles = input.components(separatedBy: "\n\n").map(Tile.init)

let tilesByEdge: [Edge: [Tile]] = tiles.reduce(into: [:]) { result, value in
    for edge in value.edges {
        result[edge, default: []].append(value)
    }
}

//print(tilesByEdge.values.map(\.count))

let edgeTiles = Set(tilesByEdge.values.filter { $0.count == 1 }.flatMap { $0 })
//print(edgeTiles.count)

//let edgeTilesByEdge: [Edge: [Tile]] = edgeTiles.reduce(into: [:]) { result, value in
//    for edge in value.edges {
//        result[edge, default: []].append(value)
//    }
//}
//
//print(edgeTilesByEdge.values.map(\.count))

let edgeToCount: [Edge: Int] = edgeTiles.reduce(into: [:]) { result, value in
    for edge in value.edges {
        result[edge, default: 0] += 1
    }
}

let cornerTiles = edgeTiles.filter { tile in
    guard tile.horizontalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
    guard tile.verticalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
    return true
}

print(cornerTiles.map(\.id).reduce(1, *))
