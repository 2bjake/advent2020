//
//  Bag.swift
//  
//
//  Created by Jake Foster on 12/7/20.
//

typealias Content = (count: Int, color: String)

class Bag {
    let color: String
    let contains: [Content]
    var parents: Set<Bag> = []

    init(color: String, contains: [Content]) {
        self.color = color
        self.contains = contains
    }
}

extension Bag: Hashable {
    static func == (lhs: Bag, rhs: Bag) -> Bool {
        lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
    }
}

struct BagRegistry {
    var bags: [String: Bag]

    init(bags: [Bag]) {
        self.bags = bags.reduce(into: [:]) { result, value in
            result[value.color] = value
        }
        calulateParents()
    }

    func calulateParents() {
        for parent in bags.values {
            for childContent in parent.contains {
                if let child = bags[childContent.color] {
                    child.parents.insert(parent)
                }
            }
        }
    }
}
