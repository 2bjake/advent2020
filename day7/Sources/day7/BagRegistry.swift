//
//  BagRegistry.swift
//
//
//  Created by Jake Foster on 12/7/20.
//

struct BagRegistry {
    typealias Color = String

    private let bags: [Color: Bag]
    private var parents: [Color: Set<Color>] = [:]

    var shinyGoldBag: Bag { retrieveBag(withColor: "shiny gold")! }

    init(bags: [Bag]) {
        self.bags = bags.reduce(into: [:]) { result, value in
            result[value.color] = value
        }
        calulateParents()
    }

    private mutating func calulateParents() {
        for parent in bags.values {
            for content in parent.contents {
                if let child = bags[content.color] {
                    parents[child.color, default: []].insert(parent.color)
                }
            }
        }
    }

    func retrieveParents(of child: Bag) -> [Bag] {
        parents[child.color]?.compactMap { bags[$0] } ?? []
    }

    func retrieveBag(withColor color: Color) -> Bag? {
        bags[color]
    }
}
