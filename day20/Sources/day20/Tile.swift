//
//  Tile.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

enum TileType { case edge, corner, regular }

struct Tile: Hashable {
    let id: Int
    let data: [[Character]]
}

extension Tile {
    var topEdge: Edge { Edge(data.first!) }
    var bottomEdge: Edge { Edge(data.last!) }
    var leftEdge: Edge { Edge(data.buildColumn(at: 0)) }
    var rightEdge: Edge { Edge(data.buildColumn(at: data[0].count - 1)) }

    func edge(_ side: Edge.Side) -> Edge {
        switch side {
            case .top: return topEdge
            case .bottom: return bottomEdge
            case .left: return leftEdge
            case .right: return rightEdge
        }
    }

    var horizontalEdges: [Edge] { [topEdge, bottomEdge] }
    var verticalEdges: [Edge] { [leftEdge, rightEdge] }

    var allEdges: [Edge] { horizontalEdges + verticalEdges }
}

extension Tile {
    init(_ source: String) {
        let lines = source.components(separatedBy: "\n")
        id = Int(lines.first!.dropFirst(5).prefix(4))!
        data = lines.dropFirst().map(Array.init)

    }
}

extension Tile: CustomStringConvertible {
    var description: String { "\(id)" }
}
