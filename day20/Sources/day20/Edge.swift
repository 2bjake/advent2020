//
//  Edge.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

struct Edge {
    let value: String
}

extension Edge {
    init(_ value: String) {
        self.value = value
    }

    init(_ value: [Character]) {
        self.value = String(value)
    }
}

extension Edge: Hashable, Equatable {
    private var flipSet: Set<String> {
        [value, String(value.reversed())]
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.flipSet == rhs.flipSet
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(flipSet)
    }
}
