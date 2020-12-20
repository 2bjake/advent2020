//
//  TileManager.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

typealias TilesByEdge = [Edge: Set<Tile>]

private func buildTilesByEdge(_ tiles: Set<Tile>) -> TilesByEdge {
    let tilesByEdge: [Edge: Set<Tile>] = tiles.reduce(into: [:]) { result, value in
        for edge in value.allEdges {
            result[edge, default: []].insert(value)
        }
    }
    return tilesByEdge
}

private func findCornerTiles(edgeTiles: Set<Tile>) -> Set<Tile> {
    let edgeToCount: [Edge: Int] = edgeTiles.reduce(into: [:]) { result, value in
        for edge in value.allEdges {
            result[edge, default: 0] += 1
        }
    }

    let cornerTiles = edgeTiles.filter { tile in
        guard tile.horizontalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
        guard tile.verticalEdges.compactMap({ edgeToCount[$0] }).reduce(0, +) == 3 else { return false }
        return true
    }
    return Set(cornerTiles)
}

struct TileManager {
    var cornerTiles: Set<Tile> {
        Set(tilesByTypeByEdge[.corner]?.values.flatMap { $0 } ?? [])
    }

    private var tilesByTypeByEdge: [TileType: TilesByEdge]

    private let edgeToCount: [Edge: Int]

    init(_ source: String) {
        let allTiles = Set(source.components(separatedBy: "\n\n").map(Tile.init))

        let tilesByEdge: [Edge: [Tile]] = allTiles.reduce(into: [:]) { result, value in
            for edge in value.allEdges {
                result[edge, default: []].append(value)
            }
        }

        var edgeTiles = Set(tilesByEdge.values.filter { $0.count == 1 }.flatMap { $0 })
        let nonEdgeTiles = allTiles.subtracting(edgeTiles)
        let cornerTiles = findCornerTiles(edgeTiles: edgeTiles)
        edgeTiles.subtract(cornerTiles)

        tilesByTypeByEdge = [
            .corner: buildTilesByEdge(cornerTiles),
            .edge: buildTilesByEdge(edgeTiles),
            .regular: buildTilesByEdge(nonEdgeTiles)
        ]

        self.edgeToCount = allTiles.reduce(into: [:]) { result, value in
            for edge in value.allEdges {
                result[edge, default: 0] += 1
            }
        }
    }

    mutating func removeEdge(_ edge: Edge) {
        tilesByTypeByEdge[.corner]?[edge] = nil
        tilesByTypeByEdge[.edge]?[edge] = nil
        tilesByTypeByEdge[.regular]?[edge] = nil
    }

    // returns the tile of the specified type which matches an edge of the specified tile.
    // NOTE: if a match is found, the edge is removed from the sorter so it won't be found again
    mutating func findMatch(_ type: TileType, matching: Tile) -> Tile? {
        for edge in matching.allEdges {
            if let tiles = tilesByTypeByEdge[type]?[edge], let tile = tiles.first(where: { $0 != matching }) {
                removeEdge(edge)
                return tile
            }
        }
        return nil
    }

    mutating func removeCommonEdge(_ a: Tile, _ b: Tile) {
        guard let edge = a.commonEdge(with: b) else { fatalError("didn't find a common edge")}
        removeEdge(edge)
    }

    func findOutsideEdges(of tile: Tile) -> [Edge] {
        tile.allEdges.filter { edgeToCount[$0] == 1 }
    }
}
