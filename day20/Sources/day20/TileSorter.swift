//
//  TileSorter.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

enum TileType { case edge, corner, nonEdge }

struct TileSorter {

    //private var tilesByType: [TileType: Set<Tile>]

    var cornerTiles: Set<Tile>
    var edgeTiles: Set<Tile>
    var nonEdgeTiles: Set<Tile>

    var tilesByEdge: [Edge: [Tile]]

    init(_ source: String) {
        let allTiles = Set(source.components(separatedBy: "\n\n").map(Tile.init))

        tilesByEdge = allTiles.reduce(into: [:]) { result, value in
            for edge in value.allEdges {
                result[edge, default: []].append(value)
            }
        }

        edgeTiles = Set(tilesByEdge.values.filter { $0.count == 1 }.flatMap { $0 })

        nonEdgeTiles = allTiles.subtracting(edgeTiles)

        let edgeToCount: [Edge: Int] = edgeTiles.reduce(into: [:]) { result, value in
            for edge in value.allEdges {
                result[edge, default: 0] += 1
            }
        }

        cornerTiles = edgeTiles.filter { tile in
            guard tile.horizontalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
            guard tile.verticalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
            return true
        }
        edgeTiles.subtract(cornerTiles)
    }

//    mutating func removeTile(_ type: TileType, matching: Tile, edge: Edge.Side) -> Tile? {
//
//    }
}
