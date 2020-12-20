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
    var data: [[Character]]
}

extension Tile {
    static let placeholder = Tile(id: -1, data: [])
}

extension Tile {
    var topEdge: Edge { Edge(data.first!) }
    var bottomEdge: Edge { Edge(data.last!) }
    var leftEdge: Edge { Edge(data.buildColumn(at: 0)) }
    var rightEdge: Edge { Edge(data.buildColumn(at: data[0].count - 1)) }

    func getEdge(_ side: Edge.Side) -> Edge {
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

    func commonEdge(with other: Tile) -> Edge? {
        let commonEdges = Set(allEdges).intersection(other.allEdges)
        guard let edge = commonEdges.first, commonEdges.count == 1 else { return nil }
        return edge
    }
}

extension Tile {
    mutating func orientWith(top: Edge, left: Edge) {
        rotateEdge(top, to: .top)
        if leftEdge != left {
            flipVertically()
        }
    }

    mutating func orientWith(bottom: Edge, right: Edge) {
        rotateEdge(bottom, to: .bottom)
        if rightEdge != right {
            flipVertically()
        }
    }

    mutating func rotateEdge(_ edge: Edge, to side: Edge.Side) {
        while getEdge(side) != edge {
            data.rotateLeft()
        }
    }

    mutating func flipVertically() {
        data.flipVertically()
    }

    mutating func flipHorizontally() {
        data.flipHorizontally()
    }
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
