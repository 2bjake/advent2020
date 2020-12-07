//
//  BagRegistry.swift
//
//
//  Created by Jake Foster on 12/7/20.
//
import Foundation

struct BagRegistry {
    typealias Color = String

    private let bagByColor: [Color: Bag]
    private let parentsByChild: [Color: Set<Color>]

    var shinyGoldBag: Bag { retrieveBag(withColor: "shiny gold")! }

    init(bags: [Bag]) {
        bagByColor = bags.reduce(into: [:]) { result, value in
            result[value.color] = value
        }
        parentsByChild = Self.calculateParentsByChild(for: Array(bagByColor.values))
    }

    private static func calculateParentsByChild(for bags: [Bag]) -> [Color: Set<Color>] {
        var result = [Color: Set<Color>]()
        for parent in bags {
            for (_, childColor) in parent.contents {
                result[childColor, default: []].insert(parent.color)
            }
        }
        return result
    }

    func retrieveParents(of child: Bag) -> [Bag] {
        parentsByChild[child.color]?.compactMap { bagByColor[$0] } ?? []
    }

    func retrieveBag(withColor color: Color) -> Bag? {
        bagByColor[color]
    }
}
