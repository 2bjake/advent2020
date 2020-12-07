//
//  Bag.swift
//  
//
//  Created by Jake Foster on 12/7/20.
//

class Bag {
    let color: String
    let canContain: [String]
    var parents: Set<Bag> = []

    init(color: String, canContain: [String]) {
        self.color = color
        self.canContain = canContain
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
            for childColor in parent.canContain {
                if let child = bags[childColor] {
                    child.parents.insert(parent)
                }
            }
        }
    }
}
