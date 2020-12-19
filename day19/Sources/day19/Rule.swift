//
//  Rule.swift
//
//
//  Created by Jake Foster on 12/19/20.
//

import Foundation

struct Pair<T> {
    let first: T
    let second: T?
    let third: T?
}

extension Pair {
    init?(_ source: [T]) {
        guard let first = source.first else { return nil }
        let second = source.dropFirst().first
        let third = source.dropFirst(2).first
        self.init(first: first, second: second, third: third)
    }
}

struct Rule {
    enum Value {
        case base(String)
        case compound([Pair<String>])
    }
    let id: String
    let value: Value
}

extension Rule {
    init?(_ source: String) {
        let parts = source.components(separatedBy: ":")
        guard parts.count == 2 else { return nil }
        let id = parts[0]
        let rawRules = parts[1].components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces)}
        if rawRules.count == 1 && rawRules[0].first == "\"" {
            let value = String(rawRules[0].dropFirst().first!)
            self.init(id: id, value: .base(value))
        } else {
            let pair = rawRules.compactMap {
                Pair($0.components(separatedBy: " "))
            }
            self.init(id: id, value: .compound(pair))
        }
    }
}
