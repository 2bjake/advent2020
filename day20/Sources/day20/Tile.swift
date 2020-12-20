//
//  Tile.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

struct Tile {
    let id: Int
    let data: [[Character]]

    var horizontalEdges: [Edge] {
        guard let first = data.first, let last = data.last else { return [] }
        return [Edge(first), Edge(last)]
    }

    var verticalEdges: [Edge] {
        let first = data.buildColumn(at: 0)
        let last = data.buildColumn(at: data[0].count - 1)
        return [Edge(first), Edge(last)]
    }

    var edges: [Edge] {
        horizontalEdges + verticalEdges
    }
}

extension Tile: Hashable {}

extension Tile {
    init(_ source: String) {
        let lines = source.components(separatedBy: "\n")
        id = Int(lines.first!.dropFirst(5).prefix(4))!
        data = lines.dropFirst().map(Array.init)

    }
}
